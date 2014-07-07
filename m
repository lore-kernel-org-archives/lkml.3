Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaGHBNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:13:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaGGXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.15 027/122] drm/nouveau/disp/nv04-nv40: abort scanoutpos query on vga analog.
Date: Mon,  7 Jul 2014 16:56:29 -0700
Message-Id: <20140707235735.066963655@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit e291af3f2259e9e105dfd72416fd5796513791a4 upstream.

nv04_disp_scanoutpos() must abort to trigger simple timestamping
fallback if vtotal/htotal regs return zero. This happens if the
output isn't a digital output, but a vga analog output, as the
regs don't get initialized in that case.

Fixes timestamping failure on nv-40 and earlier with vga output.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/nv04.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nv04.c
@@ -51,6 +51,14 @@ nv04_disp_scanoutpos(struct nouveau_obje
 	args->htotal  = nv_rd32(priv, 0x680824 + (head * 0x2000)) & 0xffff;
 	args->hblanke = args->htotal - 1;
 
+	/*
+	 * If output is vga instead of digital then vtotal/htotal is invalid
+	 * so we have to give up and trigger the timestamping fallback in the
+	 * drm core.
+	 */
+	if (!args->vtotal || !args->htotal)
+		return -ENOTSUPP;
+
 	args->time[0] = ktime_to_ns(ktime_get());
 	line = nv_rd32(priv, 0x600868 + (head * 0x2000));
 	args->time[1] = ktime_to_ns(ktime_get());


