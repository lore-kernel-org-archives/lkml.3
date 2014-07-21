Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaGUP2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:28:54 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35624 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGUP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:28:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adam Wozniak <awozniak@irobot.com>
Cc: linux-kernel@vger.kernel.org, linux-arm@lists.infradead.org,
        linux-usb@vger.kernel.org, "Agius, Frank" <fagius@irobot.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: high cpu load on omap3 using musb
Date: Mon, 21 Jul 2014 17:28:58 +0200
Message-ID: <3341916.JePQu0RYOt@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52E93009.1090609@irobot.com>
References: <52E93009.1090609@irobot.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On Wednesday 29 January 2014 08:44:57 Adam Wozniak wrote:
> With a USB 2.0 webcam attached to the OTG port on an OMAP3 (applies to
> overo gumstix, beagleboard, probably others) we see a high CPU load in a
> kworker thread.
> 
> Between 2.6.33 and 2.6.34 musb_core.c changed.
> 
> IRQ handlers changed with the result that a worker in musb_core.c got
> scheduled far more frequently than needed.
> 
> I've included a patch below against 3.7, but i think it'll apply against
> mainline.
> [I apologize for any whitespace mangling.  I've also attached the patch.]
> 
> I'd like more eyeballs to tell me if this is right.  I'd also like to
> know who I need to talk to to get this pushed into mainline.

Running the scripts/get_maintainer.pl script on your patch produces

Felipe Balbi <balbi@ti.com> (maintainer:MUSB MULTIPOINT H...)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBSYSTEM)
linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
linux-kernel@vger.kernel.org (open list)

Felipe Balbi (CC'ed) is the person who you should talk to.

While we're touching the subject of scripts, you should run the 
scripts/checkpatch.pl script and fix errors and warnings before submitting 
patches. Please see Documentation/SubmittingPatches.

Last (but not least) piece of advice, don't give up if you don't receive 
replies to your patches. People are busy and mails fall to cracks from time to 
time.

Felipe, apart from the coding style violation and the possibly missing 
locking, what's your opinion on this ? Does the patch make sense ?

> # The MUSB IRQ schedules work on every interrupt.
> # This is unnecessary, and causes excessive CPU load.
> #
> # Here we only schedule work if there is something for
> # the worker to do.
> 
> Index: git/drivers/usb/musb/musb_core.c
> ===================================================================
> --- git.orig/drivers/usb/musb/musb_core.c
> +++ git/drivers/usb/musb/musb_core.c
> @@ -925,7 +925,9 @@ b_host:
>          }
>   #endif
> 
> -       schedule_work(&musb->irq_work);
> +       if (musb->xceiv->state != musb->xceiv_old_state) {
> +               schedule_work(&musb->irq_work);
> +       }
> 
>          return handled;
>   }

-- 
Regards,

Laurent Pinchart

