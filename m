Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3HaLbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:31:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51431 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3HaLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:31:34 -0400
Date: Sat, 31 Aug 2013 12:24:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130831112430.GD6617@n2100.arm.linux.org.uk>
References: <20130828113521.35c53365@armhf> <521DCD80.9010105@gmail.com> <20130831125128.0e3a23c7@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831125128.0e3a23c7@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 12:51:28PM +0200, Jean-Francois Moine wrote:
> Hi Sebastian and Russell,
> 
> I tried it on my Cubox (<&si5351 2>), and I have problems with HDMI
> output and some audio streams like webradios with sample rates 32 or
> 22.05 kHz.

Some TVs will only accept certain sample rates - my (brand new) TV has
an audio block in the EDID containing this (starting at byte 0x92 -
note - I don't think it has to start at that offset):

	23 09 07 01 

0x23 = audio block code (7:5 = 1, 4:0 = size)
0x09 = 7:3 format code = 1 (PCM), 2:0 number of channels = 2
0x07 = 48kHz, 44.1kHz and 32kHz supported
0x01 = 16-bit

There is no bit to indicate 22.05kHz support - 32kHz is the lowest which
the EDID block can report.

Also, this new TV seems to be more fussy than the old - it remains silent
with 48kHz playback, but works with 44.1kHz.  I've tried tweaking a fair
number of the registers both in the NXP and Dove, including the SPDIF
channel status, and nothing seems to make any difference.  Given that
the old TV just converted HDMI to analogue - yes, really - and this one
doesn't, I suspect it has stricter checking of the HDMI data.

However, even with the EDID reporting a restricted set of sample rates,
this does not mean that we should restrict ALSAs selection: remember,
the SPDIF is also routed out through the TOSlink output, which can
(undetectably, since it is output only) support more sample rates than
the HDMI connected device.

In the longer term, we probably want to eventually connect the NXP into
the ASoC DPCM code, so that it can be informed about the properties of
the audio being fed to it.  It can then compare the capabililties of the
connected device and disable HDMI audio output if they're not compatible.
That requires working DPCM first though.

> According to the Dove specification, the audio controller works with
> the samples rates 44.1, 48 and 96 kHz, so, I don't see the usage of the
> external clock, except when using the two audio controllers with
> different sample rates.

I don't see what the Dove specification has to do with that statement:
what the Dove spec says is that if you use just the internal DCO, then
only 44.1kHz, 48kHz and 96kHz are supported (with some trimming of that.)
However, the use of an external clock allows further rates to be supported.
If you have an external clock, there is no requirement to use the DCO for
those sample rates - you can if you wish, or you can use the external clock.

The mainline driver implements the use of the DCO for the standard 44.1,
48 and 96kHz rates, otherwise it uses the external clock if present.  This
is entirely conformant with the Dove spec.

If you attempt to use both audio controllers on the Cubox with different
sample rates which aren't supported by the DCO, then they will fight over
the input clock rate.  That's a limitation of the hardware, and there's
no real solution to that.  As the Cubox does not wire up the first audio
controller, it should not be enabled in DT.  If a board does use both, and
they both use the external clock input, then that's the time that this
needs to be solved.

We have more than enough problems to sort out without inventing new
problems.

> But, BTW, as the kirkwood-i2 driver is written, this last case does not
> work: for 44.1, 48 and 96 kHz, the external clock is never used and
> there is only one DCO.

This doesn't make sense.  "this last case" - what "case" are you referring
to?  "there is only one DCO" ?  Yes, there is only one DCO, what is its
relevance to the statement you're making?  And yes, in mainline we
currently use the DCO for the standard 44.1, 48 and 96kHz sample rates.
That's fine.  Confused.
