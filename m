Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaLCX6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:58:41 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52914 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCX6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:58:39 -0500
Date: Thu, 4 Dec 2014 00:58:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] context_tracking: Restore previous state in schedule_user
Message-ID: <20141203235835.GE31369@lerouge>
References: <20141203220836.GC31369@lerouge>
 <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 03:18:41PM -0800, Andy Lutomirski wrote:
> It appears that some SCHEDULE_USER (asm for schedule_user) callers
> in arch/x86/kernel/entry_64.S are called from RCU kernel context,
> and schedule_user will return in RCU user context.  This causes RCU
> warnings and possible failures.
> 
> This is intended to be a minimal fix suitable for 3.18.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Ah, we sent it about at the same time :-)

Might be too late for 3.18 though because it's not a regression.

> ---
> 
> Hi all-
> 
> This is intended to be a suitable last-minute fix for the RCU issue that
> Dave saw.
> 
> Dave, can you confirm that this fixes it?
> 
> Frédéric, can you confirm that you think that this will have no effect
> on correct callers of schedule_user and that will do the right thing
> for incorrect callers of schedule_user?

Yes it should be fine.

> 
> I don't like the x86 asm that calls this at all, and I don't really
> like the fragility of the mechanism is general, but I think that this
> improves the situation enough to avoid problems in the short term.

At best we should have only one call to user_enter() at the end of the
syscall and exception path once we've completed everything (pending reschedule,
tracing, signals, ...) instead of context tracking fixups on functions that
can be called after syscall_trace_leave(), but that would impact the fastpath.

Although it should be possible to tweak the slow path to do that...

> 
> With the obvious warning added, I get:
> 
> [    0.751022] ------------[ cut here ]------------
> [    0.751937] WARNING: CPU: 0 PID: 72 at kernel/sched/core.c:2883 schedule_user+0xcf/0xe0()
> [    0.753477] Modules linked in:
> [    0.754089] CPU: 0 PID: 72 Comm: mount Not tainted 3.18.0-rc7+ #653
> [    0.755258] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> [    0.757655]  0000000000000009 ffff880005c13f00 ffffffff81741dca ffff8800069f5a50
> [    0.759228]  0000000000000000 ffff880005c13f40 ffffffff8108e781 0000000000000246
> [    0.760758]  0000000000000000 00007fff970441c8 00007fff97043fd0 00007f67794ebcc8
> [    0.762294] Call Trace:
> [    0.762775]  [<ffffffff81741dca>] dump_stack+0x46/0x58
> [    0.763739]  [<ffffffff8108e781>] warn_slowpath_common+0x81/0xa0
> [    0.764865]  [<ffffffff8108e85a>] warn_slowpath_null+0x1a/0x20
> [    0.765958]  [<ffffffff8174565f>] schedule_user+0xcf/0xe0
> [    0.766974]  [<ffffffff8174ae69>] sysret_careful+0x19/0x1c
> [    0.768011] ---[ end trace 329f34db2b3be966 ]---
> 
> So, yes, we have a bug, and this could cause any number of strange
> problems.
> 
>  kernel/sched/core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 24beb9bb4c3e..39d9d95331b7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2874,10 +2874,14 @@ asmlinkage __visible void __sched schedule_user(void)
>  	 * or we have been woken up remotely but the IPI has not yet arrived,
>  	 * we haven't yet exited the RCU idle mode. Do it here manually until
>  	 * we find a better solution.

Just need to fix the above comment.

> +	 *
> +	 * NB: There are buggy callers of this function.  Ideally we
> +	 * should warn if prev_state != IN_USER, but that will trigger
> +	 * to frequently to make sense yet.

It's not really the callers of this function that are buggy but the
way we handled context tracking.

>  	 */
> -	user_exit();
> +	enum ctx_state prev_state = exception_enter();
>  	schedule();
> -	user_enter();
> +	exception_exit(prev_state);
>  }
>  #endif
>  
> -- 
> 1.9.3
> 
