Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAMT1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:27:07 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37712 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753538AbbAMT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:27:05 -0500
Date: Tue, 13 Jan 2015 19:26:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150113192648.GU12302@n2100.arm.linux.org.uk>
References: <20150112122527.GF12302@n2100.arm.linux.org.uk>
 <1421071197.3081.44.camel@pengutronix.de>
 <20150112140456.GI12302@n2100.arm.linux.org.uk>
 <20150112181341.4a53ea24@armhf>
 <20150112175705.GN12302@n2100.arm.linux.org.uk>
 <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
 <20150113160313.GR12302@n2100.arm.linux.org.uk>
 <20150113200252.3dbfab14@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113200252.3dbfab14@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 08:02:52PM +0100, Jean-Francois Moine wrote:
> On Tue, 13 Jan 2015 16:03:13 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Tue, Jan 13, 2015 at 04:54:11PM +0100, Jean-Francois Moine wrote:
> > > 4 streams on 4 different APs (sources) should work, but 4 streams from
> > > a same source should be detailed.
> > 
> > I'd like to know how you intend to wire up four different I2S sources
> > to the TDA998x.
> > 
> > Remember, an I2S source produces the I2S data and the word clock - that's
> > two outputs.  You can't electronically wire the word clocks together.
> 
> From the spec, the tda998x gets independently the serial clock and the
> serial word select from each I2S (stereo) input channel (= audio pin),
> so, you may have 4 audio chips giving 4 independent audio streams.
> I don't know what can be the result in HDMI if these streams are actived
> at the same time!
> 
> In the other configuration, an audio chip may have 4 synchronized stereo
> channels (software PCMs). These ones may be considered as one link (one
> port out from the audio chip to one port in to the tda998x), the AP
> configuration being 0x1f.

Let me try to be clearer.  Here's four independent I2S blocks which
have been arranged to be clocked by the same I2S bus clock.  Each
I2S block produces its own word clock and data stream:

SCLK
|  +-------+
+->| I2S   +------> WS1
|  | src 1 +------> I2S1
|  +-------+
|
|  +-------+
+->| I2S   +------> WS2
|  | src 2 +------> I2S2
|  +-------+
|
|  +-------+
+->| I2S   +------> WS3
|  | src 3 +------> I2S3
|  +-------+
|
|  +-------+
+->| I2S   +------> WS4
|  | src 4 +------> I2S4
|  +-------+
|
|        +---------+
|        | TDA998x |
`------->+ ACLK    |
  WS --->+ AP0     |
I2S1 --->+ AP1     |
I2S2 --->+ AP2     |
I2S3 --->+ AP3     |
I2S4 --->+ AP4     |
         +---------+

The arrows point from the output (driver of the signal) to the input.
It is illegal in electronics to wire two outputs (which are not able to
disable their output drivers) together.

How do you arrange for WS1..WS4 to be connected to the TDA998x WS input?

My answer is: this is an impossible setup.

Since these are independent blocks, there is no guarantee that the
WS1..WS4 outputs will be synchronised to each other, since that depends
upon the SCLK edge that each unit becomes enabled.  That also determines
the bit position relative to SCLK of the first bit output.

Hence, you could very well end up with something like this for a 16-bit
I2S output from each I2S block:

SCLK: _~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
 WS1: __~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~________________________________~
I2S1: llmm............................llmm............................llm
 WS2: ________________~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~___________________
I2S2: ..............llmm............................llmm.................
 WS3: ________~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~___________________________
I2S3: ......llmm............................llmm.........................
 WS4: ______~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~_____________________________
I2S4: ....llmm............................llmm...........................

where 'l' indicates the LSB of the sample, and 'm' indicates the MSB.

The problem is that the TDA998x expects each I2S input to be synchronised.
In other words, the WS input is shared between each and every separate I2S
input, which means the MSB of each I2S input needs to be supplied at
exactly the same SCLK edge.  In other words:

SCLK: _~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
  WS: __~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~________________________________~
I2S1: llmm............................llmm............................llm
I2S2: llmm............................llmm............................llm
I2S3: llmm............................llmm............................llm
I2S4: llmm............................llmm............................llm

So, what I'm saying is that it is _impossible_ to drive the TDA998x using
multiple I2S streams which are not produced by the same I2S block.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
