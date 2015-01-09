Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbbAINHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:07:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55381 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752886AbbAINHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:07:39 -0500
Date: Fri, 9 Jan 2015 13:07:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jyri Sarha <jsarha@ti.com>, Mark Brown <broonie@kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109130725.GN12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
 <54AE99F5.1010404@ti.com>
 <20150108174257.557f7ea5@armhf>
 <54AFA9B0.6040405@ti.com>
 <20150109123036.4bc4bbf6@armhf>
 <20150109114529.GH12302@n2100.arm.linux.org.uk>
 <20150109135401.5b270d46@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109135401.5b270d46@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 01:54:01PM +0100, Jean-Francois Moine wrote:
> On Fri, 9 Jan 2015 11:45:29 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > I think we need to understand exactly how the 998x map I2S inputs to the
> > HDMI channels to avoid making a mistake with the binding; remember, the
> > binding isn't something that can be easily "bug fixed" at a later date
> > as anything we come up with now has to be supported long term by the
> > kernel.
> 
> The DT describes the hardware configuration.

You're missing my point.

How does the driver know which of the I2S pins to enable in I2S mode?

> A fully wired tda998x could be a chip with the audio pins connected to:
> - a kirkwood-like audio device with one I2S and one S/PDIF output,
> - two other audio devices with one I2S each.

I don't think it's that simple.  Since there is only one WS input to
the 998x, the four I2S sources would need to synchronise somehow, and
since the I2S source generates WS, connecting the 998x to multiple
independent I2S sources, each with their own WS output, presents a
hardware problem.

> With S/PDIF, only one stereo channel may be sent, but with I2S, up to 4
> stereo channels may be sent.

That statement is not entirely accurate.  Yes, with S/PDIF, only one
PCM L+R channel can be sent.  However, S/PDIF also supports sending
more channels using "non-audio" streams, with the data encoded as
MPEG or AAC.  This uses the HDMI data islands which would've been
occupied by the Front L+R PCM channel.

> These channels are extracted by the devices connected on the HDMI bus.

That's incorrect.  Please read the HDMI 1.3 specification; channels are
allocated for Front L+R, Centre, Sub, Rear L+R and there's no
identification to indicate that there are two Front L+R channels which
are different languages.

If you feel differently, please provide a reference to the HDMI
specification which describes this feature.

> An example could be the playing of a multi-language movie: each audio
> channel carries one language. From the computer view, the playing
> application sends each language to one sound card.

The selection of the language is done at the player, not by the display
device.

> So, this means that the tda998x driver should check that S/PDIF and I2S
> are not active at the same time, and it should also do a pin OR/AND on
> I2S start/stop.

That's correct: the TDA998x can operate in one of two modes: either
S/PDIF _or_ I2S, but never both.

My question is: how do we know which I2S inputs to enable, or are
you suggesting that all I2S inputs should be enabled if operating in
I2S mode irrespective of whether they may be active?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
