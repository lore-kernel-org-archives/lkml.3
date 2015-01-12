Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbbALSL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:11:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57754 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbALSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 098/216] drm/dp: retry AUX transactions 32 times (v1.1)
Date: Mon, 12 Jan 2015 18:03:35 +0000
Message-Id: <1421085933-32536-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 19a93f042fc241ecdf98543cedfe7c171f8cdf53 upstream.

At least on two MST devices I've tested with, when
they are link training downstream, they are totally
unable to handle aux ch msgs, so they defer like nuts.
I tried 16, it wasn't enough, 32 seems better.

This fixes one Dell 4k monitor and one of the
MST hubs.

v1.1: fixup comment (Tom).

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_dp_helper.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 08e33b8b13a4..9f59c9027ebe 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -378,10 +378,11 @@ static int drm_dp_dpcd_access(struct drm_dp_aux *aux, u8 request,
 
 	/*
 	 * The specification doesn't give any recommendation on how often to
-	 * retry native transactions, so retry 7 times like for I2C-over-AUX
-	 * transactions.
+	 * retry native transactions. We used to retry 7 times like for
+	 * aux i2c transactions but real world devices this wasn't
+	 * sufficient, bump to 32 which makes Dell 4k monitors happier.
 	 */
-	for (retry = 0; retry < 7; retry++) {
+	for (retry = 0; retry < 32; retry++) {
 
 		mutex_lock(&aux->hw_mutex);
 		err = aux->transfer(aux, &msg);
-- 
2.1.4

