Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3H1PRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:17:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3H1PRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:17:48 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jxQzypR4wcoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qWrlR9Lw5PkA:10 a=fBmEnqC8qtIH1b_4y8wA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 11:17:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828111746.35369b84@gandalf.local.home>
In-Reply-To: <20130828095833.103ccdf0@gandalf.local.home>
References: <20130828034627.GA30596@redhat.com>
	<20130828095408.37c3dd83@gandalf.local.home>
	<20130828095833.103ccdf0@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 09:58:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> I'll take that back. The ftrace_shutdown() is called on success, thus
> this is a normal path. I have to find out what perf is doing. Do you
> have any clue to what calls are being made to perf?

This may be the error path that is taken that causes things to get off
whack.

Dave, can you add this patch to your kernels you test, and that way,
the next time you hit this error, I want to see if this warning was
triggered too.

If we did not unregister the ftrace ops but free the filters, it will
cause the accounting to get out of whack.

Thanks!

-- Steve

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 80c36bc..05167bb 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -306,6 +306,7 @@ static int perf_ftrace_function_unregister(struct perf_event *event)
 {
 	struct ftrace_ops *ops = &event->ftrace_ops;
 	int ret = unregister_ftrace_function(ops);
+	WARN_ON(ret);
 	ftrace_free_filter(ops);
 	return ret;
 }
