Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaAAUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 15:09:59 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:57016 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbaAAUJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 15:09:58 -0500
Date: Wed, 1 Jan 2014 21:08:14 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
Message-ID: <20140101210814.31e3f3a9@armhf>
In-Reply-To: <52C466E1.3030302@metafoo.de>
References: <20131231113138.102044cf@armhf>
	<52C466E1.3030302@metafoo.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jan 2014 20:05:05 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> As Mark also said, this binding definitely leaks way too much internals of
> the current ASoC implementation. In my opinion the way forward for ASoC is
> to stop to distinguish between different types of components. This is on one
> hand CODECS and CPU-DAIs and on the other hand also front-end and beck-end
> DAIs. The first steps in this direction have already been take by the start
> of the component-fication, but its still a long way to go. Exposing those
> concepts via the devicetree will only make it harder to get rid of them
> later. The bindings for a compound card should essentially describe which
> components are involved and how the fabric between and around them looks
> like. If the type of the component is needed in the ASoC implementation it
> should be possible to auto-discover it. Also I think we want to align the
> devicetree bindings with what the media people have been doing[1].

(you forgot the [1] reference)

> Audio and
> video are not that different in this regard and there will also be boards
> where the audio and video fabric will be intermingled  (e.g. like on your
> board with HDMI).

I found a way to discover the DAI link types for my system: when simple
DAPM, the kirkwood CPU DAIs have an ID != 0. For the Cubox, the CPU DAI
of the first link (system playback) has the ID 0, so I can move to DPCM
setting the 'dynamic' and 'no_pcm' flags in the DAI links at snd
platform probe time.

Then, after some extensions of the simple-card, the DT would look like
(not tested yet):

	sound {
		compatible = "simple-audio-card";
		simple-audio-routing =
			"HDMI I2S Playback",	"System Playback",
			"HDMI SPDIF Playback",	"System Playback",
			"SPDIF Playback",	"System Playback",

			"hdmi-out-i2s",		"HDMI I2S Playback",
			"hdmi-out-spdif",	"HDMI SPDIF Playback",
			"spdif-out",		"SPDIF Playback";

		simple-audio-card,cpu@0 {
			link-name = "System audio";	/* extension */
			sound-dai = <&audio1 0>;
			playback;			/* extension */
			format = "i2s";
		};
		simple-audio-card,codec@0 {
			sound-dai-name = "snd-soc-dummy-dai";
		};

							/* multi-links extension */
		simple-audio-card,cpu@1 {
			link-name = "hdmi-i2s";
			platform-name = "snd-soc-dummy"; /* extension */
			sound-dai = <&audio1 1>;
			playback;
		};
		simple-audio-card,codec@1 {
			sound-dai = <&hdmi_codec 0>;
		};

		simple-audio-card,cpu@2 {
			link-name = "hdmi-spdif";
			platform-name = "snd-soc-dummy";
			sound-dai = <&audio1 2>;
			playback;
		};
		simple-audio-card,codec@2 {
			sound-dai = <&hdmi_codec 1>;
		};

		simple-audio-card,cpu@3 {
			link-name = "spdif";
			platform-name = "snd-soc-dummy";
			sound-dai = <&audio1 1>;
			playback;
		};
		simple-audio-card,codec@3 {
			sound-dai = <&spdif_codec>;
		};
	};

May I go to this direction?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
