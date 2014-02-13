Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaBMDsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:48:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaBMDsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:48:07 -0500
Date: Wed, 12 Feb 2014 22:47:51 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: moinejf@free.fr, rmk+kernel@arm.linux.org.uk,
        linux-coverity@vger.kernel.org
Subject: drm/i2c: tda998x: Fix memory leak in tda998x_encoder_init error path.
Message-ID: <20140213034751.GA26499@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	moinejf@free.fr, rmk+kernel@arm.linux.org.uk,
	linux-coverity@vger.kernel.org
References: <20140212171058.6CCD6660CAF@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212171058.6CCD6660CAF@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6ae668cc19e8b18df28cd67b3448d9abd79284a4 introduced a memory leak
in the error path of tda998x_encoder_init

Picked up by the nightly Coverity scan. CID 1174076
    
Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index fa18cf374470..faa77f543a07 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1151,8 +1151,10 @@ tda998x_encoder_init(struct i2c_client *client,
 
 	priv->current_page = 0xff;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
-	if (!priv->cec)
+	if (!priv->cec) {
+		kfree(priv);
 		return -ENODEV;
+	}
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
 	encoder_slave->slave_priv = priv;
