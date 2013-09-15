Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3IOStG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 14:49:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46934 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3IOStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 14:49:04 -0400
Date: Sun, 15 Sep 2013 20:49:02 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, krzysztof.h1@wp.pl,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ES938 support for ES18xx driver
Message-ID: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309142240.47419.linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> ES938 is controlled by MIDI SysEx commands sent through card's MPU401 port.
> 
> The following patch works but has a problem: the midi port cannot be used by
> userspace applications. Opening and closing the rawmidi device on each control
> change would probably work (as long as the port is not used by an application)
> but that just does not seem right. Is there a way to cleanly fix this?

Just to clarify matters:

The story here was a bit split, but then I got it:
you're saying that since ES938 control is via MIDI SysEx,
these operations will occupy MIDI resources at least while controlling ES938
and therefore they're unavailable for userspace.

Don't tell me we'd require a MIDI access multiplexing layer which perhaps does not exist yet...


> (There are two problems: 3D level does not have any effect and alsamixer does
> not display the TLV dB values - but don't know why).

Hmm, I'm rather in the dark here as well - however from my driver experiences
the actually sort-of standardized 3D level control
may have some "weird" deviations (at least when talking AC97 or pseudo-AC97)
such as different bitmask indices or possibly even inverted volume operation
(background: azt3328 is pseudo-AC97, thus it has some deviations).
Sorry for not knowing any more helpful hints...

Hmm, or perhaps ES938_REG_POWER needs some special values configured
to have 3D sound effects powered up, too?
OTOH if this is a simple non-DSP implementation then 3D probably is implemented
via delay lines etc., so perhaps it is so simple that it does not have a
special "enable power" switch after all.

Oh, and BTW, my azt3328.c said:

 *  - (non-bug) "Bass/Treble or 3D settings don't work" - they do get evaluated
 *    if you set PCM output switch to "pre 3D" instead of "post 3D".
 *    If this can't be set, then get a mixer application that Isn't Stupid (tm)
 *    (e.g. kmix, gamix) - unfortunately several are!!

So perhaps ES938 has (perhaps since it might more or less conform to certain
standards specs?) another control for PCM output switch as well
which would need implementing or simply isn't set properly?
(to clarify, we're talking about a switch which would cause output signal
to be grabbed pre or post the 3D manipulation block)


> +		if (snd_es938_init(&chip->es938, card, 0, 0) == 0)
> +			printk("es938 found!\n");

Perhaps we could have a more verbose message here?
That ES938 surely must have some human-readable characteristics...
(hmm, what about "ES938 3D audio effects processor found!"?)
((or "Detected ..."))


> +	/* try to read a register to detect chip presence */
> +	if (snd_es938_read_reg(chip, ES938_REG_MISC, NULL) < 0)
> +		return -ENODEV;

Perhaps that check is not specific enough, i.e. it might be useful
to figure out a more precise check?


Thanks a ton for enhancing the feature set of certain sound cards :))

Andreas Mohr
