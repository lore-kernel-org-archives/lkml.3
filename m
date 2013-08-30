Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3H3PKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:10:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51285 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3H3PKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:10:10 -0400
Date: Fri, 30 Aug 2013 16:08:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130830150841.GY6617@n2100.arm.linux.org.uk>
References: <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate> <521DE2B3.9050508@gmail.com> <20130828135827.2307c89e@skate> <521DEA20.8020103@gmail.com> <20130829120704.410ad309@armhf> <20130829101303.GR6617@n2100.arm.linux.org.uk> <521F2A03.8000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F2A03.8000905@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 01:01:23PM +0200, Sebastian Hesselbarth wrote:
> Taking the sound node above:
>
> sound {
> 	compatible = "whatever-audio";
> 	...
> 	audio-codec = <&rt1234 1>, <&spdif 0>;
> 	audio-codec-names = "i2s", "spdifo";
> 	...
> };
>
> Each audio-codec phandle with arg links to one specific "port" at some
> "codec". The audio-codec-names property allows the ASoC driver to
> determine the local "ports" where the above codecs are connected.
> The dummy codecs are ASoC specific and must be added by the driver.

I think it's slightly more complicated than that.  Here's what needs to
be setup with DPCM - when it eventually works:

1. Two DAI links need to be setup:
1a:             .name = "S/PDIF1",
                .stream_name = "Audio Playback",
                .platform_name = "mvebu-audio.1",
                .cpu_dai_name = "mvebu-audio.1",
                .codec_name = "snd-soc-dummy",
                .codec_dai_name = "snd-soc-dummy-dai",
                .dynamic = 1,

1b:             .name = "Codec",
                .stream_name = "IEC958 Playback",
                .cpu_dai_name = "snd-soc-dummy-dai",
                .platform_name = "snd-soc-dummy",
                .no_pcm = 1,
                .codec_dai_name = "dit-hifi",
                .codec_name = "spdif-dit",

   This separates the CPU DAI from the codec DAI - the important thing
   seems to be that the first entry (which connects the CPU DAI to the
   dummy codec) breaks the automatic DAPM routes between the CPU streams
   and the codec streams.

2. DAPM routes need to be created between the CPU DAI and Codec DAIs to
   wire the back together:

	static const struct snd_soc_dapm_route routes[] = {
	        { "spdif-Playback", NULL, "spdifdo" },
	};

"spdif-Playback" is the stream name in the spdif-dit codec (I had to change
the name from merely "Playback" as otherwise the route gets bound to the
dummy codec instead.)  "spdifdo" is the audio interface widget name in the
CPU DAI, which is connected to the CPU DAI playback stream.

So, if we wanted two codecs, one spdif and one i2s, we would need something
like this:

DAI links:
                .name = "CPU",
                .stream_name = "Audio Playback",
                .platform_name = "mvebu-audio.1",
                .cpu_dai_name = "mvebu-audio.1",
                .codec_name = "snd-soc-dummy",
                .codec_dai_name = "snd-soc-dummy-dai",
                .dynamic = 1,

                .name = "I2S",
                .stream_name = "PCM Playback",
                .cpu_dai_name = "snd-soc-dummy-dai",
                .platform_name = "snd-soc-dummy",
                .no_pcm = 1,
                .codec_dai_name = "i2s-codec-dai-name",
                .codec_name = "i2s-codec-name",
                .ops = &..._ops,

                .name = "SPDIF",
                .stream_name = "IEC958 Playback",
                .cpu_dai_name = "snd-soc-dummy-dai",
                .platform_name = "snd-soc-dummy",
                .no_pcm = 1,
                .codec_dai_name = "dit-hifi",
                .codec_name = "spdif-dit",

with routes like this:

static const struct snd_soc_dapm_route routes[] = {
	{ "i2sdi", NULL, "i2s-codec-Capture" },
	{ "i2s-codec-Playback", NULL, "i2sdo" },
        { "spdif-Playback", NULL, "spdifdo" },
};

If we were to add support for SPDIF recording mode, then we'd need to add
an additional route for that.

The pitfalls here are:
1. if we are going to refer to codec streams in DAPM routes, we need all
   codec implementations to have unique names, or some way for DAPM routes
   to refer to specific codec streams.

2. being able to effectively represent this in DT.

I think we need a flag in DT to indicate a DPCM configuration, which would
trigger the creation of the first DAI link.  The second and (optionally)
third can be generated from knowing the codec DAI name and the codec
name.  I think we also need a way to specify arbitary DAPM routes in DT
as well.
