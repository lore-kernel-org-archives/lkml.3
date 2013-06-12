Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3FLRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:16:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3FLRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:16:27 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_8TXWqlxb2sA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=qPXK9W7imzkA:10 a=OHTq3hrHAjMAy59IWfIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371057385.9844.261.camel@gandalf.local.home>
Subject: Re: event filtering with trace-cmd
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 12 Jun 2013 13:16:25 -0400
In-Reply-To: <1371054120.9844.259.camel@gandalf.local.home>
References: <51B849BA.6000802@broadcom.com>
	 <1371054120.9844.259.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 12:22 -0400, Steven Rostedt wrote:

> > # sudo trace-cmd record -e brcmfmac:brcmf_dbg -f 'level & 0x40000'
> > disable all
> > enable brcmfmac:brcmf_dbg
> > path = /sys/kernel/debug/tracing/events/brcmfmac/brcmf_dbg/enable
> > (level & 0x40000)
> > ^
> > parse_error: Invalid operator
> > 
> 
> The record -f command passes the filter into the kernel
> file /sys/kerne/debug/tracing/events/brcmfmac/brcmf_dbg/filter, and the
> error is actually coming from the kernel itself. Looking at the code, we
> do not currently accept binary operations. Although, it shouldn't be too
> hard to add. I may go and implement it for 3.11.
> 

Here, can you apply this patch and see if it does what you expect?

Thanks,

-- Steve

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e1b653f..111eddf 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -35,6 +35,7 @@
 
 enum filter_op_ids
 {
+	OP_BAND,
 	OP_OR,
 	OP_AND,
 	OP_GLOB,
@@ -64,6 +65,7 @@ static struct filter_op filter_ops[] = {
 	{ OP_LE,	"<=",		5 },
 	{ OP_GT,	">",		5 },
 	{ OP_GE,	">=",		5 },
+	{ OP_BAND,	"&",		6 },
 	{ OP_NONE,	"OP_NONE",	0 },
 	{ OP_OPEN_PAREN, "(",		0 },
 };
@@ -156,6 +158,9 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 	case OP_GE:							\
 		match = (*addr >= val);					\
 		break;							\
+	case OP_BAND:							\
+		match = (*addr & val);					\
+		break;							\
 	default:							\
 		break;							\
 	}								\


