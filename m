Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3LMR1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:27:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3LMR1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:27:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131213175350.0c4a95d5@endymion.delvare>
References: <20131213175350.0c4a95d5@endymion.delvare> <20131213163349.4bc686c0@endymion.delvare> <20131213142627.4014.42860.stgit@warthog.procyon.org.uk> <3708.1386950736@warthog.procyon.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: dhowells@redhat.com, linux-i2c@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Date: Fri, 13 Dec 2013 17:26:53 +0000
Message-ID: <18214.1386955613@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a tentative patch on top of the previous one to split the messages.  I
haven't tested the I2C side yet and cannot test the SMBUS write.

Each is split four ways:

  (1) i2c/smbus_write - Show write request before submitting

  (2) i2c/smbus_read - Show read request before submitting

  (3) i2c/smbus_reply - Show read reply after submitting (if no failure)

  (4) i2c/smbus_result - Show operation result

So this might give you something like:
 
	... i2c_write: i2c-5 #0 f=00 a=44 l=2 [0800]
	... i2c_read: i2c-5 #1 f=01 a=44 l=1
	... i2c_reply: i2c-5 #1 f=01 a=44 l=1 [fe]
	... i2c_result: n=2 ret=2

from a single __i2c_transfer() given an array of two messages.

Or:

        ... smbus_read: i2c-0 a=51 f=00 c=fc BYTE_DATA
        ... smbus_reply: i2c-0 a=51 f=00 c=fc BYTE_DATA [41ff01000...]
        ... smbus_result: i2c-0 a=51 f=00 c=fc BYTE_DATA rd res=0

from a single i2c_smbus_xfer().

David
---
commit 31d5367657a64453d48b89b09296f7ebc6a5ee94
Author: David Howells <dhowells@redhat.com>
Date:   Fri Dec 13 17:13:19 2013 +0000

    i2c: Split traces

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 2128e106ca97..0dbf0dcff6ce 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1726,6 +1726,19 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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
@@ -1736,14 +1749,12 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			break;
 	}
 
-	/* i2c_trace_msg gets enabled when tracepoint i2c_transfer gets
-	 * enabled.  This is an efficient way of keeping the for-loop from
-	 * being executed when not needed.
-	 */
 	if (static_key_false(&i2c_trace_msg)) {
 		int i;
-		for (i = 0; i < num; i++)
-			trace_i2c_transfer(adap, &msgs[i], ret);
+		for (i = 0; i < ret; i++)
+			if (msgs[i].flags & I2C_M_RD)
+				trace_i2c_reply(adap, &msgs[i], i);
+		trace_i2c_result(adap, i, ret);
 	}
 
 	return ret;
@@ -2541,6 +2552,11 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	int try;
 	s32 res;
 
+	if (read_write == I2C_SMBUS_WRITE)
+		trace_smbus_write(adapter, addr, flags, command, protocol, data);
+	else
+		trace_smbus_read(adapter, addr, flags, command, protocol);
+
 	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_CLIENT_SCCB;
 
 	if (adapter->algo->smbus_xfer) {
@@ -2572,8 +2588,11 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 				      command, protocol, data);
 
 trace:
-	trace_smbus_transfer(adapter, addr, flags, read_write,
-			     command, protocol, data, res);
+	if (read_write == I2C_SMBUS_READ)
+		trace_smbus_reply(adapter, addr, flags,
+				  command, protocol, data);
+	trace_smbus_result(adapter, addr, flags, read_write,
+			   command, protocol, res);
 
 	return res;
 }
diff --git a/include/trace/events/i2c.h b/include/trace/events/i2c.h
index ed366e145c8d..ca19f4948290 100644
--- a/include/trace/events/i2c.h
+++ b/include/trace/events/i2c.h
@@ -23,42 +23,259 @@
 extern void i2c_transfer_trace_reg(void);
 extern void i2c_transfer_trace_unreg(void);
 
-TRACE_EVENT_FN(i2c_transfer,
+/*
+ * __i2c_transfer() write request
+ */
+TRACE_EVENT_FN(i2c_write,
 	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
-			int ret),
-	       TP_ARGS(adap, msg, ret),
+			int num),
+	       TP_ARGS(adap, msg, num),
 	       TP_STRUCT__entry(
-		       __field(	int,	adapter_nr		)
+		       __field(int,	adapter_nr		)
+		       __field(__u16,	msg_nr			)
 		       __field(__u16,	addr			)
 		       __field(__u16,	flags			)
 		       __field(__u16,	len			)
-		       __field(__s16,	ret			)
 		       __dynamic_array(__u8, buf, msg->len)	),
 	       TP_fast_assign(
 		       __entry->adapter_nr = adap->nr;
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
 		       __entry->addr = msg->addr;
 		       __entry->flags = msg->flags;
 		       __entry->len = msg->len;
-		       __entry->ret = ret;
 		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
 			      ),
-	       TP_printk("i2c-%d f=%02x a=%02x l=%u ret=%d [%*phN]",
+	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u [%*phN]",
 			 __entry->adapter_nr,
+			 __entry->msg_nr,
 			 __entry->flags,
 			 __entry->addr,
 			 __entry->len,
-			 __entry->ret,
 			 __entry->len, __get_dynamic_array(buf)
 			 ),
 	       i2c_transfer_trace_reg,
 	       i2c_transfer_trace_unreg);
 
-TRACE_EVENT(smbus_transfer,
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
+/*
+ * i2c_smbus_xfer() write request
+ */
+TRACE_EVENT(smbus_write,
+	    TP_PROTO(const struct i2c_adapter *adap,
+		     u16 addr, unsigned short flags,
+		     u8 command, int protocol,
+		     const union i2c_smbus_data *data),
+	    TP_ARGS(adap, addr, flags, command, protocol, data),
+	    TP_STRUCT__entry(
+		    __field(int,	adapter_nr		)
+		    __field(__u16,	addr			)
+		    __field(__u16,	flags			)
+		    __field(__u8,	command			)
+		    __field(__u32,	protocol		)
+		    __array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	    TP_fast_assign(
+		    __entry->adapter_nr = adap->nr;
+		    __entry->addr = addr;
+		    __entry->flags = flags;
+		    __entry->command = command;
+		    __entry->protocol = protocol;
+		    memcpy(__entry->buf, data->block, I2C_SMBUS_BLOCK_MAX + 2);
+			   ),
+	    TP_printk("i2c-%d a=%02x f=%02x c=%x %s [%*phN]",
+		      __entry->adapter_nr,
+		      __entry->addr,
+		      __entry->flags,
+		      __entry->command,
+		      __print_symbolic(__entry->protocol,
+				       { I2C_SMBUS_QUICK,		"QUICK"	},
+				       { I2C_SMBUS_BYTE,		"BYTE"	},
+				       { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				       { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				       { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				       { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				       { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				       { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				       { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" }),
+		      I2C_SMBUS_BLOCK_MAX + 2, __entry->buf
+		      ));
+
+/*
+ * i2c_smbus_xfer() read request
+ */
+TRACE_EVENT(smbus_read,
+	    TP_PROTO(const struct i2c_adapter *adap,
+		     u16 addr, unsigned short flags,
+		     u8 command, int protocol),
+	    TP_ARGS(adap, addr, flags, command, protocol),
+	    TP_STRUCT__entry(
+		    __field(int,	adapter_nr		)
+		    __field(__u16,	addr			)
+		    __field(__u16,	flags			)
+		    __field(__u8,	command			)
+		    __field(__u32,	protocol		)
+		    __array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	    TP_fast_assign(
+		    __entry->adapter_nr = adap->nr;
+		    __entry->addr = addr;
+		    __entry->flags = flags;
+		    __entry->command = command;
+		    __entry->protocol = protocol;
+			   ),
+	    TP_printk("i2c-%d a=%02x f=%02x c=%x %s",
+		      __entry->adapter_nr,
+		      __entry->addr,
+		      __entry->flags,
+		      __entry->command,
+		      __print_symbolic(__entry->protocol,
+				       { I2C_SMBUS_QUICK,		"QUICK"	},
+				       { I2C_SMBUS_BYTE,		"BYTE"	},
+				       { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				       { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				       { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				       { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				       { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				       { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				       { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" })
+		      ));
+
+/*
+ * i2c_smbus_xfer() read reply
+ */
+TRACE_EVENT(smbus_reply,
+	    TP_PROTO(const struct i2c_adapter *adap,
+		     u16 addr, unsigned short flags,
+		     u8 command, int protocol,
+		     const union i2c_smbus_data *data),
+	    TP_ARGS(adap, addr, flags, command, protocol, data),
+	    TP_STRUCT__entry(
+		    __field(int,	adapter_nr		)
+		    __field(__u16,	addr			)
+		    __field(__u16,	flags			)
+		    __field(__u8,	command			)
+		    __field(__u32,	protocol		)
+		    __array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	    TP_fast_assign(
+		    __entry->adapter_nr = adap->nr;
+		    __entry->addr = addr;
+		    __entry->flags = flags;
+		    __entry->command = command;
+		    __entry->protocol = protocol;
+		    memcpy(__entry->buf, data->block, I2C_SMBUS_BLOCK_MAX + 2);
+			   ),
+	    TP_printk("i2c-%d a=%02x f=%02x c=%x %s [%*phN]",
+		      __entry->adapter_nr,
+		      __entry->addr,
+		      __entry->flags,
+		      __entry->command,
+		      __print_symbolic(__entry->protocol,
+				       { I2C_SMBUS_QUICK,		"QUICK"	},
+				       { I2C_SMBUS_BYTE,		"BYTE"	},
+				       { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				       { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				       { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				       { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				       { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				       { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				       { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" }),
+		      I2C_SMBUS_BLOCK_MAX + 2, __entry->buf
+		      ));
+
+/*
+ * i2c_smbus_xfer() result
+ */
+TRACE_EVENT(smbus_result,
 	    TP_PROTO(const struct i2c_adapter *adap,
 		     u16 addr, unsigned short flags,
 		     char read_write, u8 command, int protocol,
-		     const union i2c_smbus_data *data, int res),
-	    TP_ARGS(adap, addr, flags, read_write, command, protocol, data, res),
+		     int res),
+	    TP_ARGS(adap, addr, flags, read_write, command, protocol, res),
 	    TP_STRUCT__entry(
 		    __field(int,	adapter_nr		)
 		    __field(__u16,	addr			)
@@ -67,7 +284,7 @@ TRACE_EVENT(smbus_transfer,
 		    __field(__u8,	command			)
 		    __field(__s16,	res			)
 		    __field(__u32,	protocol		)
-		    __array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+			     ),
 	    TP_fast_assign(
 		    __entry->adapter_nr = adap->nr;
 		    __entry->addr = addr;
@@ -76,17 +293,24 @@ TRACE_EVENT(smbus_transfer,
 		    __entry->command = command;
 		    __entry->protocol = protocol;
 		    __entry->res = res;
-		    memcpy(__entry->buf, data->block, I2C_SMBUS_BLOCK_MAX + 2);
 			   ),
-	    TP_printk("i2c-%d f=%02x a=%02x r=%x c=%x p=%x res=%d [%*phN]",
+	    TP_printk("i2c-%d a=%02x f=%02x c=%x %s %s res=%d",
 		      __entry->adapter_nr,
-		      __entry->flags,
 		      __entry->addr,
-		      __entry->read_write,
+		      __entry->flags,
 		      __entry->command,
-		      __entry->protocol,
-		      __entry->res,
-		      I2C_SMBUS_BLOCK_MAX + 2, __entry->buf
+		      __print_symbolic(__entry->protocol,
+				       { I2C_SMBUS_QUICK,		"QUICK"	},
+				       { I2C_SMBUS_BYTE,		"BYTE"	},
+				       { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				       { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				       { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				       { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				       { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				       { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				       { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" }),
+		      __entry->read_write == I2C_SMBUS_WRITE ? "wr" : "rd",
+		      __entry->res
 		      ));
 
 #endif /* _TRACE_I2C_H */
