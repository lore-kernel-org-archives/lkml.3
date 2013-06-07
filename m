Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3FGSlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:41:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3FGSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:41:01 -0400
Date: Fri, 7 Jun 2013 11:41:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Stoffregen <paul@pjrc.com>
Subject: Re: [PATCH] USB: cdc-acm: remove unneeded spin_lock_irqsave/restore
 on write path
Message-ID: <20130607184100.GA7139@kroah.com>
References: <20130607183247.GA6850@kroah.com>
 <51B228A6.3010908@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B228A6.3010908@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:38:30PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 06/07/2013 10:32 PM, Greg Kroah-Hartman wrote:
> 
> >From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >When writing data we were:
> >	lock
> >	do some work
> >	unlock
> >	call function
> >		lock
> >		do some work
> >		unlock
> >		return
> >	return
> >
> >It turns out, that "function" was only ever called in the one place, so
> >instead of locking/unlocking for no good reason, just inline the
> >function and only grab the lock once.
> >
> >This has sped up the pathological case of sending 1 byte packets to a
> >loop-back cdc-acm device from 49600 bytes per second to 50100 bytes a
> >second on my workstation.  A tiny increase yes, but noticable, and now
> >the spinlock isn't the hottest thing on the perf graph anymore.  Yes, we
> >are still waiting for the hardware for the most part, but getting rid of
> >a spin_lock_irqsave() call for every packet is still a good thing.
> >
> >And we end up deleting lines of code, always a win overall.
> >
> >This was found by using a Teensy 3.0 device and the test program and
> >firmware located at:
> >	http://www.pjrc.com/teensy/benchmark_usb_serial_receive.html
> >
> >Reported-by: Paul Stoffregen <paul@pjrc.com>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >---
> >  drivers/usb/class/cdc-acm.c |   51 +++++++++++++++-----------------------------
> >  1 file changed, 18 insertions(+), 33 deletions(-)
> >
> >--- a/drivers/usb/class/cdc-acm.c
> >+++ b/drivers/usb/class/cdc-acm.c
> [...]
> >@@ -653,13 +621,30 @@ static int acm_tty_write(struct tty_stru
> >  	}
> >  	wb = &acm->wb[wbn];
> >+	if (!acm->dev) {
> >+		wb->use = 0;
> >+		spin_unlock_irqrestore(&acm->write_lock, flags);
> >+		return -ENODEV;
> >+	}
> >+
> >  	count = (count > acm->writesize) ? acm->writesize : count;
> >  	dev_vdbg(&acm->data->dev, "%s - write %d\n", __func__, count);
> >  	memcpy(wb->buf, buf, count);
> >  	wb->len = count;
> >  	spin_unlock_irqrestore(&acm->write_lock, flags);
> >-	stat = acm_write_start(acm, wbn);
> >+	usb_autopm_get_interface_async(acm->control);
> >+	if (acm->susp_count) {
> >+		if (!acm->delayed_wb)
> >+			acm->delayed_wb = wb;
> >+		else
> >+			usb_autopm_put_interface_async(acm->control);
> >+		spin_unlock_irqrestore(&acm->write_lock, flags);
> 
>    But you've already dropped it above the *if* and not taken again?

Oops, it needs to move down a bit further, let me respin this...

greg k-h
