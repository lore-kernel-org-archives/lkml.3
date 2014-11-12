Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077AbaKLDsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:48:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbaKLB2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.17 166/319] drm/nouveau: fix regression on agp boards
Date: Wed, 12 Nov 2014 10:15:04 +0900
Message-Id: <20141112011020.153443051@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 67e26e41ff8aa514826dae79f0b10169b5ba93b4 upstream.

Extends the fix in f2f9a2cbaf019481feefe231f996d3602612fa99 to also
workaround permission issues noticed by people using AGP systems.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_chan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -400,15 +400,20 @@ nouveau_channel_new(struct nouveau_drm *
 		    struct nouveau_channel **pchan)
 {
 	struct nouveau_cli *cli = (void *)nvif_client(&device->base);
+	bool super;
 	int ret;
 
+	/* hack until fencenv50 is fixed, and agp access relaxed */
+	super = cli->base.super;
+	cli->base.super = true;
+
 	ret = nouveau_channel_ind(drm, device, handle, arg0, pchan);
 	if (ret) {
 		NV_PRINTK(debug, cli, "ib channel create, %d\n", ret);
 		ret = nouveau_channel_dma(drm, device, handle, pchan);
 		if (ret) {
 			NV_PRINTK(debug, cli, "dma channel create, %d\n", ret);
-			return ret;
+			goto done;
 		}
 	}
 
@@ -416,8 +421,9 @@ nouveau_channel_new(struct nouveau_drm *
 	if (ret) {
 		NV_PRINTK(error, cli, "channel failed to initialise, %d\n", ret);
 		nouveau_channel_del(pchan);
-		return ret;
 	}
 
-	return 0;
+done:
+	cli->base.super = super;
+	return ret;
 }


