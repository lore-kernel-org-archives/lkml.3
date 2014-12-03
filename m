Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaLEC2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:28:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456AbaLEC2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:28:54 -0500
Date: Wed, 3 Dec 2014 04:35:22 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141203123521.GB42394@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
 <20141203084319.GA52608@vmdeb7>
 <201412041116.47542@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412041116.47542@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 11:16:47AM +0100, Pali Rohár wrote:
> > > seconds not supported). +  cbRES4, byte1  Maximum
> > > acceptable minutes value (0 if minutes not supported). + 
> > > cbRES4, byte2  Maximum acceptable hours value (0 if hours
> > > not supported). +  cbRES4, byte3  Maxiomum acceptable days
> > > value (0 if days not supported)
> > 
> > Maximum             ^
> > 
> > This interface appears to define all possible values for the
> > timeout between cbRES3[1] and cbRES4[*]. Why is the
> > kbd_timeouts[] array a quirk with fixed values? It seems it
> > could indeed be dynamically determined.
> > 
> 
> BIOS bug (or BIOS feature?). No idea. For invalid value on XPS 
> BIOS just reset keyboard backlight to someting default...


OK good. Let's just get the quirk a comment so it's clear why it's necessary.

...
> 
> > > +
> > > +struct kbd_info {
> > > +	u16 modes;
> > > +	u8 type;
> > > +	u8 triggers;
> > > +	u8 levels;
> > > +	u8 seconds;
> > > +	u8 minutes;
> > > +	u8 hours;
> > > +	u8 days;
> > > +};
> > > +
> > > +
> > > +static u8 kbd_mode_levels[16];
> > > +static int kbd_mode_levels_count;
> > 
> > I'm confused by these. How are they different from
> > kbd_info.levels?
> > 
> 
> There are two interfaces how to set keyboard backlight. Both are 
> documented above. One via kbd mode and one via kbd level. Some 
> laptops (e.g my E6440) support only kbd mode and some (e.g XPS) 
> support only kbd level. So we need to implement both interfaces 
> in kernel if we want to support as more machines as possible.

At the very least, let's get a comment block describing these and the two
interfaces. It wasn't clear to me from the big block of register description
that there were two separate interfaces.

...
> > > +	for (i = 0; i < 16; ++i)
> > 
> > Doesn't this only apply to bits 5-8? Why not just loop through
> > those?
> > 
> 
> Some bits are reserved for future use (now undocumented). So once 
> we know what they means we can adjust global enum/macro and 
> changing this for loop will not be needed. 
> 
> > for (i = KBD_MODE_BIT_TRIGGER_25; i <=
> > KBD_MODE_BIT_TRIGGER_100)
> > 
> > The level_mode_bit check becomes unecessary.
> > 
> 
> I tried to write general code which check all possible modes if 
> they are of type which configure level. And because some of them 
> are undocumented I used this approach, so in future global 
> enum/macro could be extended.

Fair enough. I won't bike shed this.

> 
> > > +		if (kbd_is_level_mode_bit(i) && (BIT(i) &
> > > kbd_info.modes))
> > > +			kbd_mode_levels[1+kbd_mode_levels_count++] = i;
> > 
> > One space around operators like + please.
> > 
> > What is kbd_mode_levels[0] reserved for? The current level?
> > Isn't that what kbd_state.level is for?
> > 
> 
> Reserved for off mode -- keyboard backlight turned off.
> 
> kbd level is for laptops which support kbd level. kbd mode is for 
> laptops which support setting level via kbd mode.
> 
> > > +
> > > +	if (kbd_mode_levels_count > 0) {
> > > +		for (i = 0; i < 16; ++i) {
> > 
> > If 0-4 don't apply here, why loop through them? Should we just
> > set levels[0] to 0 if it isn't one of 5-8?
> > 
> 
> We know that BIOSes are buggy, so I can imagine that off mode 
> (which is enum = 0) does not have to be supported... So for 
> kbd_mode_levels[0] we set first supported mode (if off is not 
> supported we will choose something other, so kernel code will not 
> call unsupported mode).

This sort of defensive programming is good, but it does need a comment.

/*
 * Find the first supported mode and assign to kbd_mode_levels[0].
 * This should be 0 (off), but we cannot depend on the BIOS to
 * support 0.
 */

> 
> > If bits 9-16 are reserved, it seems it would be best to avoid
> > checking for them as they might return a false positive, and
> > we'd be setting kbd_mode_levels to an undefined value.

And I think you've addressed this comment above.

So in general, whenever you're working around bugs in firmware or hardware or
doing anything that might not be obvious to someone reviewing your code without
all the context you've built up, it's important to add a comment explaining why.


-- 
Darren Hart
Intel Open Source Technology Center
