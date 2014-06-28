Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaF1V6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:58:42 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38540 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751371AbaF1V6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:58:40 -0400
Date: Sat, 28 Jun 2014 17:58:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lukas M?rdian <lukas@goldelico.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on
 resume
In-Reply-To: <20140628200410.GA7561@amd.pavel.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1406281755450.6272-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014, Pavel Machek wrote:

> Hi!
> 
> > >> This gives the userspace (Replicant) a chance to fully handle the
> > >> pm_wakeup_event, before autosleep suspends the system alltogether
> > >> again.
> > >> 
> > >> This fixes suspend/resume on the OpenPhoenux GTA04, in combination with
> > >> the Replicant 4.2.2 userspace, which needs to execute this to stay
> > >> awake: 'echo on > /sys/power/state'
> > >> 
> > >> Signed-off-by: Lukas Märdian <lukas@goldelico.com>
> > >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> > > 
> > > I'm sorry, but we should not be doing this.
> > > 
> > > You basically put a delay in driver to work around userspace bug.
> > 
> > Do you think it is a user-space bug if the kernel goes to sleep again
> > before giving user space any chance to react to an event?
> 
> Well, who says 1000msec is enough? Some userspace may need
> more. ... for example on PC when you keyboard-handling deamon is
> swapped out.
> 
> > And the msec parameter is described as:
> > 
> > @msec: Anticipated event processing time (in milliseconds).
> > 
> > Isn't calling pm_wakeup_event() with a non-zero msec the standard
> > method to handle this situation? And it is used in other drivers. E.g. in
> > _mmc_detect_change() or hub_suspend().
> 
>  * Notify the PM core of a wakeup event whose source is @ws that will
>    take                    
>  * approximately @msec milliseconds to be processed by the kernel.  If
>    @ws is                 
>  * not active, activate it.  If @msec is nonzero, set up the @ws'
>    timer to                    
>  * execute pm_wakeup_timer_fn() in future.                                                    
> 
> Will take @msec milliseconds to be processed by the _kernel_. Yes, USB
> probing takes a lot of time in kernel. But you are using this
> parameter to wait for userspace...
> 
> > > There must be better
> > > solution....
> >  
> > I am not sure how it could look like.
> 
> Rafael, do you have any idea how this is supposed to work?
> 
> Original patch is at https://lkml.org/lkml/2014/4/10/156 .

One possibility is not to use autosleep at all.  The user program,
instead of writing "on" to /sys/power/state to stay awake, would have
to write "mem" to go to sleep when no more work remained to be handled.

Alan Stern

