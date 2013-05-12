Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3ELQNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:13:45 -0400
Received: from canardo.mork.no ([148.122.252.1]:40716 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3ELQNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:13:44 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: paulmck@linux.vnet.ibm.com
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time as with v3.9
Organization: m
References: <87r4hdjsu5.fsf@nemi.mork.no>
	<20130512113157.GG3648@linux.vnet.ibm.com>
Date: Sun, 12 May 2013 18:13:34 +0200
In-Reply-To: <20130512113157.GG3648@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Sun, 12 May 2013 04:31:57 -0700")
Message-ID: <87hai8kwgh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> We don't want to back out the RCU_FAST_NO_HZ changes due to their
> energy-efficiency benefits.

Yes, that's what I assumed.  Just didn't know where to start dissecting
it...

>  So could you please try out Borislav's
> patch below?  He ran into the same issue a few weeks ago, and this
> one fixed it for him.
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Expedite grace periods during suspend/resume
>
> CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> a factor of four, which can result in long suspend and resume times.
> Thus, this commit temporarily switches to expedited grace periods when
> suspending the box and return to normal settings when resuming.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a9610d1..d9604a4 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -53,6 +53,7 @@
>  #include <linux/delay.h>
>  #include <linux/stop_machine.h>
>  #include <linux/random.h>
> +#include <linux/suspend.h>
>=20=20
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -3003,6 +3004,22 @@ static int __cpuinit rcu_cpu_notify(struct notifie=
r_block *self,
>  	return NOTIFY_OK;
>  }
>=20=20
> +static int rcu_pm_notify(struct notifier_block *self,
> +			 unsigned long action, void *hcpu)
> +{
> +	switch (action) {
> +	case PM_HIBERNATION_PREPARE:
> +		rcu_expedited =3D 1;
> +		break;
> +	case PM_POST_RESTORE:
> +		rcu_expedited =3D 0;
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  /*
>   * Spawn the kthread that handles this RCU flavor's grace periods.
>   */
> @@ -3243,6 +3260,7 @@ void __init rcu_init(void)
>  	 * or the scheduler are operational.
>  	 */
>  	cpu_notifier(rcu_cpu_notify, 0);
> +	pm_notifier(rcu_pm_notify, 0);
>  	for_each_online_cpu(cpu)
>  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
>  }


Thanks!  This patch did not make any difference for me by itself, for
pretty obvious reasons (I didn't time restore from hibernate - only from
suspend). But it pointed me in the right direction.  Applying the
attached patch on top of that one fixed the problem.

Note that I'm also changing the restore from hibernate hook. According
to Documentation/power/notifiers.txt :

 PM_POST_RESTORE         An error occurred during restore from hibernation.
                         Device drivers' restore callbacks have been execut=
ed
                         and tasks have been thawed.


I believe Borislav must have meant=20

 PM_POST_HIBERNATION     The system memory state has been restored from a
                         hibernation image or an error occurred during
                         hibernation.  Device drivers' restore callbacks ha=
ve
                         been executed and tasks have been thawed.

in the above patch?

Please include some combination of these patches in your upcoming v3.10
fixes.  Thanks.



Bj=C3=B8rn


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline;
 filename=0001-rcu-Really-switch-to-expedited-grace-periods-for-sus.patch
Content-Transfer-Encoding: quoted-printable

>From cf169d21274911fea4b6a89a0a2c7b370d9de441 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Sun, 12 May 2013 17:51:10 +0200
Subject: [PATCH] rcu: Really switch to expedited grace periods for suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit 587ff2cf ("rcu: Expedite grace periods during suspend/resume")
enabled expedited grace periods for hibernation, but not for suspend.
The same issue applies to both cases, so apply the same logic.

Restoring on post hibernation and post suspend, but not on post
restore, which only applies to the restore error case.

Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 kernel/rcutree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6934238..2dcbf84 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
 {
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
 		rcu_expedited =3D 1;
 		break;
-	case PM_POST_RESTORE:
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
 		rcu_expedited =3D 0;
 		break;
 	default:
--=20
1.7.10.4


--=-=-=--
