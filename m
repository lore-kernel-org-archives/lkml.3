Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LQBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:16:26 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34726 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LQBQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:16:24 -0500
Message-ID: <52AFA5E0.7040707@hitachi.com>
Date: Tue, 17 Dec 2013 10:16:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        tom.zanussi@linux.intel.com
Cc: rostedt@goodmis.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracing events with GPIOs
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/17 9:22), Jean-Jacques Hiblot wrote:
> This patch implements a new tracing mechanism based on kprobes and using GPIO.
> Debugging with GPIO is very common in the embedded world. At least for those of us
> fortunate enough to have an oscilloscope or a logic analyzer on their bench...
> This is especially true if the issue results of a hardware/sofware interaction.
> 
> Typical use cases are :
> * mixed software/hardware debugging. For example when the software detects a
>   situation of interest (typically an error) it toggles a GPIO to trigger the
>   oscilloscope acquisition.
> * direct latency/duration measurements.

Ah, it's interesting to me :)

And I think this feature should be built on the event triggers which
Tom is working on, instead of kprobes directly, because it allows
you to take gpio actions on normal tracepoints, and uprobes too :)

Thank you!

> 
> examples:
> To trig the oscilloscope whenever a mmc command error:
>   echo "p:my_mmc_blk_error mmc_blk_cmd_error gpiopulse@13" > /sys/kernel/debug/tracing/kprobe_events
>   echo 1 > /sys/kernel/debug/tracing/events/kprobes/my_mmc_blk_error/enable
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  kernel/trace/Kconfig        |  12 ++++
>  kernel/trace/trace_kprobe.c | 167 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 177 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 015f85a..4228768 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -420,6 +420,18 @@ config KPROBE_EVENT
>  	  This option is also required by perf-probe subcommand of perf tools.
>  	  If you want to use perf tools, this option is strongly recommended.
>  
> +config KPROBE_EVENT_GPIO
> +	depends on KPROBE_EVENT
> +	depends on GPIOLIB
> +	bool "Enable kprobes-based tracing of events via GPIO"
> +	default n
> +	help
> +		This allows the user to use GPIOs as a tracing tool.The primary
> +		purpose of this option is to allow the user to trigger an
> +		oscilloscope on software events.
> +		The GPIO can be set, cleared, toggled, or pulsed when the event
> +		is hit.
> +
>  config UPROBE_EVENT
>  	bool "Enable uprobes-based dynamic events"
>  	depends on ARCH_SUPPORTS_UPROBES
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index dae9541..5d297f5 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -19,6 +19,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
> +#include <linux/gpio.h>
>  
>  #include "trace_probe.h"
>  
> @@ -27,6 +28,33 @@
>  /**
>   * Kprobe event core functions
>   */
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +#define TP_GPIO_UNDEFINED      0
> +#define TP_GPIO_CMD_SET                1
> +#define TP_GPIO_CMD_CLEAR      2
> +#define TP_GPIO_CMD_TOGGLE     3
> +#define TP_GPIO_CMD_PULSE      4
> +#define TP_GPIO_CMD_PULSE_HIGH 5
> +#define TP_GPIO_CMD_PULSE_LOW  6
> +
> +static const struct {
> +	const char *name;
> +	int action;
> +} gpio_actions[] = {
> +	{"gpioset", TP_GPIO_CMD_SET},
> +	{"gpioclear", TP_GPIO_CMD_CLEAR},
> +	{"gpiotoggle", TP_GPIO_CMD_TOGGLE},
> +	{"gpiopulse", TP_GPIO_CMD_PULSE},
> +	{"gpiopulsehigh", TP_GPIO_CMD_PULSE_HIGH},
> +	{"gpiopulselow", TP_GPIO_CMD_PULSE_LOW},
> +};
> +
> +struct gpio_trace {
> +	int gpio;
> +	int action;
> +};
> +#endif
> +
>  struct trace_probe {
>  	struct list_head	list;
>  	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
> @@ -38,6 +66,9 @@ struct trace_probe {
>  	struct list_head	files;
>  	ssize_t			size;		/* trace entry size */
>  	unsigned int		nr_args;
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	struct gpio_trace               gpio_trace;
> +#endif
>  	struct probe_arg	args[];
>  };
>  
> @@ -164,10 +195,24 @@ error:
>  	return ERR_PTR(ret);
>  }
>  
> +static struct trace_probe *find_gpio_probe(int gpio)
> +{
> +	struct trace_probe *tp;
> +
> +	list_for_each_entry(tp, &probe_list, list)
> +	if ((tp->gpio_trace.action) && (tp->gpio_trace.gpio == gpio))
> +		return tp;
> +	return NULL;
> +}
> +
>  static void free_trace_probe(struct trace_probe *tp)
>  {
>  	int i;
>  
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	if (tp->gpio_trace.action && !find_gpio_probe(tp->gpio_trace.gpio))
> +		gpio_free(tp->gpio_trace.gpio);
> +#endif
>  	for (i = 0; i < tp->nr_args; i++)
>  		traceprobe_free_probe_arg(&tp->args[i]);
>  
> @@ -435,8 +480,14 @@ static int create_trace_probe(int argc, char **argv)
>  {
>  	/*
>  	 * Argument syntax:
> -	 *  - Add kprobe: p[:[GRP/]EVENT] [MOD:]KSYM[+OFFS]|KADDR [FETCHARGS]
> -	 *  - Add kretprobe: r[:[GRP/]EVENT] [MOD:]KSYM[+0] [FETCHARGS]
> +	 *  - Add kprobe: p[:[GRP/]EVENT] [MOD:]KSYM[+OFFS]|KADDR
> +	 *                [GPIOACTION@GPIONUM] [FETCHARGS]
> +	 *  - Add kretprobe: r[:[GRP/]EVENT] [MOD:]KSYM[+0]
> +	 *                   [GPIOACTION@GPIONUM] [FETCHARGS]
> +	 * Gpio tracing:
> +	 *   gpio action can be : gpioset, gpioclear, gpiotoggle, gpiopulse,
> +	 *                        gpiopulsehigh and gpiopulselow
> +	 *   gpionum is the id of the gpio
>  	 * Fetch args:
>  	 *  $retval	: fetch return value
>  	 *  $stack	: fetch stack address
> @@ -459,6 +510,9 @@ static int create_trace_probe(int argc, char **argv)
>  	unsigned long offset = 0;
>  	void *addr = NULL;
>  	char buf[MAX_EVENT_NAME_LEN];
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	int len;
> +#endif
>  
>  	/* argc must be >= 1 */
>  	if (argv[0][0] == 'p')
> @@ -541,6 +595,7 @@ static int create_trace_probe(int argc, char **argv)
>  			return -EINVAL;
>  		}
>  	}
> +
>  	argc -= 2; argv += 2;
>  
>  	/* setup a probe */
> @@ -562,6 +617,66 @@ static int create_trace_probe(int argc, char **argv)
>  		return PTR_ERR(tp);
>  	}
>  
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	/* parse the optionnal gpio action argument */
> +	for (i = 0; argc && (i < ARRAY_SIZE(gpio_actions)); i++) {
> +		len = strlen(gpio_actions[i].name);
> +		if (strncmp(argv[0], gpio_actions[i].name, len) == 0)
> +			break;
> +	}
> +
> +	if (argc && (i < ARRAY_SIZE(gpio_actions))) {
> +		int gpio;
> +		unsigned long ul;
> +		int gpio_requested = 0;
> +		ret = -EINVAL;
> +		if (argv[0][len] != '@') {
> +			pr_info("Syntax error. wrong gpio syntax\n");
> +			goto error;
> +		}
> +
> +		if (kstrtoul(&argv[0][len+1], 0, &ul)) {
> +			pr_info("Failed to parse gpio number.\n");
> +			goto error;
> +		}
> +		gpio = ul;
> +
> +		if (!gpio_is_valid(gpio)) {
> +			pr_info("gpio %d is not valid.\n", gpio);
> +			goto error;
> +		}
> +
> +		if (gpio_cansleep(gpio))
> +			pr_info("gpio %d can sleep. This may break your"
> +				"kernel!!!!!!\n", gpio);
> +
> +		if (!find_gpio_probe(gpio)) {
> +			ret = gpio_request(gpio, event);
> +			if (ret) {
> +				pr_info("can't request gpio %d.\n", gpio);
> +				goto error;
> +			}
> +			gpio_requested = 1;
> +		}
> +
> +		if ((gpio_actions[i].action == TP_GPIO_CMD_CLEAR) ||
> +			(gpio_actions[i].action == TP_GPIO_CMD_PULSE_LOW))
> +			ret = gpio_direction_output(gpio, 1);
> +		else
> +			ret = gpio_direction_output(gpio, 0);
> +		if (ret) {
> +			pr_info("can't make gpio %d an output.\n", gpio);
> +			if (gpio_requested)
> +				gpio_free(gpio);
> +			goto error;
> +		}
> +
> +		tp->gpio_trace.gpio = gpio;
> +		tp->gpio_trace.action = gpio_actions[i].action;
> +		argc -= 1; argv += 1;
> +	}
> +#endif
> +
>  	/* parse arguments */
>  	ret = 0;
>  	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
> @@ -1145,12 +1260,54 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  }
>  #endif	/* CONFIG_PERF_EVENTS */
>  
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +static __kprobes void kprobe_gpio_take_action(int gpio, int action)
> +{
> +	int val;
> +	switch (action) {
> +	case TP_GPIO_CMD_PULSE_HIGH:
> +		gpio_set_value(gpio, 1);
> +		/* intentionnaly don't break here */
> +	case TP_GPIO_CMD_CLEAR:
> +		gpio_set_value(gpio, 0);
> +	break;
> +
> +	case TP_GPIO_CMD_PULSE_LOW:
> +		gpio_set_value(gpio, 0);
> +		/* intentionnaly don't break here */
> +	case TP_GPIO_CMD_SET:
> +		gpio_set_value(gpio, 1);
> +	break;
> +
> +	case TP_GPIO_CMD_TOGGLE:
> +		val = gpio_get_value(gpio);
> +		gpio_set_value(gpio, val ? 0 : 1);
> +	break;
> +
> +	case TP_GPIO_CMD_PULSE:
> +		val = gpio_get_value(gpio);
> +		gpio_set_value(gpio, val ? 0 : 1);
> +		gpio_set_value(gpio, val);
> +	break;
> +	}
> +}
> +
>  /*
>   * called by perf_trace_init() or __ftrace_set_clr_event() under event_mutex.
>   *
>   * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
>   * lockless, but we can't race with this __init function.
>   */
> +/* Kprobe gpio handler */
> +static inline __kprobes void kprobe_gpio_func(struct trace_probe *tp,
> +					      struct pt_regs *regs)
> +{
> +	if (tp->gpio_trace.action)
> +		kprobe_gpio_take_action(tp->gpio_trace.gpio,
> +					tp->gpio_trace.action);
> +}
> +#endif /* CONFIG_KPROBE_EVENT_GPIO */
> +
>  static __kprobes
>  int kprobe_register(struct ftrace_event_call *event,
>  		    enum trace_reg type, void *data)
> @@ -1186,6 +1343,9 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
>  
>  	tp->nhit++;
>  
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	kprobe_gpio_func(tp, regs);
> +#endif
>  	if (tp->flags & TP_FLAG_TRACE)
>  		kprobe_trace_func(tp, regs);
>  #ifdef CONFIG_PERF_EVENTS
> @@ -1202,6 +1362,9 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>  
>  	tp->nhit++;
>  
> +#ifdef CONFIG_KPROBE_EVENT_GPIO
> +	kprobe_gpio_func(tp, regs);
> +#endif
>  	if (tp->flags & TP_FLAG_TRACE)
>  		kretprobe_trace_func(tp, ri, regs);
>  #ifdef CONFIG_PERF_EVENTS
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


