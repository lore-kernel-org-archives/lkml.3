Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbaAIVuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:50:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673AbaAIVuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:50:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
From: David Howells <dhowells@redhat.com>
To: wolfram@the-dreams.de
Cc: khali@linux-fr.org, dhowells@redhat.com, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Date: Thu, 09 Jan 2014 21:49:54 +0000
Message-ID: <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints into the I2C message transfer function to retrieve the message
sent or received.  The following config options must be turned on to make use
of the facility:

	CONFIG_FTRACE
	CONFIG_ENABLE_DEFAULT_TRACERS

The I2C tracepoint can be enabled thusly:

	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable

and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
that look like:

	... i2c_write: i2c-5 #0 f=00 a=44 l=2 [0214]
	... i2c_read: i2c-5 #1 f=01 a=44 l=4
	... i2c_reply: i2c-5 #1 f=01 a=44 l=4 [33000000]
	... i2c_result: i2c-5 n=2 ret=2

formatted as:

	i2c-<adapter-nr>
	#<message-array-index>
	f=<flags>
	a=<addr>
	l=<datalen>
	n=<message-array-size>
	ret=<result>
	[<data>]

The operation is done between the i2c_write/i2c_read lines and the i2c_reply
and i2c_result lines so that if the hardware hangs, the trace buffer can be
consulted to determine the problematic operation.

The adapters to be traced can be selected by something like:

	echo adapter_nr==1 >/sys/kernel/debug/tracing/events/i2c/filter

These changes are based on code from Steven Rostedt.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---

 drivers/i2c/i2c-core.c     |   37 +++++++++++
 include/trace/events/i2c.h |  150 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+)
 create mode 100644 include/trace/events/i2c.h

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b34248e..c8b97490461d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -48,10 +48,13 @@
 #include <linux/rwsem.h>
 #include <linux/pm_runtime.h>
 #include <linux/acpi.h>
+#include <linux/jump_label.h>
 #include <asm/uaccess.h>
 
 #include "i2c-core.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/i2c.h>
 
 /* core_lock protects i2c_adapter_idr, and guarantees
    that device detection, deletion of detected devices, and attach_adapter
@@ -62,6 +65,18 @@ static DEFINE_IDR(i2c_adapter_idr);
 static struct device_type i2c_client_type;
 static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver);
 
+static struct static_key i2c_trace_msg = STATIC_KEY_INIT_FALSE;
+
+void i2c_transfer_trace_reg(void)
+{
+	static_key_slow_inc(&i2c_trace_msg);
+}
+
+void i2c_transfer_trace_unreg(void)
+{
+	static_key_slow_dec(&i2c_trace_msg);
+}
+
 /* ------------------------------------------------------------------------- */
 
 static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
@@ -1680,6 +1695,7 @@ static void __exit i2c_exit(void)
 	class_compat_unregister(i2c_adapter_compat_class);
 #endif
 	bus_unregister(&i2c_bus_type);
+	tracepoint_synchronize_unregister();
 }
 
 /* We must initialize early, because some subsystems register i2c drivers
@@ -1710,6 +1726,19 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	unsigned long orig_jiffies;
 	int ret, try;
 
+	/* i2c_trace_msg gets enabled when tracepoint i2c_transfer gets
+	 * enabled.  This is an efficient way of keeping the for-loop from
+	 * being executed when not needed.
+	 */
+	if (static_key_false(&i2c_trace_msg)) {
+		int i;
+		for (i = 0; i < num; i++)
+			if (msgs[i].flags & I2C_M_RD)
+				trace_i2c_read(adap, &msgs[i], i);
+			else
+				trace_i2c_write(adap, &msgs[i], i);
+	}
+
 	/* Retry automatically on arbitration loss */
 	orig_jiffies = jiffies;
 	for (ret = 0, try = 0; try <= adap->retries; try++) {
@@ -1720,6 +1749,14 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			break;
 	}
 
+	if (static_key_false(&i2c_trace_msg)) {
+		int i;
+		for (i = 0; i < ret; i++)
+			if (msgs[i].flags & I2C_M_RD)
+				trace_i2c_reply(adap, &msgs[i], i);
+		trace_i2c_result(adap, i, ret);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(__i2c_transfer);
diff --git a/include/trace/events/i2c.h b/include/trace/events/i2c.h
new file mode 100644
index 000000000000..d30f008527b2
--- /dev/null
+++ b/include/trace/events/i2c.h
@@ -0,0 +1,150 @@
+/* I2C message transfer tracepoints
+ *
+ * Copyright (C) 2013 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM i2c
+
+#if !defined(_TRACE_I2C_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_I2C_H
+
+#include <linux/i2c.h>
+#include <linux/tracepoint.h>
+
+/*
+ * drivers/i2c/i2c-core.c
+ */
+extern void i2c_transfer_trace_reg(void);
+extern void i2c_transfer_trace_unreg(void);
+
+/*
+ * __i2c_transfer() write request
+ */
+TRACE_EVENT_FN(i2c_write,
+	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
+			int num),
+	       TP_ARGS(adap, msg, num),
+	       TP_STRUCT__entry(
+		       __field(int,	adapter_nr		)
+		       __field(__u16,	msg_nr			)
+		       __field(__u16,	addr			)
+		       __field(__u16,	flags			)
+		       __field(__u16,	len			)
+		       __dynamic_array(__u8, buf, msg->len)	),
+	       TP_fast_assign(
+		       __entry->adapter_nr = adap->nr;
+		       __entry->msg_nr = num;
+		       __entry->addr = msg->addr;
+		       __entry->flags = msg->flags;
+		       __entry->len = msg->len;
+		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
+			      ),
+	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u [%*phN]",
+			 __entry->adapter_nr,
+			 __entry->msg_nr,
+			 __entry->flags,
+			 __entry->addr,
+			 __entry->len,
+			 __entry->len, __get_dynamic_array(buf)
+			 ),
+	       i2c_transfer_trace_reg,
+	       i2c_transfer_trace_unreg);
+
+/*
+ * __i2c_transfer() read request
+ */
+TRACE_EVENT_FN(i2c_read,
+	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
+			int num),
+	       TP_ARGS(adap, msg, num),
+	       TP_STRUCT__entry(
+		       __field(int,	adapter_nr		)
+		       __field(__u16,	msg_nr			)
+		       __field(__u16,	addr			)
+		       __field(__u16,	flags			)
+		       __field(__u16,	len			)
+				),
+	       TP_fast_assign(
+		       __entry->adapter_nr = adap->nr;
+		       __entry->msg_nr = num;
+		       __entry->addr = msg->addr;
+		       __entry->flags = msg->flags;
+		       __entry->len = msg->len;
+			      ),
+	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u",
+			 __entry->adapter_nr,
+			 __entry->msg_nr,
+			 __entry->flags,
+			 __entry->addr,
+			 __entry->len
+			 ),
+	       i2c_transfer_trace_reg,
+		       i2c_transfer_trace_unreg);
+
+/*
+ * __i2c_transfer() read reply
+ */
+TRACE_EVENT_FN(i2c_reply,
+	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
+			int num),
+	       TP_ARGS(adap, msg, num),
+	       TP_STRUCT__entry(
+		       __field(int,	adapter_nr		)
+		       __field(__u16,	msg_nr			)
+		       __field(__u16,	addr			)
+		       __field(__u16,	flags			)
+		       __field(__u16,	len			)
+		       __dynamic_array(__u8, buf, msg->len)	),
+	       TP_fast_assign(
+		       __entry->adapter_nr = adap->nr;
+		       __entry->msg_nr = num;
+		       __entry->addr = msg->addr;
+		       __entry->flags = msg->flags;
+		       __entry->len = msg->len;
+		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
+			      ),
+	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u [%*phN]",
+			 __entry->adapter_nr,
+			 __entry->msg_nr,
+			 __entry->flags,
+			 __entry->addr,
+			 __entry->len,
+			 __entry->len, __get_dynamic_array(buf)
+			 ),
+	       i2c_transfer_trace_reg,
+	       i2c_transfer_trace_unreg);
+
+/*
+ * __i2c_transfer() result
+ */
+TRACE_EVENT_FN(i2c_result,
+	       TP_PROTO(const struct i2c_adapter *adap, int num, int ret),
+	       TP_ARGS(adap, num, ret),
+	       TP_STRUCT__entry(
+		       __field(int,	adapter_nr		)
+		       __field(__u16,	nr_msgs			)
+		       __field(__s16,	ret			)
+				),
+	       TP_fast_assign(
+		       __entry->adapter_nr = adap->nr;
+		       __entry->nr_msgs = num;
+		       __entry->ret = ret;
+			      ),
+	       TP_printk("i2c-%d n=%u ret=%d",
+			 __entry->adapter_nr,
+			 __entry->nr_msgs,
+			 __entry->ret
+			 ),
+	       i2c_transfer_trace_reg,
+	       i2c_transfer_trace_unreg);
+
+#endif /* _TRACE_I2C_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

