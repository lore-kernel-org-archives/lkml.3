Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab3BMLnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:43:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54175 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901Ab3BMLnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:43:20 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Hilman, Kevin" <khilman@ti.com>, "tony@atomide.com" <tony@atomide.com>,
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
Subject: RE: [PATCH v2 3/4] mtd: devices: elm: Low power transition support
Thread-Topic: [PATCH v2 3/4] mtd: devices: elm: Low power transition support
Thread-Index: AQHOBTAgd8hAcqz1CEeizDN4kbqhDphw+DgAgATuAwA=
Date: Wed, 13 Feb 2013 11:42:01 +0000
Deferred-Delivery: Wed, 13 Feb 2013 11:42:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA7491C@DBDE01.ent.ti.com>
References: <1360240618-11094-1-git-send-email-avinashphilip@ti.com>
 <1360240618-11094-4-git-send-email-avinashphilip@ti.com>
 <20130209102243.GH17852@n2100.arm.linux.org.uk>
In-Reply-To: <20130209102243.GH17852@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 15:52:44, Russell King - ARM Linux wrote:
> On Thu, Feb 07, 2013 at 06:06:57PM +0530, Philip Avinash wrote:
> > +static int elm_suspend(struct device *dev)
> > +{
> > +	struct elm_info *info = dev_get_drvdata(dev);
> > +	wait_queue_head_t wq;
> > +	DECLARE_WAITQUEUE(wait, current);
> > +
> > +	init_waitqueue_head(&wq);
> > +	while (1) {
> > +		/* Make sure that ELM not running */
> > +		if (info->idle) {
> > +			add_wait_queue(&wq, &wait);
> > +			schedule();
> > +			remove_wait_queue(&wq, &wait);
> > +		} else {
> > +			break;
> > +		}
> > +	}
> 
> The above code looks really wrong - it will just spin endlessly with the
> waitqueues doing nothing useful.  What are you trying to do here?

The intention of waitqeue is to make the suspend process really wait till
the ELM module finishes current activity. Although this type of protection
already achieved in mtd layer using nand_suspend(), this one is particularly
required for ELM module to really make sure that *any pending* corrections to
finish really before gone to suspend.

If suspend activity initiated and NAND driver requested service of ELM
module for error correction, then suspend activity has to wait till
(info->idle == false), so that ELM module finishes activity.

I can think of adding different states to ELM module and take action.
I will add following states.

RUNNING
SUSPEND

Thanks
Avinash

> 

