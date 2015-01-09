Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbbAIO6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:58:00 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55648 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751994AbbAIO56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:57:58 -0500
Date: Fri, 9 Jan 2015 14:57:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109145741.GP12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
 <54AE99F5.1010404@ti.com>
 <20150108174257.557f7ea5@armhf>
 <54AFA9B0.6040405@ti.com>
 <20150109123036.4bc4bbf6@armhf>
 <20150109114529.GH12302@n2100.arm.linux.org.uk>
 <20150109135401.5b270d46@armhf>
 <20150109130725.GN12302@n2100.arm.linux.org.uk>
 <54AFDE8D.3000504@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFDE8D.3000504@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 01:58:37PM +0000, Andrew Jackson wrote:
> On 01/09/15 13:07, Russell King - ARM Linux wrote:
> > On Fri, Jan 09, 2015 at 01:54:01PM +0100, Jean-Francois Moine wrote:
> >> On Fri, 9 Jan 2015 11:45:29 +0000
> >> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >>> I think we need to understand exactly how the 998x map I2S inputs to the
> >>> HDMI channels to avoid making a mistake with the binding; remember, the
> >>> binding isn't something that can be easily "bug fixed" at a later date
> >>> as anything we come up with now has to be supported long term by the
> >>> kernel.
> >>
> >> The DT describes the hardware configuration.
> > 
> > You're missing my point.
> > 
> > How does the driver know which of the I2S pins to enable in I2S mode?
> 
> [snip]
> 
> > My question is: how do we know which I2S inputs to enable, or are
> > you suggesting that all I2S inputs should be enabled if operating in
> > I2S mode irrespective of whether they may be active?
> > 
> 
> Isn't it the case that for I2S:
> 
> * Word Select (WS) is always required to disambiguate left/right. So WS need
>   not be specified in any device tree configuration.

Yep.

> * The audio inputs depend on a particular board but at least one is 
>   required.  Fortunately, the TDA998x devices have all the same pin/input
>   numbering so they /could/ be described as i2s0, i2s1, i2s2 and i2s3 as 
>   per J-F's earlier email.  But tt isn't clear from my reading of the 
>   TDA19988 datasheet (for example) whether one can skip channels (so
>   does channel 0 always have to be present?).  If the channels must
>   be enabled from 0 then one could simply specify the number of inputs.
>   (The datasheets that I have don't indicate whether there's any 
>   channel remapping performed internally by the TDA998x).

Well, if we look at the HDMI specs, there is a field in the audio info
frame (CA bits) which identifies the speaker allocation between the
HDMI PCM channels and the physical speakers.

It describes a limited set - essentially though, channel 0 is always
front left, and channel 1 is always front right.  Channel 2 is always
LFE, and channel 3 is always front centre.

Channel 0 and 1 are always allocated, but it's possible to have channels
above 2 to be allocated independently of each other (eg, you could have
7, 6, 1, 0 allocated to front right centre, front left centre, right,
left speakers - in that order.)

As you point out, we don't have documentation which tells us know how
these PCM channels map to I2S inputs.

What we do know is that there is a fixed mapping between AP pins and I2S
channels (which are not PCM channels), but as you point out, we don't
have any documentation which describes how the I2S channels (each with
their own L+R words) map to the PCM channels - and we don't know whether
the CA_I2S bits in that same register in the TDA998x have an effect on
this.

Does anyone have a TDA998x setup which has an I2S source connected to
the TDA998x I2S channel 1, and who has a HDMI sink which will accept
the LFE/FC channels?  If so, producing a description of how the CA_I2S
bits and enabling I2S input pins influences the mapping would be a good
idea.

If we don't have that, I'd recommend splitting the DT property into
"audio inputs for I2S" and "audio input for SPDIF" (only one can be
active with SPDIF).

If we want to support more than one SPDIF input (which must be mutually
exclusive) I'd recommend to look at the OF graph stuff we use in DRM -
one port for each "mode" - eg, I2S, SPDIF in on AP2, SPDIF in on AP3.
Each port node can specify the AP pins which should be enabled.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
