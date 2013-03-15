Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3CODiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:38:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CODix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:38:53 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Oso-87ONFSEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=fSY8Htx590UA:10 a=zyKqqGipxnzneC5GG7gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363318731.25967.42.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] [GIT PULL][3.9] tracing: Fixes with flags and
 latency tracers
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 14 Mar 2013 23:38:51 -0400
In-Reply-To: <20130314213303.302538352@goodmis.org>
References: <20130314213303.302538352@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 17:33 -0400, Steven Rostedt wrote:

> Anyway, here's hopefully my final series of changes for 3.9.
> (Famous last words)

And there's a bug in this patch set. Thanks to Fangguang's auto tests,
it showed a bug in my new work, which points out a bug in this patch
set. The following change is needed to patch 2:

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eaaccd8..02debab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2897,7 +2897,9 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
 		ring_buffer_change_overwrite(max_tr.buffer, enabled);
+#endif
 	}
 
 	if (mask == TRACE_ITER_PRINTK)


But this bug is worse than the one in my new code. As the new code wont
compile here, this code will, but "max_tr.buffer" will be NULL if
CONFIG_MAX_TRACER_MAX_TRACE is not defined and will cause a NULL pointer
dereference.

I'll update the patch series, test it and push it out again.

Thanks!

-- Steve


