Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3H2WIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:08:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54326 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3H2WIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:08:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20130829211114.GA20726@sergelap>
Date: Thu, 29 Aug 2013 15:08:41 -0700
In-Reply-To: <20130829211114.GA20726@sergelap> (Serge Hallyn's message of
	"Thu, 29 Aug 2013 16:11:14 -0500")
Message-ID: <87d2ow2lqu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19CJzPZXiUTsgEzh6beqPnbYkZpBSyYVWQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3121]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Make sure to wake reaper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
> possible to get into a situation where a pidns reaper is
> <defunct>, reparented to host pid 1, but never reaped.  How to
> reproduce this is documented at

Commit 751c644b95bb48aaa8825f0c66abbcc184d92051 also played a role
where we started handling multi-threaded inits but the wake-up remains
broken.

> https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
> (and see
> https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
> In short, run repeated starts of a container whose init is
>
> Process.exit(0);
>
> sysrq-t when such a task is playing zombie shows:
>
> [  131.132978] init            x ffff88011fc14580     0  2084   2039 0x00000000
> [  131.132978]  ffff880116e89ea8 0000000000000002 ffff880116e89fd8 0000000000014580
> [  131.132978]  ffff880116e89fd8 0000000000014580 ffff8801172a0000 ffff8801172a0000
> [  131.132978]  ffff8801172a0630 ffff88011729fff0 ffff880116e14650 ffff88011729fff0
> [  131.132978] Call Trace:
> [  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
> [  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
> [  131.132978]  [<ffffffff81071eae>] ? signal_wake_up_state+0x1e/0x30
> [  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
> [  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
> [  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6
>
> Further debugging showed that every time this happened, zap_pid_ns_processes()
> started with nr_hashed being 3, while we were expecting it to drop to 2.
> Any time it didn't happen, nr_hashed was 1 or 2.  So the reaper was
> waiting for nr_hashed to become 2, but free_pid() only wakes the reaper
> if nr_hashed hits 1.  This patch makes free_pid() wake the reaper any
> time the reaper is PF_EXITING, to force it to re-test the
> pidns->nr_hashed = init_pids test.  Note that this is more like what
> __unhash_process() used to do before
> af4b8a83add95ef40716401395b44a1b579965f4.

I completely agree with your problem analysis.  All we hold in
free_pid is the pidmap_lock.  Not the task_lock which guards
ns->child_reaper nor the signhand lock which guards PF_EXITING.

I think a final patch needs an analysis why whichever wakeup scheme we
use does not have races which will result in the failure to send a
wakeup.

Using a default case and PF_EXITING test while retaing the previous
nr_hashed == 1 seems a little hacky.

Regardless thank you for all of your hard work to track this one down.

I feel silly for not considering the wakeup side before.

> Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/pid.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 0db3e79..6b312c4 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -274,6 +274,10 @@ void free_pid(struct pid *pid)
>  		case 0:
>  			schedule_work(&ns->proc_work);
>  			break;
> +		default:
> +			if (ns->child_reaper->flags & PF_EXITING)
> +				wake_up_process(ns->child_reaper);
> +			break;
>  		}
>  	}
>  	spin_unlock_irqrestore(&pidmap_lock, flags);
