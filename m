Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbANMMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:12:52 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39478 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181AbbANMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:12:50 -0500
Date: Wed, 14 Jan 2015 12:12:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jyri Sarha <jsarha@ti.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150114121233.GW12302@n2100.arm.linux.org.uk>
References: <20150112175705.GN12302@n2100.arm.linux.org.uk>
 <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
 <20150113160313.GR12302@n2100.arm.linux.org.uk>
 <20150113200252.3dbfab14@armhf>
 <20150113192648.GU12302@n2100.arm.linux.org.uk>
 <54B574CD.9020905@ti.com>
 <20150113195415.GV12302@n2100.arm.linux.org.uk>
 <20150114085501.677dc4d2@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150114085501.677dc4d2@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:55:01AM +0100, Jean-Francois Moine wrote:
> On Tue, 13 Jan 2015 19:54:15 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Tue, Jan 13, 2015 at 09:41:01PM +0200, Jyri Sarha wrote:
> > > On 01/13/2015 09:26 PM, Russell King - ARM Linux wrote:
> > > >SCLK: _~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
> > > >   WS: __~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~________________________________~
> > > >I2S1: llmm............................llmm............................llm
> > > >I2S2: llmm............................llmm............................llm
> > > >I2S3: llmm............................llmm............................llm
> > > >I2S4: llmm............................llmm............................llm
> > > >
> > > >So, what I'm saying is that it is_impossible_  to drive the TDA998x using
> > > >multiple I2S streams which are not produced by the same I2S block.
> > > 
> > > This is besides the point, but it is possible that one of the multiple I2S
> > > blocks is the bit-clock and frame-clock master to the i2s bus and the others
> > > are slaves to it (banging their bits according to SCLK and WS of the I2S
> > > master). However, in this situation there really is only one i2s bus with
> > > multiple data pins.
> > > 
> > > Just my 0.02€ to this discussion.
> > 
> > Right, that's about the only way it could work.
> > 
> > To represent that in DT, I would imagine we'd need something like this:
> > 
> > 	#address-cells = <1>;
> > 	#size-cells = <0>;
> > 	...
> >         port@1 {                        /* AP1,2 = I2S */
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> >                 port-type = "i2s";
> >                 reg = <0x01>;		/* WS */
> >                 tda998x_i2s1: endpoint@2 {
> > 			reg = <0x02>;	/* AP1 */
> >                         remote-endpoint = <&audio1_i2s>;
> >                 };
> >                 tda998x_i2s2: endpoint@4 {
> > 			reg = <0x04>;	/* AP2 */
> >                         remote-endpoint = <&audio2_i2s>;
> >                 };
> >         };
> > 
> > where audio1_i2s is operating in master mode, and audio2_i2s is
> > operating in slave mode for both WS and SCLK.
> > 
> > If we can agree on that, then I'm happy with the proposed binding.
> > (Remember that #address-cells and #size-cells are required in the
> > parent where we have reg= in the child.)
> 
> #address-cells and #size-cells may be defined in any of the upper
> parent, so, as it is defined in the device, it is not needed in the
> port (see of_n_addr_cells in drivers/of/base.c).

That may be, but the documentation specifies that it should be given.
See Documentation/devicetree/bindings/graph.txt - maybe the docs need
fixing?

> Well, I am a bit lost between (only one source / many channels - I2S
> busses) and (many sources / one I2s bus!).

I think that's a matter of how the problem is viewed. :)

> Anyway, I don't understand your example.
> I'd expect that a port would be a DAI.

I view a DAI as a Linux abstraction, which doesn't really have any place
in DT.  I'm looking at this problem from the electronics point of view.

> If yes, when playing is active, both endpoints receive an audio stream
> from the remote audio devices, and the AP register is always set to
> 0x07 (= 0x01 | 0x02 | 0x04).
> Then, it would have been simpler to have:
> 
>  	#address-cells = <1>;
>  	#size-cells = <0>;
>  	...
>          port@7 {                        /* AP1,2 = I2S */
>                  port-type = "i2s";
>                  reg = <0x07>;		/* WS + AP1 + AP2 */
>                  tda998x_i2s1: endpoint@1 {
>                          remote-endpoint = <&audio1_i2s>;
>                  };
>                  tda998x_i2s2: endpoint@2 {
>                          remote-endpoint = <&audio2_i2s>;
>                  };
>          };
> 
> If no, the two DAIs must be created from the endpoints, permitting
> streaming on i2s1 alone, i2s2 alone or both i2s1+i2s2 at the same time.

How does that work - I mean, if we have i2s1 as the SCLK and WS master,
how can i2s2 run without i2s1?

I suppose I2S2 could be reprogrammed to be the master for both signals,
provided that I2S1 is programmed to be a slave before hand, but that
seems to be making things excessively complex (we'd need some way for
I2S1 and I2S2 to comunicate that state between themselves and negotiate
which to be the master.)

However, I'd suggest that if audio1_i2s always maps to HDMI front
left/right, audio1_i2s must always be enabled when audio playback is
required; there is no CA bit combination provided in HDMI where the
front L/R channels are optional.  Hence, I'd suggest that audio1_i2s
must always be the master.

As we don't know, I'd suggest that we permit flexibility here.  We
can use the reg property as you have below, and we just bitwise-or
the of_endpoint port/id together, along with that result from other
active audio endpoints.  The advantage of that is we can use any of
these representations, and it should result in a working setup - and
when we do have the necessary information to make a properly informed
decision, we can update the DT and binding doc accordingly and we
won't have to update the driver (nor will we break backwards compat.)

Sound sane?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
