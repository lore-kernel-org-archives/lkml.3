Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbbAMTyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:54:36 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37762 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753450AbbAMTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:54:34 -0500
Date: Tue, 13 Jan 2015 19:54:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150113195415.GV12302@n2100.arm.linux.org.uk>
References: <20150112140456.GI12302@n2100.arm.linux.org.uk>
 <20150112181341.4a53ea24@armhf>
 <20150112175705.GN12302@n2100.arm.linux.org.uk>
 <1421151718.4519.24.camel@pengutronix.de>
 <20150113122715.GP12302@n2100.arm.linux.org.uk>
 <20150113165411.5469930d@armhf>
 <20150113160313.GR12302@n2100.arm.linux.org.uk>
 <20150113200252.3dbfab14@armhf>
 <20150113192648.GU12302@n2100.arm.linux.org.uk>
 <54B574CD.9020905@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B574CD.9020905@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 09:41:01PM +0200, Jyri Sarha wrote:
> On 01/13/2015 09:26 PM, Russell King - ARM Linux wrote:
> >SCLK: _~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
> >   WS: __~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~________________________________~
> >I2S1: llmm............................llmm............................llm
> >I2S2: llmm............................llmm............................llm
> >I2S3: llmm............................llmm............................llm
> >I2S4: llmm............................llmm............................llm
> >
> >So, what I'm saying is that it is_impossible_  to drive the TDA998x using
> >multiple I2S streams which are not produced by the same I2S block.
> 
> This is besides the point, but it is possible that one of the multiple I2S
> blocks is the bit-clock and frame-clock master to the i2s bus and the others
> are slaves to it (banging their bits according to SCLK and WS of the I2S
> master). However, in this situation there really is only one i2s bus with
> multiple data pins.
> 
> Just my 0.02€ to this discussion.

Right, that's about the only way it could work.

To represent that in DT, I would imagine we'd need something like this:

	#address-cells = <1>;
	#size-cells = <0>;
	...
        port@1 {                        /* AP1,2 = I2S */
		#address-cells = <1>;
		#size-cells = <0>;
                port-type = "i2s";
                reg = <0x01>;		/* WS */
                tda998x_i2s1: endpoint@2 {
			reg = <0x02>;	/* AP1 */
                        remote-endpoint = <&audio1_i2s>;
                };
                tda998x_i2s2: endpoint@4 {
			reg = <0x04>;	/* AP2 */
                        remote-endpoint = <&audio2_i2s>;
                };
        };

where audio1_i2s is operating in master mode, and audio2_i2s is
operating in slave mode for both WS and SCLK.

If we can agree on that, then I'm happy with the proposed binding.
(Remember that #address-cells and #size-cells are required in the
parent where we have reg= in the child.)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
