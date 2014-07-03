Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbaGCP1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:27:22 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:54932 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbaGCP1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:27:20 -0400
Date: Thu, 3 Jul 2014 17:29:09 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140703172909.60caf2c7@armhf>
In-Reply-To: <20140703134346.GW32514@n2100.arm.linux.org.uk>
References: <20140702183841.7c964832@armhf>
	<20140702165628.GO20799@lunn.ch>
	<20140702195154.47d6f6b4@armhf>
	<20140702194252.GN410@sirena.org.uk>
	<20140703074959.7c489912@armhf>
	<20140703104432.GV410@sirena.org.uk>
	<20140703133406.2d3e3a1d@armhf>
	<20140703115924.GY410@sirena.org.uk>
	<20140703152826.103c9d6c@armhf>
	<20140703134346.GW32514@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 14:43:46 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > But, this means that there will be a lot of errors when DPCM will be
> > used, because, in most cases for the Cubox (kirkwood audio + tda998x),
> > both ways I2S and S/PDIF will be activated at the same time for a
> > single stream (you may note that the routes from the second input
> > cannot be blocked by the CODEC after it received the first input,
> > because these routes have already been computed).  
> 
> This is /very/ easy to solve on the Cubox, if only you would listen
> to me - I've stated many times that I2S should not be used there.
> 
> Just because the hardware is wired up with both the SPDIF connected
> and the I2S connected, it does *not* mean that we have to wire them
> both up in software.
> 
> Indeed, *everything* works with just SPDIF.  The same is not true of
> I2S.  So, what we do for the Cubox is we just wire up SPDIF in software
> and be done with it - we then get a fully functional setup.  So using
> I2S on the Cubox is mostly pointless - unless you wish to use I2S for
> testing purposes.
> 
> Let me also point out that adding your changes - including the addition
> of this codec patch - explicitly deny the possibility of:
> * using compressed audio streams via the optical SPDIF out socket
> * using compressed audio streams over HDMI
> * using audio rates and formats not supported by the attached HDMI
>   device via the optical SPDIF socket.
> 
> These are serious issues which thus far you have so far failed to
> respond on.  People who use the Cubox as a media platform rather
> than (presumably) just a music jukebox want things like compressed
> audio out and SPDIF out to work.
> 
> Look, one reason to use the optical socket is because you want to
> push out a stream at (eg) 96kHz to your audio system, but your TV
> doesn't support it.  With your approach, you explicitly block that
> because the TDA998x codec assocated with the Kirkwood CPU DAI
> refuses to allow that sample rate.  Fine, if the attached device
> does not support that rate, then the right thing to do may be to
> disable audio transmission over HDMI, but with the Cubox hardware,
> limiting the sample rates is totally the wrong solution.

I think that you did not look at my code.

Both S/PDIF and I2S work with the TDA998x. It is a choice of the audio
subsystem to do this choice, not Russell King. If you want only S/PDIF,
it is easy: just declare the S/PDIF DAIs, on both sides, source
(kirkwood) and sinks (tda998x and S/PDIF):

	dai-link@1 {		/* S/PDIF - HDMI */
		cpu {
			sound-dai = <&audio1 1>;
		};
		,codec {
			sound-dai = <&hdmi 1>;
		};
	};

	dai-link@2 {		/* S/PDIF - S/PDIF */
		cpu {
			sound-dai = <&audio1 1>;
		};
		codec {
			sound-dai = <&spdif_codec>;
		};
	};

When DPCM will handle the formats and rates, the audio subsystem will
find by itself if such stream will go to the HDMI only or to the S/PDIF
only or to both. The kirwood audio driver will work as it is and the tda998x
CODEC will work as it is. There will be no need to change these drivers.
All we need actually is some more code in DPCM or multi-codec or
whatever mechanism which will route the stream according to the rates
and formats.

Actually, as DPCM does not work, the user has to choose which PCM to
use, otherwise, the application does a format and rate translation.

Anyway, if you want S/PDIF output with the actual kernel (3.16-rc3), in
the DT, put:

	spdif_codec: spdif-codec {
		compatible = "linux,spdif-dit";
		#sound-dai-cells = <0>;
	};

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";
		simple-audio-card,format = "i2s";

		simple-audio-card,dai-link {		/* S/PDIF - S/PDIF */
			simple-audio-card,cpu {
				sound-dai = <&audio1 1>;
			};
			simple-audio-card,codec {
				sound-dai = <&spdif_codec>;
			};
		};
	};

&audio1 {
	status = "okay";
	clocks = <&gate_clk 13>, <&si5351 2>;
	clock-names = "internal", "extclk";
	pinctrl-0 = <&pmx_audio1_i2s1_spdifo &pmx_audio1_extclk>;
	pinctrl-names = "default";
	#sound-dai-cells = <1>;
};

and the sound should get out of your S/PDIF optical connector.

Eventually, the TDA998x is used in other machines. Are you sure that
the audio controllers of all these machines have a S/PDIF output
connected to the S/PDIF input of the tda998x?

The tda998x CODEC I propose works in all configurations.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
