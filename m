Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaJJLSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:18:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31931 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaJJLSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:18:43 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-6e-5437c09076fb
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        daniel@ffwll.ch, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] drm/core: make ida allocation and de-allocation consistent
Date: Fri, 10 Oct 2014 13:16:51 +0200
Message-id: <1412939811-24304-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEJMWRmVeSWpSXmKPExsVy+t/xK7oTDpiHGBzv0La4te4cq0XvuZNM
	Fv+3TWS2uPL1PZvF5V1z2BxYPfZ+W8Disf3bA1aP+93HmTz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr40vTNdaC35wV15a5NjCe4+hi5OSQEDCRmHP9MwuELSZx4d56ti5GLg4hgaWMElPW
	9zFDOH1MEreez2UHqWIT0JT4u/kmG4gtIqAs8XfiKkYQm1mgUuLI0ytgNcIC3hLPDzwBaubg
	YBFQlTj5NgIkzCvgLLHy/nNGiGVyEiePTWadwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpe
	cn7uJkZIOHzdwbj0mNUhRgEORiUe3gsy5iFCrIllxZW5hxglOJiVRHjn7wUK8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYFR+qrS5cceHKwt2/6gqPBB+4cmle/tqYm5HrzS45hJzo8jum7hJ1nWz
	mY7z6/5tS7RWftnI8WbW10dTM772cHt/2mAy/fhcvdMJF2uW+KqYzuKRaVklfGvTryjzjbu/
	PXJwuzF1eVSeksstRabfuzy/bQmb5lfdLPbylt1FwW+qbS+nPnknI7xfiaU4I9FQi7moOBEA
	75H6EeUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Connector type id is allocated using ida_simple_get, its counterpart
is ida_simple_remove, so we should use it instead of ida_remove.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/drm_crtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index ecd4e0b..6bf9fdb 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -904,6 +904,8 @@ void drm_connector_cleanup(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
 	struct drm_display_mode *mode, *t;
+	struct ida *connector_ida =
+		&drm_connector_enum_list[connector->connector_type].ida;
 
 	list_for_each_entry_safe(mode, t, &connector->probed_modes, head)
 		drm_mode_remove(connector, mode);
@@ -911,8 +913,7 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	list_for_each_entry_safe(mode, t, &connector->modes, head)
 		drm_mode_remove(connector, mode);
 
-	ida_remove(&drm_connector_enum_list[connector->connector_type].ida,
-		   connector->connector_type_id);
+	ida_simple_remove(connector_ida, connector->connector_type_id);
 
 	drm_mode_object_put(dev, &connector->base);
 	kfree(connector->name);
-- 
1.9.1

