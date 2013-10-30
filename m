Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3J3Kfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:35:39 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34193 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3J3Kfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:35:37 -0400
Message-ID: <1383129316.2414.4.camel@localhost.localdomain>
Subject: [PATCH] ipmi: add ipmi tracepoints
From: Hushan Jia <hushan.jia@gmail.com>
To: Corey Minyard <minyard@acm.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        oliver.yang@emc.com, hushan.jia@emc.com
Date: Wed, 30 Oct 2013 18:35:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hushan Jia <hushan.jia@emc.com>

Sometimes it's essential to tracing ipmi communications when doing platform related work,
including the commands and messages between user spaces and the system interface.
This patch add 5 tracepoints to ipmi driver, and remove old debugging output code:

ipmi_cmd_request
ipmi_smi_msg_send
ipmi_smi_msg_invalidcmd
ipmi_smi_msg_recv
ipmi_smi_msg_resend

Signed-off-by: Hushan Jia <hushan.jia@emc.com>
Signed-off-by: Oliver Yang <oliver.yang@emc.com>
Cc: Corey Minyard <minyard@acm.org>

---
 drivers/char/ipmi/ipmi_msghandler.c |   44 +++++-------------
 include/trace/events/ipmi.h         |   86 +++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 33 deletions(-)
 create mode 100644 include/trace/events/ipmi.h

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index ec4e10f..d89dd78 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -431,6 +431,9 @@ struct ipmi_smi {
 };
 #define to_si_intf_from_dev(device) container_of(device, struct ipmi_smi, dev)
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ipmi.h>
+
 /**
  * The driver model view of the IPMI messaging driver.
  */
@@ -1458,6 +1461,7 @@ static int i_ipmi_request(ipmi_user_t          user,
 	unsigned long            flags;
 	struct ipmi_smi_handlers *handlers;
 
+	trace_ipmi_cmd_request(intf, msg);
 
 	if (supplied_recv)
 		recv_msg = supplied_recv;
@@ -1806,14 +1810,7 @@ static int i_ipmi_request(ipmi_user_t          user,
 		goto out_err;
 	}
 
-#ifdef DEBUG_MSGING
-	{
-		int m;
-		for (m = 0; m < smi_msg->data_size; m++)
-			printk(" %2.2x", smi_msg->data[m]);
-		printk("\n");
-	}
-#endif
+	trace_ipmi_smi_msg_send(smi_msg);
 
 	handlers->sender(intf->send_info, smi_msg, priority);
 	rcu_read_unlock();
@@ -3132,15 +3129,8 @@ static int handle_ipmb_get_msg_cmd(ipmi_smi_t          intf,
 		msg->data[10] = ipmb_checksum(&(msg->data[6]), 4);
 		msg->data_size = 11;
 
-#ifdef DEBUG_MSGING
-	{
-		int m;
-		printk("Invalid command:");
-		for (m = 0; m < msg->data_size; m++)
-			printk(" %2.2x", msg->data[m]);
-		printk("\n");
-	}
-#endif
+		trace_ipmi_smi_msg_invalidcmd(msg);
+
 		rcu_read_lock();
 		handlers = intf->handlers;
 		if (handlers) {
@@ -3647,13 +3637,8 @@ static int handle_one_recv_msg(ipmi_smi_t          intf,
 	int requeue;
 	int chan;
 
-#ifdef DEBUG_MSGING
-	int m;
-	printk("Recv:");
-	for (m = 0; m < msg->rsp_size; m++)
-		printk(" %2.2x", msg->rsp[m]);
-	printk("\n");
-#endif
+	trace_ipmi_smi_msg_recv(msg);
+
 	if (msg->rsp_size < 2) {
 		/* Message is too small to be correct. */
 		printk(KERN_WARNING PFX "BMC returned to small a message"
@@ -3951,15 +3936,8 @@ smi_from_recv_msg(ipmi_smi_t intf, struct ipmi_recv_msg *recv_msg,
 	smi_msg->data_size = recv_msg->msg.data_len;
 	smi_msg->msgid = STORE_SEQ_IN_MSGID(seq, seqid);
 
-#ifdef DEBUG_MSGING
-	{
-		int m;
-		printk("Resend: ");
-		for (m = 0; m < smi_msg->data_size; m++)
-			printk(" %2.2x", smi_msg->data[m]);
-		printk("\n");
-	}
-#endif
+	trace_ipmi_smi_msg_resend(smi_msg);
+
 	return smi_msg;
 }
 
diff --git a/include/trace/events/ipmi.h b/include/trace/events/ipmi.h
new file mode 100644
index 0000000..07599b6
--- /dev/null
+++ b/include/trace/events/ipmi.h
@@ -0,0 +1,86 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ipmi
+
+#if !defined(_TRACE_IPMI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IPMI_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ipmi_cmd_request,
+
+	TP_PROTO(ipmi_smi_t intf,
+		struct kernel_ipmi_msg *msg),
+
+	TP_ARGS(intf, msg),
+
+	TP_STRUCT__entry(
+		__string(   devname, intf->my_dev_name )
+		__field(    unsigned char, netfn )
+		__field(    unsigned char, cmd  )
+		__field(    unsigned short, data_len    )
+		__dynamic_array(    char, data, msg->data_len   )
+	),
+
+	TP_fast_assign(
+		__assign_str(devname, intf->my_dev_name);
+		__entry->netfn          = msg->netfn;
+		__entry->cmd            = msg->cmd;
+		__entry->data_len       = msg->data_len;
+		memcpy(__get_dynamic_array(data), msg->data, msg->data_len);
+	),
+
+	TP_printk("dev=%s netfn=%02x cmd=%02x data[%d]=%s",
+		__get_str(devname),
+		__entry->netfn,
+		__entry->cmd,
+		__entry->data_len,
+		__print_hex(__get_dynamic_array(data), __entry->data_len)
+	 )
+);
+
+DECLARE_EVENT_CLASS(ipmi_smi_msg_template,
+
+	TP_PROTO(struct ipmi_smi_msg *msg),
+
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__field(    int, data_size   )
+		__dynamic_array(    unsigned char, data, msg->data_size  )
+	),
+
+	TP_fast_assign(
+		__entry->data_size    = msg->data_size;
+		memcpy(__get_dynamic_array(data), msg->data, msg->data_size);
+	),
+
+	TP_printk("data[%d]=%s", __entry->data_size,
+		__print_hex(__get_dynamic_array(data), __entry->data_size)
+	)
+);
+
+DEFINE_EVENT(ipmi_smi_msg_template, ipmi_smi_msg_send,
+	TP_PROTO(struct ipmi_smi_msg *msg),
+	TP_ARGS(msg)
+);
+
+DEFINE_EVENT(ipmi_smi_msg_template, ipmi_smi_msg_invalidcmd,
+	TP_PROTO(struct ipmi_smi_msg *msg),
+	TP_ARGS(msg)
+);
+
+DEFINE_EVENT(ipmi_smi_msg_template, ipmi_smi_msg_recv,
+	TP_PROTO(struct ipmi_smi_msg *msg),
+	TP_ARGS(msg)
+);
+
+DEFINE_EVENT(ipmi_smi_msg_template, ipmi_smi_msg_resend,
+	TP_PROTO(struct ipmi_smi_msg *msg),
+	TP_ARGS(msg)
+);
+
+#endif /* _TRACE_IPMI_H */
+
+/* This part must be out of the protection */
+#include <trace/define_trace.h>
+
-- 
1.7.7



