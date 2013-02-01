Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3BANLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:11:15 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9854 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757506Ab3BANLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:11 -0500
From: =?utf-8?B?Ik3DpW5zc29uLCBCasO2cm4i?= <Bjorn.Mansson@sonymobile.com>
To: "'Chris Ball'" <cjb@laptop.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Qelthin, Stefan" <Stefan.Qelthin@sonymobile.com>,
        "Pettersson, Roger" <Roger.Pettersson@sonymobile.com>
Date: Fri, 1 Feb 2013 14:01:06 +0100
Subject: [PATCH] mmc: Adding ftrace event logging to the mmc layer
Thread-Topic: [PATCH] mmc: Adding ftrace event logging to the mmc layer
Thread-Index: Ac3/xXtZRKZhZWF1T1WOJA2aUcACowAtTNBw
Message-ID: <9A742367D258D34A9753780E2AE6B8BD75DB1FCFE9@SELDMBX04.corpusers.net>
References: <9A742367D258D34A9753780E2AE6B8BD75DB1FCFDC@SELDMBX04.corpusers.net>
 <87lib9qtby.fsf@octavius.laptop.org>
In-Reply-To: <87lib9qtby.fsf@octavius.laptop.org>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r11DBOor027024

From: Bjorn Mansson <bjorn.mansson@sonymobile.com>

Adding ftrace to the mmc layer facilitates debugging,
making it easier to debug commend sequences without
rebuilding the kernel.
It is also possible to parse the ftrace output into
VCD format and visualize it in GTKWave.

Patch is for the 3.7.5 Kernel.


Signed-off-by: Bjorn Mansson <bjorn.mansson@sonymobile.com>
Acked-by: Chris Ball <cjb@laptop.org>
"---"

diff -uprN -X linux-3.7.5-vanilla/Documentation/dontdiff linux-3.7.5-vanilla/drivers/mmc/core/core.c linux-3.7.5-patched/drivers/mmc/core/core.c
--- linux-3.7.5-vanilla/drivers/mmc/core/core.c	2013-01-28 05:50:55.000000000 +0100
+++ linux-3.7.5-patched/drivers/mmc/core/core.c	2013-02-01 12:03:26.691987495 +0100
@@ -42,6 +42,9 @@
 #include "sd_ops.h"
 #include "sdio_ops.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mmc.h>
+
 /*
  * Background operations can take a long time, depending on the housekeeping
  * operations the card has to perform.
@@ -165,6 +168,10 @@ void mmc_request_done(struct mmc_host *h
 			cmd->resp[0], cmd->resp[1],
 			cmd->resp[2], cmd->resp[3]);
 
+		trace_mmc_req_done( mmc_hostname(host), cmd->opcode, err,
+			cmd->resp[0], cmd->resp[1],
+			cmd->resp[2], cmd->resp[3]);
+
 		if (mrq->data) {
 			pr_debug("%s:     %d bytes transferred: %d\n",
 				mmc_hostname(host),
@@ -202,6 +209,9 @@ mmc_start_request(struct mmc_host *host,
 			 mrq->sbc->arg, mrq->sbc->flags);
 	}
 
+	trace_mmc_start_req( mmc_hostname(host), mrq->cmd->opcode,
+				mrq->cmd->arg, mrq->cmd->flags);
+
 	pr_debug("%s: starting CMD%u arg %08x flags %08x\n",
 		 mmc_hostname(host), mrq->cmd->opcode,
 		 mrq->cmd->arg, mrq->cmd->flags);
diff -uprN -X linux-3.7.5-vanilla/Documentation/dontdiff linux-3.7.5-vanilla/include/trace/events/mmc.h linux-3.7.5-patched/include/trace/events/mmc.h
--- linux-3.7.5-vanilla/include/trace/events/mmc.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.5-patched/include/trace/events/mmc.h	2013-01-31 09:38:32.002851000 +0100
@@ -0,0 +1,86 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mmc
+
+#if !defined(_TRACE_MMC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MMC_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(start_req,
+	TP_PROTO(const char * host, unsigned int cmd,
+	         unsigned int arg, unsigned int flags),
+	TP_ARGS(host, cmd, arg, flags),
+
+	TP_STRUCT__entry(
+	    __string(host, host)
+	    __field(unsigned int, cmd   )
+	    __field(unsigned int, arg )
+	    __field(unsigned int, flags )
+	   ),
+
+	TP_fast_assign(
+	    __assign_str(host, host);
+	    __entry->cmd = cmd;
+	    __entry->arg = arg;
+	    __entry->flags = flags;
+	),
+
+	TP_printk("host=%s CMD%u arg=%08x flags=%08x",
+	       __get_str(host), __entry->cmd,
+	      __entry->arg, __entry->flags )
+);
+
+DEFINE_EVENT(start_req, mmc_start_req,
+	TP_PROTO(const char *host, unsigned int cmd,
+	     unsigned int arg, unsigned int flags),
+	TP_ARGS(host, cmd, arg, flags)
+);
+
+
+DECLARE_EVENT_CLASS(req_done,
+	TP_PROTO(const char *host, unsigned int cmd,
+		int err, unsigned int resp1, 
+		unsigned int resp2, unsigned int resp3,
+		unsigned int resp4),
+	TP_ARGS(host, cmd, err, resp1, resp2, resp3, resp4),
+
+	TP_STRUCT__entry(
+	    __string(host, host)
+	    __field(unsigned int, cmd   )
+	    __field(         int, err )
+	    __field(unsigned int, resp1 )
+	    __field(unsigned int, resp2 )
+	    __field(unsigned int, resp3 )
+	    __field(unsigned int, resp4 )
+	   ),
+
+	TP_fast_assign(
+	    __assign_str(host, host);
+	    __entry->cmd = cmd;
+	    __entry->err = err;
+	    __entry->resp1 = resp1;
+	    __entry->resp2 = resp2;
+	    __entry->resp3 = resp3;
+	    __entry->resp4 = resp4;
+	),
+
+	TP_printk("host=%s CMD%u err=%08x resp1=%08x resp2=%08x resp3=%08x resp4=%08x",
+		__get_str(host), __entry->cmd,
+		__entry->err, __entry->resp1, 
+		__entry->resp2, __entry->resp3,
+		__entry->resp4 )
+);
+
+DEFINE_EVENT(req_done, mmc_req_done,
+	TP_PROTO(const char *host, unsigned int cmd,
+		int err, unsigned int resp1, 
+		unsigned int resp2, unsigned int resp3,
+		unsigned int resp4),
+	TP_ARGS(host, cmd, err, resp1, resp2, resp3, resp4)
+);
+
+
+#endif /* _TRACE_MMC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
