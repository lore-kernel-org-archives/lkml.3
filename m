Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3LMO1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:27:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3LMO1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:27:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
From: David Howells <dhowells@redhat.com>
To: khali@linux-fr.org
Cc: dhowells@redhat.com, linux-i2c@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2013 14:26:27 +0000
Message-ID: <20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints into the I2C and SMBUS message transfer functions to retrieve
the message sent or received.  The following config options must be turned on
to make use of the facility:

	CONFIG_FTRACE
	CONFIG_ENABLE_DEFAULT_TRACERS

The I2C tracepoint can be enabled thusly:

	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable

and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
that look like:

        ... i2c_transfer: i2c-5 f=00 a=44 l=6 ret=1 [021433000000]

formatted as:

	i2c-<adapter-nr>
	f=<flags>
	a=<addr>
	l=<datalen>
	ret=<result>
	[<data>]

(Bit 0 of the flags is set if this was a read and clear if it was a write).


The SMBUS tracepoint can be enabled thusly:

	echo 1 >/sys/kernel/debug/tracing/events/i2c/smbus_transfer/enable

and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
that look like:

	... smbus_transfer: i2c-0 f=00 a=51 r=1 c=0 p=2 res=0 [80ff0100000000000000800c693d0088ffffb83aee3b0088ffff0100000000000000]

formatted as:

	i2c-<adapter-nr>
	f=<flags>
	a=<addr>
	r=<read_write>
	c=<command>
	p=<protocol>
	res=<result>
	[<data-block>]


In both cases, the adapters to be traced can be selected by something like:

	echo adapter_nr==1 >/sys/kernel/debug/tracing/events/i2c/{i2c,smbus}_transfer/filter

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---

 drivers/i2c/i2c-core.c     |   38 ++++++++++++++++--
 include/trace/events/i2c.h |   95 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/events/i2c.h

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b34248e..2128e106ca97 100644
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
@@ -1720,6 +1736,16 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			break;
 	}
 
+	/* i2c_trace_msg gets enabled when tracepoint i2c_transfer gets
+	 * enabled.  This is an efficient way of keeping the for-loop from
+	 * being executed when not needed.
+	 */
+	if (static_key_false(&i2c_trace_msg)) {
+		int i;
+		for (i = 0; i < num; i++)
+			trace_i2c_transfer(adap, &msgs[i], ret);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(__i2c_transfer);
@@ -2535,15 +2561,21 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 		i2c_unlock_adapter(adapter);
 
 		if (res != -EOPNOTSUPP || !adapter->algo->master_xfer)
-			return res;
+			goto trace;
 		/*
 		 * Fall back to i2c_smbus_xfer_emulated if the adapter doesn't
 		 * implement native support for the SMBus operation.
 		 */
 	}
 
-	return i2c_smbus_xfer_emulated(adapter, addr, flags, read_write,
-				       command, protocol, data);
+	res = i2c_smbus_xfer_emulated(adapter, addr, flags, read_write,
+				      command, protocol, data);
+
+trace:
+	trace_smbus_transfer(adapter, addr, flags, read_write,
+			     command, protocol, data, res);
+
+	return res;
 }
 EXPORT_SYMBOL(i2c_smbus_xfer);
 
diff --git a/include/trace/events/i2c.h b/include/trace/events/i2c.h
new file mode 100644
index 000000000000..ed366e145c8d
--- /dev/null
+++ b/include/trace/events/i2c.h
@@ -0,0 +1,95 @@
+/* I2C message transfer tracepoint
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
+TRACE_EVENT_FN(i2c_transfer,
+	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
+			int ret),
+	       TP_ARGS(adap, msg, ret),
+	       TP_STRUCT__entry(
+		       __field(	int,	adapter_nr		)
+		       __field(__u16,	addr			)
+		       __field(__u16,	flags			)
+		       __field(__u16,	len			)
+		       __field(__s16,	ret			)
+		       __dynamic_array(__u8, buf, msg->len)	),
+	       TP_fast_assign(
+		       __entry->adapter_nr = adap->nr;
+		       __entry->addr = msg->addr;
+		       __entry->flags = msg->flags;
+		       __entry->len = msg->len;
+		       __entry->ret = ret;
+		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
+			      ),
+	       TP_printk("i2c-%d f=%02x a=%02x l=%u ret=%d [%*phN]",
+			 __entry->adapter_nr,
+			 __entry->flags,
+			 __entry->addr,
+			 __entry->len,
+			 __entry->ret,
+			 __entry->len, __get_dynamic_array(buf)
+			 ),
+	       i2c_transfer_trace_reg,
+	       i2c_transfer_trace_unreg);
+
+TRACE_EVENT(smbus_transfer,
+	    TP_PROTO(const struct i2c_adapter *adap,
+		     u16 addr, unsigned short flags,
+		     char read_write, u8 command, int protocol,
+		     const union i2c_smbus_data *data, int res),
+	    TP_ARGS(adap, addr, flags, read_write, command, protocol, data, res),
+	    TP_STRUCT__entry(
+		    __field(int,	adapter_nr		)
+		    __field(__u16,	addr			)
+		    __field(__u16,	flags			)
+		    __field(__u8,	read_write		)
+		    __field(__u8,	command			)
+		    __field(__s16,	res			)
+		    __field(__u32,	protocol		)
+		    __array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	    TP_fast_assign(
+		    __entry->adapter_nr = adap->nr;
+		    __entry->addr = addr;
+		    __entry->flags = flags;
+		    __entry->read_write = read_write;
+		    __entry->command = command;
+		    __entry->protocol = protocol;
+		    __entry->res = res;
+		    memcpy(__entry->buf, data->block, I2C_SMBUS_BLOCK_MAX + 2);
+			   ),
+	    TP_printk("i2c-%d f=%02x a=%02x r=%x c=%x p=%x res=%d [%*phN]",
+		      __entry->adapter_nr,
+		      __entry->flags,
+		      __entry->addr,
+		      __entry->read_write,
+		      __entry->command,
+		      __entry->protocol,
+		      __entry->res,
+		      I2C_SMBUS_BLOCK_MAX + 2, __entry->buf
+		      ));
+
+#endif /* _TRACE_I2C_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

