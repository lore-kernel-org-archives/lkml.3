Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088Ab3DBNqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:46:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56090 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759483Ab3DBNqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:46:47 -0400
Date: Tue, 2 Apr 2013 15:46:45 +0200
From: Pavel Machek <pavel@denx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dzu@denx.de
Subject: Re: UIO device tree bindings.
Message-ID: <20130402134645.GB9975@amd.pavel.ucw.cz>
References: <20130401142336.GA18034@amd.pavel.ucw.cz>
 <20130401154008.GA20963@amd.pavel.ucw.cz>
 <20130402024212.GA19431@roeck-us.net>
 <20130402115151.GA9052@amd.pavel.ucw.cz>
 <20130402125149.GA7216@roeck-us.net>
 <20130402131951.GA9975@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402131951.GA9975@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Or maybe we can do some magic with module parameter. That should be
> > > enough for expected use.
> > > 
> > I don't think that would make a difference. I mean, just take ns16550 as another
> > example. No one has problems declaring some block of hardware addresses to be
> > compatible with "ns16550", even though it can be anything including a memory
> > block on one of the FPGAs or ASICs we are talking about here, it can be anything
> > but a NS16550, and many of the actual "compatible" strings are not defined
> > anythere either.
> > 
> > So there is no problem with "ata-generic" and "ns16550", and no one cares if
> > "fsl,mpc8349emitx-pata" or "xlnx,xps-uart16550-2.00.b" is defined or not, but
> > "generic-uio" together with "ptx,c64fpga001" is unacceptable.
> > 
> > I think it has more to do with the uio driver not being an actual driver, but
> > the kernel part of a user-space driver, though that is just a wild guess.
> 
> Well, it turned out that adding module parameter was not that much
> work... and yes I believe it is a tiny bit cleaner.
> 
> Here's updated patch, if you can please test this one.
> 
> [You can just pass "uio_of_genirq.of_id=generic-uio" to get previous
> behaviour. But don't tell anyone :-)]

Actually, looking at it some more, perhaps even solution is possible?
(This will need uio_pdrv_genirq.of_id=generic-uio .)

Unfortunately, I don't have easy way to test this :-(. So feedback is
essential.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 4a50ead..64b6dac 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -271,9 +273,13 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id uio_of_genirq_match[] = {
-	{ /* empty for now */ },
+	{ /* This is filled with module_parm */ },
+	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
+MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
 #else
 # define uio_of_genirq_match NULL
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
