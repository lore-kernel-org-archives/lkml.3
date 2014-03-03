Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaCCWph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:45:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:26608 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753236AbaCCWpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:45:36 -0500
Date: Mon, 3 Mar 2014 17:45:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about -rc and stable patches
Message-ID: <20140303174532.7cb8f31e@gandalf.local.home>
In-Reply-To: <20140303224104.GA26031@kroah.com>
References: <20140303172806.4486f65a@gandalf.local.home>
	<20140303224104.GA26031@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 14:41:04 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Mon, Mar 03, 2014 at 05:28:06PM -0500, Steven Rostedt wrote:
> > Hi Linus and Greg,
> > 
> > Recently I have been sent patches that fix a bug in the enabling of
> > ftrace function tracer, where if something goes wrong with the
> > enabling (or disabling), it can cause a crash of the computer.
> > 
> > Now, my question is, the bug requires something to go wrong at a point
> > where I've never seen it go wrong before. But if you inject a problem
> > (code that makes it fail on the 1000th iteration), sure enough, the
> > recovery is not correct and the machine crashes.
> 
> What exactly do you mean by "inject a problem"?  What kind of
> permissions does that require to do?

Modify kernel source ;-)  Basically, I added this patch to the kernel,
compiled it, enabled function tracing, and it crashed:

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 8cabf63..9f354e5 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -586,6 +586,9 @@ void ftrace_replace_code(int enable)
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
 
+		if (count == 1000)
+			ret = -EPERM;
+		else
 		ret = add_breakpoints(rec, enable);
 		if (ret)
 			goto remove_breakpoints;


Not something that can be done from normal operations.

-- Steve
