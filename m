Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbbAYSLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbbAYSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.18 031/183] drm/dp: retry AUX transactions 32 times (v1.1)
Date: Sun, 25 Jan 2015 10:05:53 -0800
Message-Id: <20150125180811.513723467@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_helper.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -378,10 +378,11 @@ static int drm_dp_dpcd_access(struct drm
 
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


