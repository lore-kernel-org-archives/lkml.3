Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaAVW1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:27:15 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45783 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755579AbaAVW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:27:13 -0500
Date: Wed, 22 Jan 2014 22:27:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 15/24] drm/i2c: tda998x: use irq for connection
	status and EDID read
Message-ID: <20140122222705.GL15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195843.7ae9753d@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195843.7ae9753d@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:43PM +0100, Jean-Francois Moine wrote:
> This patch adds the optional treatment of the tda998x IRQ.
> 
> The interrupt function is used to know the display connection status
> without polling and to speedup reading the EDID.
> 
> The interrupt number may be defined either in the DT or at encoder set
> config time for non-DT boards.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> v3
>     - remarks from Russell King
> 	- move the setting of the wq_edid_wait flag before asking the
> 	  device to read the EDID
> 	  Thanks about this bug fix, but I don't see the other problem:
> 	  there is no reason for the read_edid_block function to be
> 	  called more than once...

It will happen whenever DRM asks the connector for the modes.  However,
since the read process is triggered each time, I think this is fine.

> 	- use '0' as 'no irq'
> 	- remove the useless delay after irq init

Some further comments...

> @@ -720,6 +787,10 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
>  		priv->audio_port = p->audio_cfg;
>  		priv->audio_format = p->audio_format;
>  	}
> +
> +	priv->irq = p->irq;
> +	if (p->irq)
> +		tda_irq_init(priv);

If we're going to do it this way, this should probably release the IRQ if
there was one before re-claiming it, just in case this function gets called
more than once by some driver using it.

The alternative is, as I said before, to use the infrastructure which is
already there, namely setting the interrupt via struct i2c_client's
irq member.  Yes, that doesn't satisfy Sebastian's comment about using
a GPIO, but there's no sign of GPIO usage in here at the moment anyway.
So we might as well use what's already provided.

That would then avoid the need to deal with IRQ changes etc in
tda998x_encoder_set_config().

In any case, I've tested this patch in both non-IRQ and IRQ modes, and it
appears to work - but I'd like the suggestion above before I provide any
attributations.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
