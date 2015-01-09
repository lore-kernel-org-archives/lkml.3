Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbbAILT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:19:56 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54941 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755109AbbAILTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:19:54 -0500
Date: Fri, 9 Jan 2015 11:19:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20150109111935.GF12302@n2100.arm.linux.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
 <54AD4C77.5000401@arm.com>
 <20150107154138.GL12302@n2100.arm.linux.org.uk>
 <20150107190241.27ebac8b@armhf>
 <54AFAC4C.7010209@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFAC4C.7010209@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:24:12PM +0200, Jyri Sarha wrote:
> I think that would still fail if DRM and TDA998x is built in and SND_SOC is
> built as modules. A request_module() call before tda9998x_codec_register()
> should help.

That doesn't fix the problem.  If the DRM driver is built in, but the
codec is not, and the DRM driver has a reference to
tda9998x_codec_register(), then the vmlinux file will fail to link,
and you'll never get the opportunity to call request_module().

> Or could could write:
> 
> select SND_SOC_TDA998X if (SND_SOC=DRM_I2C_NXP_TDA998X || SND_SOC=y)

I'm not sure that's right either.

Let's go back and think about this: why should SND_SOC_TDA998X be
*selected*.  Let me put that a different way: why should this symbol
be forced on just because we're building the DRM TDA998x driver?

Would it be more sensible to make SND_SOC_TDA998X depend on
DRM_I2C_NXP_TDA998X instead, maybe with a 'default y' - which is a
kinder way to have SND_SOC_TDA998X be enabled.  If SND_SOC_TDA998X
doesn't have a prompt, then it'll automatically enable itself too
this way when all its dependencies are satisfied.

IMHO "select" is a very over-used, and in many cases an evil
construct because its very hard to avoid breaking dependencies
with it.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
