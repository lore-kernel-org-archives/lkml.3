Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3HCWXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:23:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3HCWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:23:53 -0400
Date: Sat, 3 Aug 2013 23:23:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/4] ASoc: kirkwood: merge kirkwood-i2c and
	kirkwood-dma
Message-ID: <20130803222332.GE23006@n2100.arm.linux.org.uk>
References: <20130731081806.244752d4@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731081806.244752d4@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:18:06AM +0200, Jean-Francois Moine wrote:
> To avoid the declaration of a 'kirkwood-pcm-audio' device in the DT,
> this patch merges the kirkwood-i2c and kirkwood-dma drivers into one
> module associated with 'kirkwood-i2s'. 

I suggest holding off on this stuff at the moment.  I think Mark and Liam
(who now have a whole raft of emails from me today) have some work to do
to fix ASoC to work how they're saying it should work, because to me
ASoC seems to contradict what they're telling me.  To put it another way,
it must be buggy.

The DAPM stuff seems to be the worst thing since mouldy bread.  I'm
chasing what seems to be multiple bugs through this stuff, and many of
them are not particularly nice.

For example - we register multiple copies of DAPM widgets for the same
set of declarations if both a CPU DAI and a platform share the same
struct device, and thereby end up overwriting some pointers in the DAI
structure.  It seems that CPU DAIs themselves aren't supposed to have
DAPM widgets, but the core creates some... but there's no explicit
cleanup of them unlike the other DAPMs, and there's no debugfs for them.

The bias levels are stuck at off/standby all the time, which makes any
kind of PM with spdif-dit impossible - or even any routing between
stream input and output.

Basically, I'm tearing my hair out today looking at this stuff and getting
nowhere fast - all I'm doing is finding more and more problems.

For example, where a codec has no input/output widgets declared, it used
to be powered up automatically by ASoC as a matter of course.  Things
like UDA134x and other things.  Things like spdif-dit.  That "mysteriously"
stopped happening.

	ASoC: dapm: Treat DAI widgets like AIF widgets for power

seems to be the cause, this results in such setups having zero connected
inputs/outputs reported, which causes them to remain powered down - because
what used to happen before was the DAI links would report their powered
state depending on whether they were active, and they are set active
in soc_dapm_stream_event().

Now, when playback widget for the Codec and CPU DAIs get marked as active.
The playback widget is created as a snd_soc_dapm_dai_in.  It's power
check function is set to dapm_dac_check_power.  Since this widget is
active, it checks for connected outputs via is_connected_output_ep().

We drop through to the second switch statement (why do we have two there?
They're both switching on the same damned variable and its not like a
widget can change its ID.)  This is where the different behaviour has
appeared - when these were just a simple snd_soc_dapm_dai, we used to
just do the snd_soc_dapm_suspend_check() here, but we don't anymore.
This is a snd_soc_dapm_dai_in type of widget, so we fall through this
switch statement now and start searching the paths.

As these codecs have no paths, this ultimately ends up returning no
connections.  Hence why these codecs with no DAPM widgets declared but
have PM support via the bias level stuff have stopped working.

Now, about the spdif-dit, if we're going to have to add "pin" widgets
to it, what the output of a SPDIF in terms of DAPM widgets?  At a guess,
it's a "codec pin" despite there being no codec and no "pin" on that
codec in reality, and that "pin" is always active.

With that "fixed" (rather, altered to a state where it behaves the
same way as it used to before the above commit) if I set up a DAPM route
between the CPU DAI playback stream, an AIF (for spdif output) and the
spdif-dit playback stream, I see the playback streams marked active and
powered up, but the AIF stream remains powered down:

spdif-dit/dapm/Playback:Playback: On  in 1 out 1
spdif-dit/dapm/Playback: stream Playback active
spdif-dit/dapm/Playback: in  "static" "spdif-playback"
spdif-dit/dapm/bias_level:On

kirkwood-audio.1/dapm/spdif-playback:spdif-playback: Off  in 1 out 0
kirkwood-audio.1/dapm/spdif-playback: in  "static" "dma-playback"
kirkwood-audio.1/dapm/spdif-playback: out "static" "Playback"

kirkwood-audio.1/dapm/dma-playback:dma-playback: On  in 1 out 1
kirkwood-audio.1/dapm/dma-playback: stream dma-playback active
kirkwood-audio.1/dapm/dma-playback: out "static" "spdif-playback"
kirkwood-audio.1/dapm/dma-playback: out "static" "i2s-playback"

It looks to me like the DAPM stuff is - in one plain and simple word -
buggered.

I've no idea what the right fixes are in this area.  It needs someone
like Mark or Liam who supposedly understand this to spend time checking
that it actually operates as they _think_ it should operate, because
at the moment it plainly doesn't.
