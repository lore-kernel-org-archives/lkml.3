Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbAIUBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:01:45 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56556 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750971AbbAIUBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:01:43 -0500
Date: Fri, 9 Jan 2015 20:01:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109200127.GD12302@n2100.arm.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109183857.53d701a4@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 06:38:57PM +0100, Jean-Francois Moine wrote:
> On Fri, 9 Jan 2015 14:57:41 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > What we do know is that there is a fixed mapping between AP pins and I2S
> > channels (which are not PCM channels), but as you point out, we don't
> > have any documentation which describes how the I2S channels (each with
> > their own L+R words) map to the PCM channels - and we don't know whether
> > the CA_I2S bits in that same register in the TDA998x have an effect on
> > this.
> 
> HDMI talks about LPCM (Linear PCM) channels and TDA19988 talks about
> I2S-bus (stereo) channels. For me, it seems obvious that these channels
> are correlated:
> - LPCM-0 is I2S-bus-0-left (FL)
> - LPCM-1 is I2S-bus-0-right (FR)
> - LPCM-2 is I2S-bus-1-left (LFE)
> - LPCM-3 is I2S-bus-1-right (FC)
> ...

That's certainly a reasonable possibility, but we don't have a way to
confirm it as I don't think anyone has access to a setup which uses
I2S bus 1.

> > Does anyone have a TDA998x setup which has an I2S source connected to
> > the TDA998x I2S channel 1, and who has a HDMI sink which will accept
> > the LFE/FC channels?  If so, producing a description of how the CA_I2S
> > bits and enabling I2S input pins influences the mapping would be a good
> > idea.
> 
> I could not find a description of these CA_I2S bits.

I'm willing to bet that when the audio is configured for layout 1, CA_I2S
affects the mapping of individual I2S channels (what I call "words") to
the HDMI channels.

> > If we don't have that, I'd recommend splitting the DT property into
> > "audio inputs for I2S" and "audio input for SPDIF" (only one can be
> > active with SPDIF).
> > 
> > If we want to support more than one SPDIF input (which must be mutually
> > exclusive) I'd recommend to look at the OF graph stuff we use in DRM -
> > one port for each "mode" - eg, I2S, SPDIF in on AP2, SPDIF in on AP3.
> > Each port node can specify the AP pins which should be enabled.
> 
> I agree. There are one S/PDIF port and one I2S port.
> 
> So, which syntax?
> 
> I proposed:
> 
> 	audio-ports = <0x04>, <0x03>;
> 	audio-port-names = "spdif", "i2s";
> 
> Do you better like:
> 
> 	audio-spdif-port = <0x04>;
> 	audio-i2s-port = <0x03>;

Neither; we know that there are TDA998x devices which allow SPDIF to be
input via two separate pins, but only one to be active at any one time.
Given that the hardware is flexible in that regard, a binding which
artificially restricts that flexibility would seem unwise.

If we were to come across a setup which did route two SPDIF streams to
the TDA998x, and we had to make the decision at run time which to route
to the HDMI sink, we'd have to rework the binding, and we'd have to
support the new binding and the old binding in the driver.

Can you please look at Documentation/devicetree/bindings/graph.txt ?

I think we may be able to use something like this:

tda998x: hdmi-encoder {
	compatible = "nxp,tda998x";
	reg = <0x70>;
	video-ports = <0x234501>;

	port {
		tda998x_video: endpoint {
			remote-endpoint = <&lcd0_rgb>;
		};
	};

	port {
		#address-cells = <1>;
		#size-cells = <0>;

		tda998x_spdif0: endpoint@02 {
			reg = <0x02>;
			remote-endpoint = <&spdif0>;
		};

		tda998x_spdif1: endpoint@04 {
			reg = <0x04>;
			remote-endpoint = <&spdif0>;
		};

		tda998x_i2s: endpoint@03 {
			reg = <0x03>;
			remote-endpoint = <&i2s>;
		};
	};
};

I'm adding Philipp Zabel for comment.  The issue I see with this is that
we have two ports here which are not mutually exclusive, and it's not
obvious how they are dealt with.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
