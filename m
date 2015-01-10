Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbbAJPox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 10:44:53 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:3707 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbbAJPov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 10:44:51 -0500
Date: Sat, 10 Jan 2015 16:47:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: [alsa-devel] [PATCH v9 1/4] drm/i2c: tda998x: Add DT support
 for audio
Message-ID: <20150110164711.637892fc@armhf>
In-Reply-To: <20150109200127.GD12302@n2100.arm.linux.org.uk>
References: <54AE99F5.1010404@ti.com>
 <20150108174257.557f7ea5@armhf>
 <54AFA9B0.6040405@ti.com>
 <20150109123036.4bc4bbf6@armhf>
 <20150109114529.GH12302@n2100.arm.linux.org.uk>
 <20150109135401.5b270d46@armhf>
 <20150109130725.GN12302@n2100.arm.linux.org.uk>
 <54AFDE8D.3000504@arm.com>
 <20150109145741.GP12302@n2100.arm.linux.org.uk>
 <20150109183857.53d701a4@armhf>
 <20150109200127.GD12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 20:01:27 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > I proposed:
> > 
> > 	audio-ports = <0x04>, <0x03>;
> > 	audio-port-names = "spdif", "i2s";
> > 
> > Do you better like:
> > 
> > 	audio-spdif-port = <0x04>;
> > 	audio-i2s-port = <0x03>;  
> 
> Neither; we know that there are TDA998x devices which allow SPDIF to be
> input via two separate pins, but only one to be active at any one time.
> Given that the hardware is flexible in that regard, a binding which
> artificially restricts that flexibility would seem unwise.
> 
> If we were to come across a setup which did route two SPDIF streams to
> the TDA998x, and we had to make the decision at run time which to route
> to the HDMI sink, we'd have to rework the binding, and we'd have to
> support the new binding and the old binding in the driver.
> 
> Can you please look at Documentation/devicetree/bindings/graph.txt ?
> 
> I think we may be able to use something like this:
> 
> tda998x: hdmi-encoder {
> 	compatible = "nxp,tda998x";
> 	reg = <0x70>;
> 	video-ports = <0x234501>;
> 
> 	port {
> 		tda998x_video: endpoint {
> 			remote-endpoint = <&lcd0_rgb>;
> 		};
> 	};
> 
> 	port {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		tda998x_spdif0: endpoint@02 {
> 			reg = <0x02>;
> 			remote-endpoint = <&spdif0>;
> 		};
> 
> 		tda998x_spdif1: endpoint@04 {
> 			reg = <0x04>;
> 			remote-endpoint = <&spdif0>;
> 		};
> 
> 		tda998x_i2s: endpoint@03 {
> 			reg = <0x03>;
> 			remote-endpoint = <&i2s>;
> 		};
> 	};
> };
> 
> I'm adding Philipp Zabel for comment.  The issue I see with this is that
> we have two ports here which are not mutually exclusive, and it's not
> obvious how they are dealt with.

Very interesting idea!

That's a detail, but I don't fully agree your endpoint description:

- pin description
	AP1 is the first S/PDIF input - ok
	AP2 is the second S/PDIF input - ok
	then, the I2S input may go only to AP3 or AP4.

- source input nodes
	You declare the same external S/PDIF source on AP1 and AP2.
	I would have better seen a kirkwood-like audio device as one of
	the S/PDIF input, say the second one.

To complexify a bit, I also connect the spdif wire of the kirkwood-like
device to a S/PDIF optical output ;)

spdif_in -------------+
                      v
       + i2s -----> tda998x ---> HDMI
audio1 |              ^
       + spdif -------+--------> spdif_out


Here are the modified ports of
- the HDMI transmitter (I removed the #xxx_cells):

	port@0 { // AP 1
		tda998x_spdif0: endpoint@02 {
			reg = <0x02>;
			remote-endpoint = <&spdif_in_port>;
		};
	};
	port@1 { //AP 2
		tda998x_spdif1: endpoint@04 {
			reg = <0x04>;
			remote-endpoint = <&audio1_spdif0>;
		};
	};
	port@2 { //AP 3
		tda998x_i2s: endpoint@08 {
			reg = <0x09>;
			remote-endpoint = <&audio1_i2s>;
		};
	};

- the (internal) audio device (audio1):

	port@0 {
		audio1_spdif0: endpoint@0 {
			reg = 0;
			remote-endpoint = <&tda998x_spdif1>;
		};
		audio1_spdif1: endpoint@1 {
			reg = 0;
			remote-endpoint = <&spdif_out_port>;
		};
	};
	port@1 {
		audio1_i2s: endpoint@1 {
			reg = 1;
			remote-endpoint = <&tda998x_i2s>;
		};
	};

- and the S/PDIF external input (spdif_in):

	port {
		spdif_in_port: endpoint@0 {
			reg = 0;
			remote-endpoint = <&tda998x_spdif0>;
		};
	};

- and the S/PDIF external output (spdif_out):

	port {
		spdif_out_port: endpoint@0 {
			reg = 0;
			remote-endpoint = <&audio1_spdif1>;
		};
	};

All the hardware is described. There is nothing more to add in the DT.

Especially, there is no 'simple-card' which is pure software and rather
Linux specific.

And, now, from this DT description, ASoC expects a sound card to be
built.

It seems that this creation should be done in the same way the video
cards are built, i.e. from the source devices, i.e. the kirkwood-like
device, and also from the spdif_in (which could be some other internal
audio device outputting s/pdif instead of a simple S/PDIF input
connector)! Is there one or two cards, and if 2 cards, how do they
share the tda998x?

Well, I will have a look at how to get audio out of my machine with
these new DT definitions (hopefully, there is only one audio source!).

Mark, you may forget about my other patch adding multi-codecs in the
simple-card...

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
