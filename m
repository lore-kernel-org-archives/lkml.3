Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3IOU0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 16:26:38 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:47504 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3IOU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 16:26:35 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: [RFC PATCH] ES938 support for ES18xx driver
Date: Sun, 15 Sep 2013 22:25:45 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org, krzysztof.h1@wp.pl,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
In-Reply-To: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309152225.46581.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 September 2013 20:49:02 Andreas Mohr wrote:
> Hi,
>
> > ES938 is controlled by MIDI SysEx commands sent through card's MPU401
> > port.
> >
> > The following patch works but has a problem: the midi port cannot be used
> > by userspace applications. Opening and closing the rawmidi device on each
> > control change would probably work (as long as the port is not used by an
> > application) but that just does not seem right. Is there a way to cleanly
> > fix this?
>
> Just to clarify matters:
>
> The story here was a bit split, but then I got it:
> you're saying that since ES938 control is via MIDI SysEx,
> these operations will occupy MIDI resources at least while controlling
> ES938 and therefore they're unavailable for userspace.
>
> Don't tell me we'd require a MIDI access multiplexing layer which perhaps
> does not exist yet...

Probably some hack that would allow the driver to send MIDI data behind 
everyone's back would be enough. Receiving is not needed (because the read 
register command is used only once for device detection). The 
SNDRV_RAWMIDI_LFLG_APPEND thing looks like that but does not seem to work.

And another bad thing I forgot to mention before: the driver cannot be 
unloaded because the MIDI device is open (circular dependency between 
snd-es18xx and snd-es938).

Maybe rawmidi_open_priv() would work, only if it was exported (and not _priv).

> > (There are two problems: 3D level does not have any effect and alsamixer
> > does not display the TLV dB values - but don't know why).
>
> Hmm, I'm rather in the dark here as well - however from my driver
> experiences the actually sort-of standardized 3D level control
> may have some "weird" deviations (at least when talking AC97 or
> pseudo-AC97) such as different bitmask indices or possibly even inverted
> volume operation (background: azt3328 is pseudo-AC97, thus it has some
> deviations). Sorry for not knowing any more helpful hints...
>
> Hmm, or perhaps ES938_REG_POWER needs some special values configured
> to have 3D sound effects powered up, too?
> OTOH if this is a simple non-DSP implementation then 3D probably is
> implemented via delay lines etc., so perhaps it is so simple that it does
> not have a special "enable power" switch after all.
>
> Oh, and BTW, my azt3328.c said:
>
> *  - (non-bug) "Bass/Treble or 3D settings don't work" - they do get
> evaluated 
> *    if you set PCM output switch to "pre 3D" instead of "post 3D".
> *    If this can't be set, then get a mixer application that Isn't Stupid
> (tm) 
> *    (e.g. kmix, gamix) - unfortunately several are!!

BTW. I've got an AZT3328 card and it works fine with your driver. Thanks for 
it.
I'm thinking about doing some reverse-engineering of thunderbird-based sound 
cards (VLSI Thunderbird - Aztech PCI 368-DSP, Thunderbird Avenger - Philips 
Acoustic/Seismic/Rhythmic Edge).

> So perhaps ES938 has (perhaps since it might more or less conform to
> certain standards specs?) another control for PCM output switch as well
> which would need implementing or simply isn't set properly?
> (to clarify, we're talking about a switch which would cause output signal
> to be grabbed pre or post the 3D manipulation block)

The good thing is that there's a datasheet available for ES938 - e.g. at 
http://www.datasheetarchive.com/ES938-datasheet.html

The 3D switch works but the level doesn't. Maybe I should use only the 3 
specific level values from the datasheet and not a variable scale. Or just 
remove the level control completely as Windows driver does (there's only a 3D 
switch).

> > +		if (snd_es938_init(&chip->es938, card, 0, 0) == 0)
> > +			printk("es938 found!\n");
>
> Perhaps we could have a more verbose message here?
> That ES938 surely must have some human-readable characteristics...
> (hmm, what about "ES938 3D audio effects processor found!"?)
> ((or "Detected ..."))

Yes, that's wrong - it's only for testing purposes. There should probably be 
no message at all as the es18xx driver itself does not display anything if 
everything is OK.

> > +	/* try to read a register to detect chip presence */
> > +	if (snd_es938_read_reg(chip, ES938_REG_MISC, NULL) < 0)
> > +		return -ENODEV;
>
> Perhaps that check is not specific enough, i.e. it might be useful
> to figure out a more precise check?

snd_es938_read_reg() checks that the returned data match the format used by 
ES938. Maybe we can reread all the register values back after writing to be 
sure.

-- 
Ondrej Zary
