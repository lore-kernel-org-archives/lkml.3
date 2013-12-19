Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3LSTz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:55:27 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:43500 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:55:24 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: masami.hiramatsu.pt@hitachi.com, tom.zanussi@linux.intel.com,
        gnurou@gmail.com
Cc: rostedt@goodmis.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2] Tracing events with GPIOs
Date: Thu, 19 Dec 2013 20:54:36 +0100
Message-Id: <1387482876-17454-2-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387482876-17454-1-git-send-email-jjhiblot@traphandler.com>
References: <1387482876-17454-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new tracing mechanism based on event triggers and using GPIO.
Debugging with GPIO is very common in the embedded world. At least for those of us
fortunate enough to have an oscilloscope or a logic analyzer on their bench...
This is especially true if the issue results of a hardware/sofware interaction.

Typical use cases are :
* mixed software/hardware debugging. For example when the software detects a
  situation of interest (typically an error) it toggles a GPIO to trigger the
  oscilloscope acquisition.
* direct latency/duration measurements.

usage :

echo "gpio:<action>:<gpioid>[:<count>] [filter]" > /sys/kernel/debug/tracing/events/myevent/trigger

possible actions are :
* set
* clear
* toggle
* pulse
* pulsehigh
* pulselow

changes since v1:
* use event trigger instead of kprobes
* don't request the gpio anymore.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 include/linux/ftrace_event.h        |   1 +
 kernel/trace/trace_events_trigger.c | 285 ++++++++++++++++++++++++++++++++++++
 2 files changed, 286 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 03d2db2..ce7b2c6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -353,6 +353,7 @@ enum event_trigger_type {
 	ETT_SNAPSHOT		= (1 << 1),
 	ETT_STACKTRACE		= (1 << 2),
 	ETT_EVENT_ENABLE	= (1 << 3),
+	ETT_GPIO		= (1 << 4),
 };
 
 extern void destroy_preds(struct ftrace_event_file *file);
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f5b3f78..11acbe6 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
 
 #include "trace.h"
 
@@ -850,6 +851,289 @@ static struct event_command trigger_traceoff_cmd = {
 	.set_filter		= set_trigger_filter,
 };
 
+#ifdef CONFIG_GPIOLIB
+
+static void gpio_clear(int gpio)
+{
+	gpio_set_value(gpio, 0);
+}
+static void gpio_set(int gpio)
+{
+	gpio_set_value(gpio, 1);
+}
+static void gpio_toggle(int gpio)
+{
+	gpio_set_value(gpio, gpio_get_value(gpio) ? 0 : 1);
+}
+static void gpio_pulse(int gpio)
+{
+	int val = gpio_get_value(gpio) ? 1 : 0;
+	gpio_set_value(gpio, 1 - val);
+	gpio_set_value(gpio, val);
+}
+static void gpio_pulse_high(int gpio)
+{
+	gpio_set_value(gpio, 1);
+	gpio_set_value(gpio, 0);
+}
+static void gpio_pulse_low(int gpio)
+{
+	gpio_set_value(gpio, 0);
+	gpio_set_value(gpio, 1);
+}
+
+struct gpio_action {
+	const char *name;
+	void (*func) (int);
+	int initial_state;
+};
+
+static const struct gpio_action gpio_actions[] = {
+	{"set", gpio_set, 0},
+	{"clear", gpio_clear, 1},
+	{"toggle", gpio_toggle, -1},
+	{"pulse", gpio_pulse, -1},
+	{"pulsehigh", gpio_pulse_high, 0},
+	{"pulselow", gpio_pulse_low, 1}
+};
+struct gpio_data {
+	int gpio;
+	const struct gpio_action *action;
+};
+
+static void
+gpio_trigger(struct event_trigger_data *data)
+{
+	struct gpio_data *gpio_data = data->private_data;
+	gpio_data->action->func(gpio_data->gpio);
+}
+
+static void
+gpio_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	gpio_trigger(data);
+}
+
+static int
+gpio_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       struct event_trigger_data *data)
+{
+	struct gpio_data *gpio_data = data->private_data;
+	char tmp[40];
+	snprintf(tmp, sizeof(tmp), "gpio:%s:%d", gpio_data->action->name,
+		 gpio_data->gpio);
+	return event_trigger_print(tmp, m, (void *)data->count,
+				   data->filter_str);
+}
+
+static void
+gpio_trigger_free(struct event_trigger_ops *ops,
+			  struct event_trigger_data *data)
+{
+	struct gpio_data *gpio_data = data->private_data;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		trigger_data_free(data);
+		kfree(gpio_data);
+	}
+}
+
+
+static struct event_trigger_ops gpio_trigger_ops = {
+	.func			= gpio_trigger,
+	.print			= gpio_trigger_print,
+	.init			= event_trigger_init,
+	.free			= gpio_trigger_free,
+};
+
+static struct event_trigger_ops gpio_count_trigger_ops = {
+	.func			= gpio_count_trigger,
+	.print			= gpio_trigger_print,
+	.init			= event_trigger_init,
+	.free			= gpio_trigger_free,
+};
+
+static struct event_trigger_ops *
+gpio_get_trigger_ops(char *cmd, char *param)
+{
+	return param ? &gpio_count_trigger_ops : &gpio_trigger_ops;
+}
+
+
+/**
+ * gpio_event_trigger_callback - GPIO event_command @func implementation
+ * @cmd_ops: The command ops, used for trigger registration
+ * @file: The ftrace_event_file associated with the event
+ * @glob: The raw string used to register the trigger
+ * @cmd: The cmd portion of the string used to register the trigger
+ * @param: The params portion of the string used to register the trigger
+ *
+ * implementation for GPIO event command parsing and trigger
+ * instantiation.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int
+gpio_event_trigger_callback(struct event_command *cmd_ops,
+		       struct ftrace_event_file *file,
+		       char *glob, char *cmd, char *param)
+{
+	struct gpio_data *gpio_data = NULL;
+	struct event_trigger_data *trigger_data = NULL;
+	struct event_trigger_ops *trigger_ops;
+	char *action_str = NULL;
+	char *gpio_str = NULL;
+	char *count_str = NULL;
+	long count = -1;
+	unsigned long gpio;
+	const struct gpio_action *action = NULL;
+	int ret;
+	int i;
+
+	if (!param)
+		return -EINVAL;
+
+	action_str = strsep(&param, ":");
+	if (!action_str) {
+		pr_debug("missing gpio action\n");
+		return -EINVAL;
+	}
+
+	gpio_str = strsep(&param, ":");
+	if (!gpio_str) {
+		pr_debug("no gpio id provided\n");
+		return -EINVAL;
+	}
+
+	count_str = strsep(&param, " \t");
+
+	for (i = 0; i < ARRAY_SIZE(gpio_actions); i++) {
+		if (strcmp(action_str, gpio_actions[i].name) == 0) {
+			action = &gpio_actions[i];
+			break;
+		}
+	}
+	if (!action) {
+		pr_debug("gpio action '%s' not recognized\n", action_str);
+		return -EINVAL;
+	}
+
+	ret = kstrtoul(gpio_str, 0, &gpio);
+	if (ret) {
+		pr_debug("gpio [%s] is not a valid gpio id\n", gpio_str);
+		return -EINVAL;
+	}
+
+	if (count_str) {
+		ret = kstrtoul(count_str, 0, &count);
+		if (ret) {
+			pr_debug("count [%s] is not a valid count value\n",
+				 count_str);
+			return -EINVAL;
+		}
+	}
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, count_str);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
+	if (!gpio_data)
+		goto out_free;
+
+	gpio_data->gpio = gpio;
+	gpio_data->action = action;
+
+	trigger_data->count = count;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	trigger_data->private_data = gpio_data;
+	INIT_LIST_HEAD(&trigger_data->list);
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
+		ret = 0;
+		goto out_free;
+	}
+
+	if (!param) /* if param is non-empty, it's supposed to be a filter */
+		goto out_reg;
+
+	if (!cmd_ops->set_filter)
+		goto out_reg;
+
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_free;
+	} else if (ret < 0)
+		goto out_free;
+
+	if (gpio_cansleep(gpio))
+		pr_warn("Using gpio %s as a tracer may break your kernel!\n",
+			gpio_str);
+
+	gpio_direction_output(gpio, (action->initial_state == 0) ? 0 : 1);
+
+	ret = 0;
+ out:
+	return ret;
+
+ out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
+	kfree(trigger_data);
+	kfree(gpio_data);
+	goto out;
+}
+
+
+static struct event_command trigger_gpio_cmd = {
+	.name			= "gpio",
+	.trigger_type		= ETT_GPIO,
+	.func			= gpio_event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= gpio_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static __init int register_trigger_gpio_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_gpio_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+#else
+static __init int register_trigger_gpio_cmd(void) { return 0; }
+#endif /* CONFIG_GPIOLIB */
+
 #ifdef CONFIG_TRACER_SNAPSHOT
 static void
 snapshot_trigger(struct event_trigger_data *data)
@@ -1404,6 +1688,7 @@ __init int register_trigger_cmds(void)
 	register_trigger_snapshot_cmd();
 	register_trigger_stacktrace_cmd();
 	register_trigger_enable_disable_cmds();
+	register_trigger_gpio_cmd();
 
 	return 0;
 }
-- 
1.8.3.1

