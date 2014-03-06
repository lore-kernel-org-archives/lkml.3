Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaCFNg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:36:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaCFNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:36:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS [ver #2]
From: David Howells <dhowells@redhat.com>
To: wolfram@the-dreams.de
Cc: khali@linux-fr.org, dhowells@redhat.com, linux-i2c@vger.kernel.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 13:36:06 +0000
Message-ID: <20140306133606.29345.97103.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140306133559.29345.61422.stgit@warthog.procyon.org.uk>
References: <20140306133559.29345.61422.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMBUS tracepoints can be enabled thusly:

	echo 1 >/sys/kernel/debug/tracing/events/i2c/enable

and will dump messages that can be viewed in /sys/kernel/debug/tracing/trace
that look like:

         ... smbus_read: i2c-0 a=051 f=0000 c=fa BYTE_DATA
         ... smbus_reply: i2c-0 a=051 f=0000 c=fa BYTE_DATA l=1 [39]
         ... smbus_result: i2c-0 a=051 f=0000 c=fa BYTE_DATA rd res=0

formatted as:

	i2c-<adapter-nr>
	a=<addr>
	f=<flags>
	c=<command>
	<protocol-name>
	<rd|wr>
	res=<result>
	l=<data-len>
	[<data-block>]


The adapters to be traced can be selected by something like:

	echo adapter_nr==1 >/sys/kernel/debug/tracing/events/i2c/filter

Note that this shares the same filter and enablement as i2c.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---

 drivers/i2c/i2c-core.c     |   23 ++++-
 include/trace/events/i2c.h |  224 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index c8b97490461d..619910632d26 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2552,6 +2552,14 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	int try;
 	s32 res;
 
+	/* If enabled, the following two tracepoints are conditional on
+	 * read_write and protocol.
+	 */
+	trace_smbus_write(adapter, addr, flags, read_write,
+			  command, protocol, data);
+	trace_smbus_read(adapter, addr, flags, read_write,
+			 command, protocol);
+
 	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_CLIENT_SCCB;
 
 	if (adapter->algo->smbus_xfer) {
@@ -2572,15 +2580,24 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
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
+	/* If enabled, the reply tracepoint is conditional on read_write. */
+	trace_smbus_reply(adapter, addr, flags, read_write,
+			  command, protocol, data);
+	trace_smbus_result(adapter, addr, flags, read_write,
+			   command, protocol, res);
+
+	return res;
 }
 EXPORT_SYMBOL(i2c_smbus_xfer);
 
diff --git a/include/trace/events/i2c.h b/include/trace/events/i2c.h
index 4800207269a2..fe17187df65d 100644
--- a/include/trace/events/i2c.h
+++ b/include/trace/events/i2c.h
@@ -1,4 +1,4 @@
-/* I2C message transfer tracepoints
+/* I2C and SMBUS message transfer tracepoints
  *
  * Copyright (C) 2013 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -144,6 +144,228 @@ TRACE_EVENT_FN(i2c_result,
 	       i2c_transfer_trace_reg,
 	       i2c_transfer_trace_unreg);
 
+/*
+ * i2c_smbus_xfer() write data or procedure call request
+ */
+TRACE_EVENT_CONDITION(smbus_write,
+	TP_PROTO(const struct i2c_adapter *adap,
+		 u16 addr, unsigned short flags,
+		 char read_write, u8 command, int protocol,
+		 const union i2c_smbus_data *data),
+	TP_ARGS(adap, addr, flags, read_write, command, protocol, data),
+	TP_CONDITION(read_write == I2C_SMBUS_WRITE ||
+		     protocol == I2C_SMBUS_PROC_CALL ||
+		     protocol == I2C_SMBUS_BLOCK_PROC_CALL),
+	TP_STRUCT__entry(
+		__field(int,	adapter_nr		)
+		__field(__u16,	addr			)
+		__field(__u16,	flags			)
+		__field(__u8,	command			)
+		__field(__u8,	len			)
+		__field(__u32,	protocol		)
+		__array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	TP_fast_assign(
+		__entry->adapter_nr = adap->nr;
+		__entry->addr = addr;
+		__entry->flags = flags;
+		__entry->command = command;
+		__entry->protocol = protocol;
+
+		switch (protocol) {
+		case I2C_SMBUS_BYTE_DATA:
+			__entry->len = 1;
+			goto copy;
+		case I2C_SMBUS_WORD_DATA:
+		case I2C_SMBUS_PROC_CALL:
+			__entry->len = 2;
+			goto copy;
+		case I2C_SMBUS_BLOCK_DATA:
+		case I2C_SMBUS_BLOCK_PROC_CALL:
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			__entry->len = data->block[0] + 1;
+		copy:
+			memcpy(__entry->buf, data->block, __entry->len);
+			break;
+		case I2C_SMBUS_QUICK:
+		case I2C_SMBUS_BYTE:
+		case I2C_SMBUS_I2C_BLOCK_BROKEN:
+		default:
+			__entry->len = 0;
+		}
+		       ),
+	TP_printk("i2c-%d a=%03x f=%04x c=%x %s l=%u [%*phD]",
+		  __entry->adapter_nr,
+		  __entry->addr,
+		  __entry->flags,
+		  __entry->command,
+		  __print_symbolic(__entry->protocol,
+				   { I2C_SMBUS_QUICK,		"QUICK"	},
+				   { I2C_SMBUS_BYTE,		"BYTE"	},
+				   { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				   { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				   { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				   { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				   { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				   { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				   { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" }),
+		  __entry->len,
+		  __entry->len, __entry->buf
+		  ));
+
+/*
+ * i2c_smbus_xfer() read data request
+ */
+TRACE_EVENT_CONDITION(smbus_read,
+	TP_PROTO(const struct i2c_adapter *adap,
+		 u16 addr, unsigned short flags,
+		 char read_write, u8 command, int protocol),
+	TP_ARGS(adap, addr, flags, read_write, command, protocol),
+	TP_CONDITION(!(read_write == I2C_SMBUS_WRITE ||
+		       protocol == I2C_SMBUS_PROC_CALL ||
+		       protocol == I2C_SMBUS_BLOCK_PROC_CALL)),
+	TP_STRUCT__entry(
+		__field(int,	adapter_nr		)
+		__field(__u16,	flags			)
+		__field(__u16,	addr			)
+		__field(__u8,	command			)
+		__field(__u32,	protocol		)
+		__array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	TP_fast_assign(
+		__entry->adapter_nr = adap->nr;
+		__entry->addr = addr;
+		__entry->flags = flags;
+		__entry->command = command;
+		__entry->protocol = protocol;
+		       ),
+	TP_printk("i2c-%d a=%03x f=%04x c=%x %s",
+		  __entry->adapter_nr,
+		  __entry->addr,
+		  __entry->flags,
+		  __entry->command,
+		  __print_symbolic(__entry->protocol,
+				   { I2C_SMBUS_QUICK,		"QUICK"	},
+				   { I2C_SMBUS_BYTE,		"BYTE"	},
+				   { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				   { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				   { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				   { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				   { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				   { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				   { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" })
+		  ));
+
+/*
+ * i2c_smbus_xfer() read data or procedure call reply
+ */
+TRACE_EVENT_CONDITION(smbus_reply,
+	TP_PROTO(const struct i2c_adapter *adap,
+		 u16 addr, unsigned short flags,
+		 char read_write, u8 command, int protocol,
+		 const union i2c_smbus_data *data),
+	TP_ARGS(adap, addr, flags, read_write, command, protocol, data),
+	TP_CONDITION(read_write == I2C_SMBUS_READ),
+	TP_STRUCT__entry(
+		__field(int,	adapter_nr		)
+		__field(__u16,	addr			)
+		__field(__u16,	flags			)
+		__field(__u8,	command			)
+		__field(__u8,	len			)
+		__field(__u32,	protocol		)
+		__array(__u8, buf, I2C_SMBUS_BLOCK_MAX + 2)	),
+	TP_fast_assign(
+		__entry->adapter_nr = adap->nr;
+		__entry->addr = addr;
+		__entry->flags = flags;
+		__entry->command = command;
+		__entry->protocol = protocol;
+
+		switch (protocol) {
+		case I2C_SMBUS_BYTE:
+		case I2C_SMBUS_BYTE_DATA:
+			__entry->len = 1;
+			goto copy;
+		case I2C_SMBUS_WORD_DATA:
+		case I2C_SMBUS_PROC_CALL:
+			__entry->len = 2;
+			goto copy;
+		case I2C_SMBUS_BLOCK_DATA:
+		case I2C_SMBUS_BLOCK_PROC_CALL:
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			__entry->len = data->block[0] + 1;
+		copy:
+			memcpy(__entry->buf, data->block, __entry->len);
+			break;
+		case I2C_SMBUS_QUICK:
+		case I2C_SMBUS_I2C_BLOCK_BROKEN:
+		default:
+			__entry->len = 0;
+		}
+		       ),
+	TP_printk("i2c-%d a=%03x f=%04x c=%x %s l=%u [%*phD]",
+		  __entry->adapter_nr,
+		  __entry->addr,
+		  __entry->flags,
+		  __entry->command,
+		  __print_symbolic(__entry->protocol,
+				   { I2C_SMBUS_QUICK,		"QUICK"	},
+				   { I2C_SMBUS_BYTE,		"BYTE"	},
+				   { I2C_SMBUS_BYTE_DATA,		"BYTE_DATA" },
+				   { I2C_SMBUS_WORD_DATA,		"WORD_DATA" },
+				   { I2C_SMBUS_PROC_CALL,		"PROC_CALL" },
+				   { I2C_SMBUS_BLOCK_DATA,		"BLOCK_DATA" },
+				   { I2C_SMBUS_I2C_BLOCK_BROKEN,	"I2C_BLOCK_BROKEN" },
+				   { I2C_SMBUS_BLOCK_PROC_CALL,	"BLOCK_PROC_CALL" },
+				   { I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA" }),
+		  __entry->len,
+		  __entry->len, __entry->buf
+		  ));
+
+/*
+ * i2c_smbus_xfer() result
+ */
+TRACE_EVENT(smbus_result,
+	    TP_PROTO(const struct i2c_adapter *adap,
+		     u16 addr, unsigned short flags,
+		     char read_write, u8 command, int protocol,
+		     int res),
+	    TP_ARGS(adap, addr, flags, read_write, command, protocol, res),
+	    TP_STRUCT__entry(
+		    __field(int,	adapter_nr		)
+		    __field(__u16,	addr			)
+		    __field(__u16,	flags			)
+		    __field(__u8,	read_write		)
+		    __field(__u8,	command			)
+		    __field(__s16,	res			)
+		    __field(__u32,	protocol		)
+			     ),
+	    TP_fast_assign(
+		    __entry->adapter_nr = adap->nr;
+		    __entry->addr = addr;
+		    __entry->flags = flags;
+		    __entry->read_write = read_write;
+		    __entry->command = command;
+		    __entry->protocol = protocol;
+		    __entry->res = res;
+			   ),
+	    TP_printk("i2c-%d a=%03x f=%04x c=%x %s %s res=%d",
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
+		      __entry->read_write == I2C_SMBUS_WRITE ? "wr" : "rd",
+		      __entry->res
+		      ));
+
 #endif /* _TRACE_I2C_H */
 
 /* This part must be outside protection */

