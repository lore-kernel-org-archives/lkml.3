Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaLTH1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 02:27:24 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40282 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLTH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 02:27:20 -0500
Date: Fri, 19 Dec 2014 23:27:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv4] INPUT: Route keyboard LEDs through the generic LEDs
 layer.
Message-ID: <20141220072715.GA4637@dtor-ws>
References: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
 <20141219144641.3a549feb1ee5f2b9400f62cb@linux-foundation.org>
 <20141219225933.GD3049@type.youpi.perso.aquilenet.fr>
 <20141219230253.GA31928@amd>
 <20141219230721.GA31631@dtor-glaptop>
 <20141220021617.GE3049@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141220021617.GE3049@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 03:16:18AM +0100, Samuel Thibault wrote:
> Dmitry Torokhov, le Fri 19 Dec 2014 15:07:21 -0800, a écrit :
> > On Sat, Dec 20, 2014 at 12:02:53AM +0100, Pavel Machek wrote:
> > > On Fri 2014-12-19 23:59:33, Samuel Thibault wrote:
> > > > Andrew Morton, le Fri 19 Dec 2014 14:46:41 -0800, a écrit :
> > > > > > Changed in this version:
> > > > > > - Use kcalloc instead of kzalloc
> > > > > > - to avoid any mutex order violation, defer LED update into a work callback.
> > > > > 
> > > > > Confused.  This patch is identical to the one that's presently in -mm.
> > > > 
> > > > Well, yes: I'm submitting the latest version of this patch to Dmitry,
> > > > i.e. including the fixes that happened in the -mm tree.
> > > 
> > > Andrew, do you think you could send the patch to Dmitry? He has been
> > > ignoring it for way too long... and it should be slightly harder for
> > > him to ignore patch from you...
> > 
> > I'll keep ignoring the patch until someone will figure out how to make new way
> > of handling LEDs play well with the current way (via writing to evdev). That
> > means not treating access to evdev as "raw" and ignoring LED trigger remapping
> > done in LED layer. So far I just heard that it is not a problem and nobody uses
> > evdev interface...
> 
> ?! There must have been a misunderstanding, and the absence of response
> to my last mail (April 17th) didn't help to understand what you were
> expecting.  I'm sorry, but things can't work if there are not efforts to
> discuss on both sides.
> 
> I never said that nobody uses the evdev interface.

OK, them I must have misunderstood you indeed.

> 
> I just said that I wasn't sure to understand the scenario you were
> proposing.  I was asking for details, not barring discussion...  I'm
> fine with reworking my patch yet again, but I can't do that if I don't
> understand precisely the use-case you are expecting.
> 
> So, to recap what we apparently want:
> 
> (1) console-setup wants to be able to change which keyboard modifier is
> shown on the capslock LED
> (2) embedded people want to be able to plug the keyboard LED state to misc
> LEDs
> - people will quickly want to be able to repurpose their keyboard LEDs,
> for instance:
>   (3) make the numlock LED show disk activity
>   (4) exchange capslock and numlock LEDs for some reason.
> 
> And the question is: how all of that should be mixed?
> 
> ATM, we have this:
> 
> kbd state -> kbd led -> input led
>   ^^            ^^          ^^
> KDSKBLED     KDSETLED     EV_LED
> 
> What I had proposed and implemented in my current patch is the following
> pipeline:
> 
> kbd state -> kbd led -> kbd trigger -> vt led -> vt trigger -> input led
>   ^^           ^^                   ^^                      ^^        ^^
> KDSKBLED   KDSETLED   vt::capsl/trigger   input*::capsl/trigger   EV_LED
> 
> Which leaves the evdev users keeping raw control, unmodified.  In
> your mail from April 12th, you seemed to want that (4) have effect on
> evdev, I asked for confirmation, but never got an answer.  Your above
> paragraph seems to clearly show that you want evdev users to get at
> least the (4) remapping.  That wasn't obvious to me, because I had
> always considered evdev as a way to drive physical hardware, without any
> software abstraction.  But OK, let's go with that.
> 
> AIUI, what you would be OK with is the following:
> 
> kbd state -> kbd trigger -> kbd led -> input led -> input rawled
>    ^^                    ^^   ^^         ^^      ^^
> KDSKBLED  vt::capsl/trigger  KDSETLED  EV_LED  input*::capsl/trigger
> 
> Which, instead of introducing a "VT led", separates the input led into
> the part exposed to other systems (kbd, evdev) and the lowlevel part.  I
> have here also fixed the behavior of KDSETLED: in my patch proposal it
> would get redirected by console-setup, which I believe we don't want.
> 
> So for (1) console-setup would use vt::capsl/trigger to make it use
> another modifier, and this would only have effect for actual capslock
> keypresses and KDSKBLED ioctls, which I believe is what we want
> (again, correct me if I'm wrong, but please detail, otherwise I can't
> know how I'm wrong); for (2) people would use input*::capsl/trigger*,
> which would now indeed have the nice effect of making e.g. Xorg
> getting the good behavior along the way; for (3) people would also use
> input*::capsl/trigger*, and that would now indeed prevent spurious
> changes from e.g. Xorg.
> 
> Now, there is (4).  I don't know why people would want that, but well,
> you mentioned it in some mail, so why not.

Reasoning is simple: your keyboard might lack a certain LED but you
might want to know the state. So you'd repurpose one led for another. It
is not really any different from case (2).

> Ideally it would go through
> input*::capsl/trigger*, but what to put there?  In my earlier proposal,
> that would have been vt-capsl, but you want the exchange to work on
> evdev access too.  A possibility would be to introduce a LED trigger for
> each input LED, like this:
> 
> kbd state -> kbd trigger -> kbd led -> input led -> input led trigger -> input rawled
>    ^^                    ^^   ^^          ^^                          ^^        
> KDSKBLED  vt::capsl/trigger  KDSETLED   EV_LED              input*::capsl/trigger
> 
> Which seems quite hairy: for each input LED we'd create both a trigger
> (gathering both the kbd led events and the evdev led events) and a LED
> (the actual physical LED), but why not.
> 
> To exchange capsl and numl, one would then have to do something like
> this:
> 
> for i in input*
> do
> 	echo $i-numl > /sys/class/leds/$i::capsl/trigger
> 	echo $i-capsl > /sys/class/leds/$i::numl/trigger
> done
> 
> That also opens the possibility of odd things like this:
> 
> echo input0-numl > /sys/class/leds/input1::capsl/trigger
> 
> i.e. all evdev numl events on input0 will actually also drive input1's
> capsl.  Why not.
> 
> Is it looking more like what you want?

Yes, I believe it is.

Also, can you please split off input core changes from tty changes in
your patch? I think it will be easier for me to digest it that way,
especially since LED state propagation between keyboards seems to be
broken even in console at the moment.

Thank you.

-- 
Dmitry
