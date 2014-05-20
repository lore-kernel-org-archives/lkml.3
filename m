Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaETU6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:58:12 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:33060 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaETU6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:58:11 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: simon@mungewell.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
Date: Tue, 20 May 2014 22:58:05 +0200
Message-ID: <6970969.ej8OFzkVkO@sigyn>
User-Agent: KMail/4.13.1 (Linux/3.14.1-1-my-rd; KDE/4.13.1; x86_64; ; )
In-Reply-To: <865ad8dbc7ae0d13c045bd2a85cff2e2.squirrel@mungewell.org>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net> <2965006.XKYHWj9YzJ@sigyn> <865ad8dbc7ae0d13c045bd2a85cff2e2.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of May 2014 16:16:12 simon@mungewell.org wrote:
> > To bring this to a conclusion we could go from, would this be an
> > acceptable
> > solution?
> > 
> > - Have the HW-specific driver talk directly to ff-core and reimplement
> > upload(),
> > play(), etc.
> > - Rewrite "ff-memless-next" so that it is not a self-contained module but
> > a
> > library of functions.
> > 
> > - Have the driver either:
> >   - Upload an effect to a device directly if the device can fully manage
> > 
> > the
> > effect by itself.
> > 
> >   - Use provided timing functions to know when an effect should start,
> > 
> > stop,
> > restart etc...
> > 
> >   - Use provided timing AND processing functions to combine effects that
> > 
> > can be
> > combined into one, calculate periodic waveforms etc?
> > 
> > I have no problem with throwing my current approach away but before I
> > start working on a new one I'd like to know which way to go...
> 
> Hi all,
> If the driver itself (hid-logitech, via hid-lg4ff for example) is more
> involved in the creation/timing/management of the effects, does this mean
> that we end up with code duplicated in lots of places?

Hopefully not. I tried to work out some scheme how this would work in my head 
today and the code duplication among other drivers should be minimal. 
Basically an equivalent of "play_effects()" - implemented in the HW-specific 
driver - would by called as needed. Such a function would then use provided 
helper functions to process combinable effects and check if any uncombinable 
effects changed state. A proper rate limiting will fit into this scheme nicely 
as well.
The biggest advantage of this design is that the HW-specific driver will be 
able to either handle an effect all by itself or use the provided "helper" 
infrastructure.

In retrospect I've got agree with Dmitry that the current handling of 
(semi)memless devices is not very flexible and therefore potentially 
problematic. It'll require some extra work but we don't have to invent 
anything entirely new here, we can just rearrange what we've already done in 
MLNX and package it into a library.

> Also, does this mean that the 'old' ff-memless system would remain in
> kernel? If not, who will reworking each driver?

I suppose that the maintainers would want us to move all FF drivers to this 
architecture. If we get it right, it shouldn't require a terrible amount of 
work to port the other drivers.

> Regarding the question of emulated vs. real effects, can we extend the API
> so that applications can know which effects are really supported, and
> enable/disable emulation somehow?

I suppose that a few extra flags (FF_PERIODIC_EMULATED etc.) defined in 
"uapi/linux/input.h" should suffice.

Michal
