Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbaIRCnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:43:22 -0400
Received: from ozlabs.org ([103.22.144.67]:36745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbaIRCnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:43:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, amit.shah@redhat.com, linux-kernel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 2/3] hw_random: fix stuck in catting hwrng attributes
In-Reply-To: <1410796949-2221-3-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com> <1410796949-2221-3-git-send-email-akong@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 18 Sep 2014 12:13:08 +0930
Message-ID: <87wq91odhf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Kong <akong@redhat.com> writes:

> I started a QEMU (non-smp) guest with one virtio-rng device, and read
> random data from /dev/hwrng by dd:
>
>  # dd if=/dev/hwrng of=/dev/null &
>
> In the same time, if I check hwrng attributes from sysfs by cat:
>
>  # cat /sys/class/misc/hw_random/rng_*
>
> The cat process always gets stuck with slow backend (5 k/s), if we
> use a quick backend (1.2 M/s), the cat process will cost 1 to 2
> minutes. The stuck doesn't exist for smp guest.
>
> Reading syscall enters kernel and call rng_dev_read(), it's user
> context. We used need_resched() to check if other tasks need to
> be run, but it almost always return false, and re-hold the mutex
> lock. The attributes accessing process always fails to hold the
> lock, so the cat gets stuck.
>
> User context doesn't allow other user contexts run on that CPU,
> unless the kernel code sleeps for some reason. This is why the
> need_reshed() always return false here.
>
> This patch removed need_resched() and always schedule other tasks
> then other tasks can have chance to hold the lock and execute
> protected code.

OK, this is going to be a rant.

Your explanation doesn't make sense at all.  Worse, your solution breaks
the advice of Kernighan & Plaugher: "Don't patch bad code - rewrite
it.".

But worst of all, this detailed explanation might have convinced me you
understood the problem better than I did, and applied your patch.

I did some tests.  For me, as expected, the process spends its time
inside the virtio rng read function, holding the mutex and thus blocking
sysfs access; it's not a failure of this code at all.

Your schedule_timeout() "fix" probably just helps by letting the host
refresh entropy, so we spend less time waiting in the read fn.

I will post a series, which unfortunately is only lightly tested, then
I'm going to have some beer to begin my holiday.  That may help me
forget my disappointment at seeing respected fellow developers
monkey-patching random code they don't understand.

Grrr....
Rusty.

> Signed-off-by: Amos Kong <akong@redhat.com>
> ---
>  drivers/char/hw_random/core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index c591d7e..263a370 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -195,8 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  
>  		mutex_unlock(&rng_mutex);
>  
> -		if (need_resched())
> -			schedule_timeout_interruptible(1);
> +		schedule_timeout_interruptible(1);
>  
>  		if (signal_pending(current)) {
>  			err = -ERESTARTSYS;
> -- 
> 1.9.3

