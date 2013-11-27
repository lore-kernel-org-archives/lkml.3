Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3K0CAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:00:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab3K0A5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.10 14/80] drm/nva3-/disp: fix hda eld writing, needs to be padded
Date: Tue, 26 Nov 2013 16:56:43 -0800
Message-Id: <20131127005641.934166958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 02d69294a174d7cb6a76080b6d16971ca08728d4 upstream.

Commits 0a9e2b959 (drm/nvd0/disp: move HDA codec setup to core) and
a4feaf4ea (drm/nva3/disp: move hda codec handling to core) moved code
around but neglected to fill data up to 0x60 as before. This caused
/proc/asound/cardN/eld#3.0 to show eld_valid as 0. With this patch, that
file is again populated with the correct data.

See https://bugs.freedesktop.org/show_bug.cgi?id=67051

Reported-and-tested-by: Alex <alupu01@gmail.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |    2 ++
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c
@@ -36,6 +36,8 @@ nva3_hda_eld(struct nv50_disp_priv *priv
 	if (data && data[0]) {
 		for (i = 0; i < size; i++)
 			nv_wr32(priv, 0x61c440 + soff, (i << 8) | data[i]);
+		for (; i < 0x60; i++)
+			nv_wr32(priv, 0x61c440 + soff, (i << 8));
 		nv_mask(priv, 0x61c448 + soff, 0x80000003, 0x80000003);
 	} else
 	if (data) {
--- a/drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c
@@ -41,6 +41,8 @@ nvd0_hda_eld(struct nv50_disp_priv *priv
 	if (data && data[0]) {
 		for (i = 0; i < size; i++)
 			nv_wr32(priv, 0x10ec00 + soff, (i << 8) | data[i]);
+		for (; i < 0x60; i++)
+			nv_wr32(priv, 0x10ec00 + soff, (i << 8));
 		nv_mask(priv, 0x10ec10 + soff, 0x80000003, 0x80000003);
 	} else
 	if (data) {


