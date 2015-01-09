Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbbAIRgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:36:40 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:62591 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbbAIRgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:36:39 -0500
Date: Fri, 9 Jan 2015 18:38:57 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150109183857.53d701a4@armhf>
In-Reply-To: <20150109145741.GP12302@n2100.arm.linux.org.uk>
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
	<20150109145741.GP12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 14:57:41 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Well, if we look at the HDMI specs, there is a field in the audio info
> frame (CA bits) which identifies the speaker allocation between the
> HDMI PCM channels and the physical speakers.
> 
> It describes a limited set - essentially though, channel 0 is always
> front left, and channel 1 is always front right.  Channel 2 is always
> LFE, and channel 3 is always front centre.
> 
> Channel 0 and 1 are always allocated, but it's possible to have channels
> above 2 to be allocated independently of each other (eg, you could have
> 7, 6, 1, 0 allocated to front right centre, front left centre, right,
> left speakers - in that order.)
> 
> As you point out, we don't have documentation which tells us know how
> these PCM channels map to I2S inputs.

I had a look at the TDA19988 (small) datasheet I have and at the HDMI
specs, and, yes, you are right: multi (stereo) channels implies speaker
mapping, and, then, that the I2S streams come from a same media source.

While, as said in the TDA19988 datasheet,
"The I2S-bus input interface receives an I2S-bus signal including
 serial data, word select and serial clock",
it would be strange that these I2S buses come from different audio devices.

> What we do know is that there is a fixed mapping between AP pins and I2S
> channels (which are not PCM channels), but as you point out, we don't
> have any documentation which describes how the I2S channels (each with
> their own L+R words) map to the PCM channels - and we don't know whether
> the CA_I2S bits in that same register in the TDA998x have an effect on
> this.

HDMI talks about LPCM (Linear PCM) channels and TDA19988 talks about
I2S-bus (stereo) channels. For me, it seems obvious that these channels
are correlated:
- LPCM-0 is I2S-bus-0-left (FL)
- LPCM-1 is I2S-bus-0-right (FR)
- LPCM-2 is I2S-bus-1-left (LFE)
- LPCM-3 is I2S-bus-1-right (FC)
...

> Does anyone have a TDA998x setup which has an I2S source connected to
> the TDA998x I2S channel 1, and who has a HDMI sink which will accept
> the LFE/FC channels?  If so, producing a description of how the CA_I2S
> bits and enabling I2S input pins influences the mapping would be a good
> idea.

I could not find a description of these CA_I2S bits.

> If we don't have that, I'd recommend splitting the DT property into
> "audio inputs for I2S" and "audio input for SPDIF" (only one can be
> active with SPDIF).
> 
> If we want to support more than one SPDIF input (which must be mutually
> exclusive) I'd recommend to look at the OF graph stuff we use in DRM -
> one port for each "mode" - eg, I2S, SPDIF in on AP2, SPDIF in on AP3.
> Each port node can specify the AP pins which should be enabled.

I agree. There are one S/PDIF port and one I2S port.

So, which syntax?

I proposed:

	audio-ports = <0x04>, <0x03>;
	audio-port-names = "spdif", "i2s";

Do you better like:

	audio-spdif-port = <0x04>;
	audio-i2s-port = <0x03>;

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
