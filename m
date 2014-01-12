Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaALNUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:20:44 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54183 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaALNUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:20:41 -0500
Date: Sun, 12 Jan 2014 14:20:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] drm/i2c: tda998x: move the TBG_CNTRL_0
 register setting
Message-ID: <20140112142000.1f3e5ab5@armhf>
In-Reply-To: <20140112123159.GS15937@n2100.arm.linux.org.uk>
References: <20140109120607.6a33bee5@armhf>
	<20140111183648.GH15937@n2100.arm.linux.org.uk>
	<20140112132321.757f3fa7@armhf>
	<20140112123159.GS15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014 12:31:59 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > So, in my patch 9, I was writing the REG_TBG_CNTRL_1 after writing
> > REG_TBG_CNTRL_0, and you refused it. Here, I write REG_TBG_CNTRL_0
> > after the write of REG_TBG_CNTRL_1 in the HDMI sequence, and you still
> > don't agree.
> > 
> > What is the right way?  
> 
> No, both NAKS are for the exact same issue.
> 
> Patch 9 inserted the write to REG_TBG_CNTRL_1 after REG_TBG_CNTRL_0.
> Then in this patch you move REG_TBG_CNTRL_0 after all writes.
> 
> Had you appropriately placed the write to REG_TBG_CNTRL_1 in patch 9
> in the first place, _this_ patch (patch 20) would not be required to
> then move REG_TBG_CNTRL_0 after it.  So, fixing patch 9 removes the
> need for patch 20.

Fixing the patch 9 gives:

	/*
	 * Always generate sync polarity relative to input sync and
	 * revert input stage toggled sync at output stage
	 */
	reg = TBG_CNTRL_1_DWIN_DIS | TBG_CNTRL_1_TGL_EN;
	if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
		reg |= TBG_CNTRL_1_H_TGL;
	if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
		reg |= TBG_CNTRL_1_V_TGL;
	reg_write(priv, REG_TBG_CNTRL_1, reg);

	/* must be last register set: */
	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);

	/* Only setup the info frames if the sink is HDMI */
	if (priv->is_hdmi_sink) {
		/* We need to turn HDMI HDCP stuff on to get audio through */
		reg &= ~TBG_CNTRL_1_DWIN_DIS;
		reg_write(priv, REG_TBG_CNTRL_1, reg);
		reg_write(priv, REG_ENC_CNTRL, ENC_CNTRL_CTL_CODE(1));
		reg_set(priv, REG_TX33, TX33_HDMI);

		tda998x_write_avi(priv, adj_mode);

		if (priv->params.audio_cfg)
			tda998x_configure_audio(priv, adj_mode, &priv->params);
	}

and REG_TBG_CNTRL_1 is set in the HDMI branch (with REG_ENC_CNTRL and
REG_TX33).

Is this OK?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
