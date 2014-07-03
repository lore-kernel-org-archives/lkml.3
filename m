Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaGCNn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:43:59 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52931 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755079AbaGCNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:43:57 -0400
Date: Thu, 3 Jul 2014 14:43:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140703134346.GW32514@n2100.arm.linux.org.uk>
References: <20140702183841.7c964832@armhf> <20140702165628.GO20799@lunn.ch> <20140702195154.47d6f6b4@armhf> <20140702194252.GN410@sirena.org.uk> <20140703074959.7c489912@armhf> <20140703104432.GV410@sirena.org.uk> <20140703133406.2d3e3a1d@armhf> <20140703115924.GY410@sirena.org.uk> <20140703152826.103c9d6c@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703152826.103c9d6c@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 03:28:26PM +0200, Jean-Francois Moine wrote:
> OK. no problem, I can do that: only the first stream is switched and
> the second is rejected.
> 
> But, this means that there will be a lot of errors when DPCM will be
> used, because, in most cases for the Cubox (kirkwood audio + tda998x),
> both ways I2S and S/PDIF will be activated at the same time for a
> single stream (you may note that the routes from the second input
> cannot be blocked by the CODEC after it received the first input,
> because these routes have already been computed).

This is /very/ easy to solve on the Cubox, if only you would listen
to me - I've stated many times that I2S should not be used there.

Just because the hardware is wired up with both the SPDIF connected
and the I2S connected, it does *not* mean that we have to wire them
both up in software.

Indeed, *everything* works with just SPDIF.  The same is not true of
I2S.  So, what we do for the Cubox is we just wire up SPDIF in software
and be done with it - we then get a fully functional setup.  So using
I2S on the Cubox is mostly pointless - unless you wish to use I2S for
testing purposes.

Let me also point out that adding your changes - including the addition
of this codec patch - explicitly deny the possibility of:
* using compressed audio streams via the optical SPDIF out socket
* using compressed audio streams over HDMI
* using audio rates and formats not supported by the attached HDMI
  device via the optical SPDIF socket.

These are serious issues which thus far you have so far failed to
respond on.  People who use the Cubox as a media platform rather
than (presumably) just a music jukebox want things like compressed
audio out and SPDIF out to work.

Look, one reason to use the optical socket is because you want to
push out a stream at (eg) 96kHz to your audio system, but your TV
doesn't support it.  With your approach, you explicitly block that
because the TDA998x codec assocated with the Kirkwood CPU DAI
refuses to allow that sample rate.  Fine, if the attached device
does not support that rate, then the right thing to do may be to
disable audio transmission over HDMI, but with the Cubox hardware,
limiting the sample rates is totally the wrong solution.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
