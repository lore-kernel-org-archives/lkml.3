Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaIRMtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:49:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaIRMtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:49:04 -0400
Date: Thu, 18 Sep 2014 20:47:45 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 2/3] hw_random: fix stuck in catting hwrng attributes
Message-ID: <20140918124745.GB29803@air.redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
 <1410796949-2221-3-git-send-email-akong@redhat.com>
 <87wq91odhf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq91odhf.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:13:08PM +0930, Rusty Russell wrote:
> Amos Kong <akong@redhat.com> writes:
> 
> > I started a QEMU (non-smp) guest with one virtio-rng device, and read
> > random data from /dev/hwrng by dd:
> >
> >  # dd if=/dev/hwrng of=/dev/null &
> >
> > In the same time, if I check hwrng attributes from sysfs by cat:
> >
> >  # cat /sys/class/misc/hw_random/rng_*
> >
> > The cat process always gets stuck with slow backend (5 k/s), if we
> > use a quick backend (1.2 M/s), the cat process will cost 1 to 2
> > minutes. The stuck doesn't exist for smp guest.
> >
> > Reading syscall enters kernel and call rng_dev_read(), it's user
> > context. We used need_resched() to check if other tasks need to
> > be run, but it almost always return false, and re-hold the mutex
> > lock. The attributes accessing process always fails to hold the
> > lock, so the cat gets stuck.
> >
> > User context doesn't allow other user contexts run on that CPU,
> > unless the kernel code sleeps for some reason. This is why the
> > need_reshed() always return false here.
> >
> > This patch removed need_resched() and always schedule other tasks
> > then other tasks can have chance to hold the lock and execute
> > protected code.
 
Hi Rusty,

> OK, this is going to be a rant.
> 
> Your explanation doesn't make sense at all.  Worse, your solution breaks
> the advice of Kernighan & Plaugher: "Don't patch bad code - rewrite
> it.".
> 
> But worst of all, this detailed explanation might have convinced me you
> understood the problem better than I did, and applied your patch.
 
I'm sorry about the misleading.

> I did some tests.  For me, as expected, the process spends its time
> inside the virtio rng read function, holding the mutex and thus blocking
> sysfs access; it's not a failure of this code at all.

Got it now.

The catting hang bug was found when I try to fix unhotplug issue, the
unhotplug issue can't be reproduced if I try to debug by gdb or
printk. So I forgot to debug cat hang ... but spend time to misunderstand
schedle code :(

> Your schedule_timeout() "fix" probably just helps by letting the host
> refresh entropy, so we spend less time waiting in the read fn.
> 
> I will post a series, which unfortunately is only lightly tested, then
> I'm going to have some beer to begin my holiday.  That may help me
> forget my disappointment at seeing respected fellow developers
> monkey-patching random code they don't understand.

I just posted a V2 with two additional fixes, hotunplugging works well now :)

> Grrr....

Enjoy your holiday!
Amos

> Rusty.
>
> > Signed-off-by: Amos Kong <akong@redhat.com>
> > ---
> >  drivers/char/hw_random/core.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > index c591d7e..263a370 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -195,8 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
> >  
> >  		mutex_unlock(&rng_mutex);
> >  
> > -		if (need_resched())
> > -			schedule_timeout_interruptible(1);
> > +		schedule_timeout_interruptible(1);
> >  
> >  		if (signal_pending(current)) {
> >  			err = -ERESTARTSYS;
> > -- 
> > 1.9.3

-- 
			Amos.
