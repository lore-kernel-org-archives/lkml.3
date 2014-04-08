Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaDHIju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:39:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44706 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbaDHIjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:39:45 -0400
Date: Tue, 8 Apr 2014 01:39:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20140408083940.GA22855@core.coreip.homeip.net>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20140407021015.GA8518@core.coreip.homeip.net>
 <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:54:23AM +0200, Samuel Thibault wrote:
> Dmitry Torokhov, le Sun 06 Apr 2014 19:10:15 -0700, a écrit :
> > On Mon, Mar 31, 2014 at 02:23:23PM +0200, Samuel Thibault wrote:
> > > This permits to reassign keyboard LEDs to something else than keyboard "leds"
> > > state, by adding keyboard led and modifier triggers connected to a series
> > > of VT input LEDs, themselves connected to VT input triggers, which
> > > per-input device LEDs use by default.  Userland can thus easily change the LED
> > > behavior of (a priori) all input devices, or of particular input devices.
> > > 
> > 
> > I still have the same concern that I believe I already mentioned a while
> > ago: how do we reconcile the LED control via triggers with LED control
> > done through event devices?
> 
> I don't remember that raised during the discussion.

Hmm, I might be mistaken, I thought I did mention that.

> 
> > Currently, as far as I can see, they will be
> > clashing with each other. I.e. if I remap my capslock led to be the new
> > shiftlock and then userspace writes EV_LED/LED_CAPSL it would light up
> > my new "shift lock", right?
> 
> Well, yes, sure, if you shoot in your foot it will hurt :) (although
> here the damage is really small, it is just LED lighting or not).

This is not about amount of damage but the overall correctness of the
implementation. I'd rather not have a solution with known holes, if
possible.

> 
> I don't see why people would both tinker with such triggers and run
> userland programs writing to evdev.  Of course it typically happens with
> X, but that's not a problem in the usual case: kbd triggers are not
> doing anything while on X, so X can play with evdev with no problem.
> If the user puts e.g. a heartbeat on some LED and then runs X, the X
> events will mix with the heartbeat.  The solution is for the user to
> just disable the corresponding LED in the X keyboard configuration.
> Do we really want to impose some overriding between VT-generated and
> other application-generated events?  AIUI, we don't do this between
> applications which would open the same evdev, so I don't see why we
> should care more about the VT.

It is not about the VT, I am talking about pure input core. If I
repurpose CapsLock LED for my WiFi indicator I do not want to go into
other programs and teach them that they should stay away from trying to
control this LED. IOW if we switch to LED-subsystem-backed LEDs then we
should go all the way and implement this cleanly.

> 
> > Also I wonder if we really need to have the multiplexing (VT-level) leds
> > in addition to per-device ones.
> 
> We do: we want to be able to easily remap all (current and future)
> keyboards' LEDs easily.
> 
> My goal, at the beginning, was to be able to fix the console-setup
> bug.  That was that console-setup wants to use, for the capslock key,
> something else than the capslock mechanism hard-wired in the kernel,
> so as to get way more fine-grain control over how caps is handled.
> But then the capslock LED would not lit any more.  By remapping the
> VT-level capslock led to the foo-lock used by console-setup, one gets
> back capslock LEDs of all keyboards working back as expected by the
> user.  I also use it for getting a group LED, just like I have on X,
> to know which keyboard layout group I am in.  People using non-latin
> layouts really need that.

I understand the desire, however I still wonder if we should be
extending legacy VT given that David wants to move it all to userspace.

Thanks.

-- 
Dmitry
