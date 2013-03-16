Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3CPSAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3CPSAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:00:42 -0400
Date: Sat, 16 Mar 2013 18:58:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130316175845.GA6194@redhat.com>
References: <20130316011508.GA11010@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316011508.GA11010@fifo99.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Sorry, I can't understand your email...

On 03/15, Daniel Walker wrote:
>
> I was writing an application to ptrace a process which is dumping core
> from inside the pipe application for core_pattern.

This was never possible. And never will, I think.

> So for example you make core pattern equal to something like
> "|/bin/corepipe_app" then the kernel runs that app prior to actually
> killing the process that failed.

No, the dumper "kills" itself (but see below) and the starts
/bin/corepipe_app.

> Before the pipe application runs it puts SIGKILL on the pending signal
> list for the failed application.

if "it" means the dumper thread then "almost true". It kills other threads
but not itself.

(Just in case, this was recently changed. After
 coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch in -mm
 tree the dumper doesn't run in SIGNAL_GROUP_EXIT, but probably this
 doesn't matter)

> However the application can't run.

Which application? Both the dumper and corepipe_app can run...

> This commit,
>
> 9899d11f654474d2d54ea52ceaa2a1f4db3abd68

> seems to put a damper on ptracing the application at this point.

How can this commit make any difference? It should not.

> So I wanted to see what you think of all this.. Can we add an exception
> to this which would allow operations on a task which is dumping core,

Which ptrace request you think should work at this stage? The coredumping
task is dying, it can't report, say, signal or syscall. It can report
nothing except PTRACE_EVENT_EXIT, but only after it closes the pipe.

> but still has SIGKILL pending. The other way would be to not add SIGKILL
> till after the pipe app runs.

See above.

> As of right now I can PTRACE_ATTACH, but the operations all fail with
> -ESRCH .

Sure, because the tracee doesn't (and shouldn't) stop, iow it doesn't
report any event.



Could you explain what actually you are trying to do? And what exactly
doesn't work as you expected?

Now that the coredump is killable (-mm patches), _perhaps_ we can, say,
add PTRACE_EVENT_CORED_DUMPED reported after binfmt->core_dump(). Not
sure this is what you need...

Oleg.

