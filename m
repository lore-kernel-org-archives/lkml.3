Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaABJ1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:27:47 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41665 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaABJ1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:27:44 -0500
Date: Thu, 2 Jan 2014 10:26:47 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
Message-ID: <20140102102647.6efec89d@armhf>
In-Reply-To: <52C4766B.8080000@metafoo.de>
References: <20131231113138.102044cf@armhf>
	<52C466E1.3030302@metafoo.de>
	<20140101210814.31e3f3a9@armhf>
	<52C4766B.8080000@metafoo.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jan 2014 21:11:23 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> On 01/01/2014 09:08 PM, Jean-Francois Moine wrote:
> > On Wed, 01 Jan 2014 20:05:05 +0100
> > Lars-Peter Clausen <lars@metafoo.de> wrote:
> > 
> >> As Mark also said, this binding definitely leaks way too much internals of
> >> the current ASoC implementation. In my opinion the way forward for ASoC is
> >> to stop to distinguish between different types of components. This is on one
> >> hand CODECS and CPU-DAIs and on the other hand also front-end and beck-end
> >> DAIs. The first steps in this direction have already been take by the start
> >> of the component-fication, but its still a long way to go. Exposing those
> >> concepts via the devicetree will only make it harder to get rid of them
> >> later. The bindings for a compound card should essentially describe which
> >> components are involved and how the fabric between and around them looks
> >> like. If the type of the component is needed in the ASoC implementation it
> >> should be possible to auto-discover it. Also I think we want to align the
> >> devicetree bindings with what the media people have been doing[1].
> > 
> > (you forgot the [1] reference)
> 
> http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/media/video-interfaces.txt

I see the idea. So here is a proposal of DT for the Cubox (audio + video)
which should work without too many difficulties.

/* video / audio transmitter */

	tda998x: hdmi-encoder {
		compatible = "nxp,tda998x";
		...

		/* video */
		port@0 {
			tda998x_0: endpoint {
				reg = <0x230145>;
				remote-endpoint = <&lcd0_0>;
			};
		};

		/* audio */
		port@1 {
			hdmi_i2s_audio: endpoint@0 {
				reg = <0x03>;
				remote-endpoint = <&audio_hdmi_i2s>;
			};
			hdmi_spdif_audio: endpoint@1 {
				reg = <0x04>;
				remote-endpoint = <&audio_hdmi_spdif>;
			};
		};
	};

	toslink: spdif {
		compatible = "linux,spdif-dit";
		port {
			spdif_audio: endpoint {
				remote-endpoint = <&audio_spdif>;
			};
		};
	};

/* video */

	lcd0: video-controller {
		compatible = "marvell,dove-lcd";
		...
		port {
			lcd0_0: endpoint {
				remote-endpoint = <&tda998x_0>;
			};
		};
	};

	video {
		compatible = "media-video";
		video-controller = <&lcd0>;
	};

/* audio */

	audio1: audio-controller {
		compatible = "marvell,dove-audio";
		...
		port@0 {
			audio_hdmi_i2s: endpoint {
				remote-endpoint = <&hdmi_i2s_audio>;
			};
		};

		port@1 {
			audio_hdmi_spdif: endpoint@0 {
				remote-endpoint = <&hdmi_spdif_audio>;
			};
			audio_spdif: endpoint@1 {
				remote-endpoint = <&spdif_audio>;
			};
		};
	};

	sound {
		compatible = "media-audio";
		audio-controller = <&audio1>;
	};

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
