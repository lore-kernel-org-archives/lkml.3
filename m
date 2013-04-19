Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567Ab3DSOJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:09:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34839 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503Ab3DSOJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:09:51 -0400
Date: Fri, 19 Apr 2013 15:09:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Neil Zhang <zhangwm@marvell.com>, Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chao Xie <chao.xie@marvell.com>
Subject: Re: [PATCH 4/4] ARM: mmp: add SMP support for pxa988
Message-ID: <20130419140938.GT14496@n2100.arm.linux.org.uk>
References: <1365651547-11583-1-git-send-email-zhangwm@marvell.com> <CAN1soZxCX1oUg69MTy0ZAL2vH8SOywDBaZHJ7wgnwgasxPAPdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZxCX1oUg69MTy0ZAL2vH8SOywDBaZHJ7wgnwgasxPAPdQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 09:08:12PM +0800, Haojian Zhuang wrote:
> On Thu, Apr 11, 2013 at 11:39 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> > +       /*
> > +        * Synchronise with the boot thread.
> > +        */
> > +       spin_lock(&boot_lock);
> > +       spin_unlock(&boot_lock);
> Lock & unlock without protecting anything. If so, you can remove this.

... which means you don't understand what is going on in this code,
and probably didn't read the comment above this fragment.  The above
is to synchronise with the code below - again, read the comment at
the spin unlock in this function, remembering that the above code
and the code below runs concurrently on two different CPUs:

> > +static int __cpuinit mmp_boot_secondary(unsigned int cpu, struct task_struct *idle)
> > +{
> > +       unsigned long timeout;
> > +
> > +       /*
> > +        * Avoid timer calibration on slave cpus. Use the value calibrated
> > +        * on master cpu. Referenced from tegra3
> > +        */
> > +       preset_lpj = loops_per_jiffy;
> > +
> > +       /*
> > +        * set synchronisation state between this boot processor
> > +        * and the secondary one
> > +        */
> > +
> > +       spin_lock(&boot_lock);
> > +
> > +       /*
> > +        * The secondary processor is waiting to be released from
> > +        * the holding pen - release it, then wait for it to flag
> > +        * that it has been released by resetting pen_release.
> > +        *
> > +        * Note that "pen_release" is the hardware CPU ID, whereas
> > +        * "cpu" is Linux's internal ID.
> > +        */
> > +       write_pen_release(cpu);
> > +
> > +       /* reset the cpu, let it branch to the kernel entry */
> > +       mmp_cpu_power_up(cpu);
> > +
> > +       timeout = jiffies + (1 * HZ);
> > +       while (time_before(jiffies, timeout)) {
> > +               smp_rmb();
> > +               if (pen_release == -1)
> > +                       break;
> > +
> > +               udelay(10);
> > +       }
> > +
> > +       /*
> > +        * now the secondary core is starting up let it run its
> > +        * calibrations, then wait for it to finish
> > +        */
> > +       spin_unlock(&boot_lock);
> > +
> > +       return pen_release != -1 ? -ENOSYS : 0;
> > +}
