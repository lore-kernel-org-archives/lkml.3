Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaI1QFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:05:49 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:47548 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbaI1QFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:05:48 -0400
Date: Sun, 28 Sep 2014 18:05:50 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC:kirkwood: Don't raise an error when no DAI format
Message-ID: <20140928180550.5f0b8f03@armhf>
In-Reply-To: <20140928151207.GI5182@n2100.arm.linux.org.uk>
References: <20140928150342.CC21B786A1D@smtpfb1-g21.free.fr>
	<20140928151207.GI5182@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014 16:12:07 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sun, Sep 28, 2014 at 04:19:27PM +0200, Jean-Francois Moine wrote:
> > The two DAIs of the kirkwood controller have a unique PCM format.
> > 
> > The simple-card sets the audio hardware definitions of all CPU DAIs.
> > The PCM format is defined only when it is present in the DT.
> > 
> > This patch prevents the controller to raise an error when
> > the DT audio card definition by the simple card contains the PCM
> > format of one CPU DAI only.
> 
> I think this is a silly idea - why should every driver have additional code
> to detect when it's called to do thing.  Why doesn't the simple card code
> always pass the required format?
> 
> Looking at other drivers, no one else does this; they all appear to require
> the proper format to be specified.
> 
> What some drivers do (eg, omap-mcbsp.c) is to block set_fmt when the
> DAI is already in use - setting a flag "configured" in hw_params, and
> clearing it in shutdown.  Maybe following this will solve your problem.
> 
> In any case, random drivers doing stuff differently without reason is
> really not a good idea.

As the simple card is done, the audio hardware definitions of the
platform and all the CPU DAIS are always set in the audio controller.

When the PCM format is globally defined (platform), the function
set_fmt() is called for all CPU DAIs (then, twice for the kirkwood
controller) with the same value. The DT is:

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";
		simple-audio-card,format = "i2s";

		simple-audio-card,dai-link@0 {	/* S/PDIF - HDMI & S/PDIF */
			...
		};
		simple-audio-card,dai-link@1 {	/* I2S - HDMI */
			...
		};
	};

The PCM format may also be defined per DAI link. The following DT works
the same as setting globally the format, i.e. there are two calls to
set_fmt() with 'i2s':

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";

		simple-audio-card,dai-link@0 {	/* S/PDIF - HDMI & S/PDIF */
			format = "i2s";
			...
		};
		simple-audio-card,dai-link@1 {	/* I2S - HDMI */
			format = "i2s";
			...
		};
	};

The problem appears when the format is defined in only one DAI link:

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";

		simple-audio-card,dai-link@0 {	/* S/PDIF - HDMI & S/PDIF */
			format = "i2s";
			...
		};
		simple-audio-card,dai-link@1 {	/* I2S - HDMI */
			/* no format */
			...
		};
	};

Then, audio does not work.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
