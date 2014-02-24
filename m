Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaBXA7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:59:03 -0500
Received: from www.prifuk.cz ([31.31.77.241]:41629 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaBXA7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:59:00 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: Re: [PATCH v2 0/4] Add ff-memless-next and make hid-lg4ff use it
Date: Mon, 24 Feb 2014 01:58:53 +0100
Message-ID: <14991521.KzMVP7XS2h@geidi-prime>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCHMOD; KDE/4.12.2; x86_64; ; )
In-Reply-To: <530A931B.3020606@iki.fi>
References: <1516865.M993BQAYe4@geidi-prime> <530A931B.3020606@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 of February 2014 02:32:27 Anssi Hannula wrote:
> 24.02.2014 01:24, Michal Malý kirjoitti:
> > Hi everybody,
> 
> Hi,
> 
> > this patch series is a result of my work to improve FFB support for
> > memoryless devices. ff-memless-next is an improvement over the currently
> > available ff-memless which is well suited for joypads but cannot handle
> > more advanced devices such as racing wheels properly. As I have explained
> > in one of RFCs regarding ff-memless-next, the extent of the changes makes
> > implementing ff-memless-next as a patch to ff-memless unfeasible. As of
> > now there is a total of 27 drivers using ff-memless (including lg4ff) - a
> > lot of them joypads. I do not have access to any FFB joypad at the moment
> > so I cannot
> > implement the functionality required to handle joypads properly - namely
> > FF_RUMBLE and emulation of FF_PERIODIC through FF_RUMBLE.
> > The plan is to implement the missing functionality and replace ff-memless
> > completely in the future.
> 
> I think we should extend the current ff-memless instead of duplicating
> its functionality (even on a "for now" basis).
> 
> Having looked at ff-memless-next briefly, it seems very similar to
> ff-memless on its basic working principle, and therefore I don't really
> see why extending ff-memless would be too cumbersome. Unless I'm missing
> something - in that case, feel free to point it out to me :)

Deciding whether to patch ff-memless or write a new driver from scratch was a 
perfect example of being caught between the rock and a hard place. I am not
particularly fond of the fact that we would have two modules doing pretty much
the same thing. My reasons for writing a separate module were:
- Periodic effects. ff-memless doesn't do "real" periodic effects, it simply 
emulates them through rumble effect. Devices without rumble effect support 
require emulation through constant force effect. Just this was not something 
one could write in one afternoon:)
- Conditional effects. These effects cannot be by nature combined into one 
overall force (at least not easily) so they have to be handled one by one - 
this is a concept ff-memless does not seem to consider. FFB devices have 
limits as to how many conditional (referred to as "uncombinable" in MLNX) 
effects can be active simultaneously, etc.
All in all it seemed less error prone to write a new driver based on the ff-
memless logic, test and deploy it on devices I have access to and once we are 
sure there are no nasty regressions port the rest of the drivers to the new 
API. Given the scope of the changes I am afraid that a "patch" to ff-memless 
would be pretty close to a rewrite anyway.

> Duplicating the module makes reviewing it somewhat difficult since the
> changes are not clearly visible.
> 
> As for the amount of drivers using ff-memless, those are ~all very
> simple (single function call registering a single callback) so it should
> be easy to apply any API conversion if needed.
> And I don't see a real need for you to have access to a rumble joypad -
> that support is already implemented in ff-memless, and other people can
> test that it isn't broken by your changes.
It has been my intention to add handling of rumble effects in a followup 
patch. I wanted to limit the extent of changes I dump in a one massive patch, 
especially when I cannot test the rumble effect on a real hardware.

Michal
