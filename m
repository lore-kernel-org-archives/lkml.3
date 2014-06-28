Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaF1UEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:04:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48850 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaF1UEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:04:12 -0400
Date: Sat, 28 Jun 2014 22:04:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Lukas M?rdian <lukas@goldelico.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, stern@rowland.harvard.edu
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on
 resume
Message-ID: <20140628200410.GA7561@amd.pavel.ucw.cz>
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com>
 <20140628170820.GF23634@xo-6d-61-c0.localdomain>
 <BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> This gives the userspace (Replicant) a chance to fully handle the
> >> pm_wakeup_event, before autosleep suspends the system alltogether
> >> again.
> >> 
> >> This fixes suspend/resume on the OpenPhoenux GTA04, in combination with
> >> the Replicant 4.2.2 userspace, which needs to execute this to stay
> >> awake: 'echo on > /sys/power/state'
> >> 
> >> Signed-off-by: Lukas Märdian <lukas@goldelico.com>
> >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> > 
> > I'm sorry, but we should not be doing this.
> > 
> > You basically put a delay in driver to work around userspace bug.
> 
> Do you think it is a user-space bug if the kernel goes to sleep again
> before giving user space any chance to react to an event?

Well, who says 1000msec is enough? Some userspace may need
more. ... for example on PC when you keyboard-handling deamon is
swapped out.

> And the msec parameter is described as:
> 
> @msec: Anticipated event processing time (in milliseconds).
> 
> Isn't calling pm_wakeup_event() with a non-zero msec the standard
> method to handle this situation? And it is used in other drivers. E.g. in
> _mmc_detect_change() or hub_suspend().

 * Notify the PM core of a wakeup event whose source is @ws that will
   take                    
 * approximately @msec milliseconds to be processed by the kernel.  If
   @ws is                 
 * not active, activate it.  If @msec is nonzero, set up the @ws'
   timer to                    
 * execute pm_wakeup_timer_fn() in future.                                                    

Will take @msec milliseconds to be processed by the _kernel_. Yes, USB
probing takes a lot of time in kernel. But you are using this
parameter to wait for userspace...

> > There must be better
> > solution....
>  
> I am not sure how it could look like.

Rafael, do you have any idea how this is supposed to work?

Original patch is at https://lkml.org/lkml/2014/4/10/156 .
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
