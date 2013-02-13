Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3BMMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:48:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42038 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab3BMMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:48:27 -0500
Date: Wed, 13 Feb 2013 12:43:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "Hilman, Kevin" <khilman@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH v2 3/4] mtd: devices: elm: Low power transition support
Message-ID: <20130213124303.GM17852@n2100.arm.linux.org.uk>
References: <1360240618-11094-1-git-send-email-avinashphilip@ti.com> <1360240618-11094-4-git-send-email-avinashphilip@ti.com> <20130209102243.GH17852@n2100.arm.linux.org.uk> <518397C60809E147AF5323E0420B992E3EA7491C@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA7491C@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:42:01AM +0000, Philip, Avinash wrote:
> On Sat, Feb 09, 2013 at 15:52:44, Russell King - ARM Linux wrote:
> > On Thu, Feb 07, 2013 at 06:06:57PM +0530, Philip Avinash wrote:
> > > +static int elm_suspend(struct device *dev)
> > > +{
> > > +	struct elm_info *info = dev_get_drvdata(dev);
> > > +	wait_queue_head_t wq;
> > > +	DECLARE_WAITQUEUE(wait, current);
> > > +
> > > +	init_waitqueue_head(&wq);
> > > +	while (1) {
> > > +		/* Make sure that ELM not running */
> > > +		if (info->idle) {
> > > +			add_wait_queue(&wq, &wait);
> > > +			schedule();
> > > +			remove_wait_queue(&wq, &wait);
> > > +		} else {
> > > +			break;
> > > +		}
> > > +	}
> > 
> > The above code looks really wrong - it will just spin endlessly with the
> > waitqueues doing nothing useful.  What are you trying to do here?
> 
> The intention of waitqeue is to make the suspend process really wait till
> the ELM module finishes current activity. Although this type of protection
> already achieved in mtd layer using nand_suspend(), this one is particularly
> required for ELM module to really make sure that *any pending* corrections to
> finish really before gone to suspend.

I don't think you understand what's going on with the above, and why the
above is completely ineffective.

1. Your wait queue head is declared on stack, and there's no references
   to it outside of this function.  So _nothing_ can activate the wait
   queue.
2. You're not changing the current thread's status away from TASK_RUNNING,
   so schedule() will either return immediately or it will schedule another
   task if it's time for this one to be preempted.

In other words, the above can be rewritten as:

	while (info->idle)
		schedule();

and it will still have the same effect.

Now, if you want to be kinder to the system, then you should use a
wait queue properly.  Put the waitqueue head in struct elm_info.  Use
wait_event() here.  And call wake_up() where you set info->idle to
false.
