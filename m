Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaCXPK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:10:58 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:56168 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360AbaCXPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:10:57 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Mon, 24 Mar 2014 15:10:51 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dmitry Malkin <DMalkin@ptsecurity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [DRM] drm_get_connector_name internal static string buffer
Message-ID: <20140324151051.GQ4366@nuc-i3427.alporthouse.com>
References: <4a4b8c8a3dec4b838f01494234997aaa@DC1-MBX-01.ptsecurity.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a4b8c8a3dec4b838f01494234997aaa@DC1-MBX-01.ptsecurity.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 02:36:49PM +0000, Dmitry Malkin wrote:
> Hello guys,
> 
> I've been playing with reloading intel gfx driver (i915) in a cycle, for a while,
> and at some point I've found a non-deterministic kernel crash with a highly-variable
> iteration dependency -- 2 to 200 driver reload iterations.
> 
> The apparent race is over the shared internal string buffer in drm_get_connector_name().
> It is mostly harmless, due to its results being mostly used for log output, but in at least one
> case  -- drm_sysfs_connector_add() -- this leads to a more critical error.

If we can rely on drm_sysfs_connector_add() always being called before
anything of interest happens to the connector, then something like:

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 16ca28ed5ee8..de0b5acd713c 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -268,25 +268,16 @@ const char *drm_get_encoder_name(const struct drm_encoder *encoder)
 }
 EXPORT_SYMBOL(drm_get_encoder_name);
 
-/**
- * drm_get_connector_name - return a string for connector
- * @connector: connector to compute name of
- *
- * Note that the buffer used by this function is globally shared and owned by
- * the function itself.
- *
- * FIXME: This isn't really multithreading safe.
- */
-const char *drm_get_connector_name(const struct drm_connector *connector)
+const char *__drm_get_connector_name(const struct drm_connector *connector,
+				     char *buf, int len)
 {
-	static char buf[32];
-
-	snprintf(buf, 32, "%s-%d",
+	snprintf(buf, len, "%s-%d",
 		 drm_connector_enum_list[connector->connector_type].name,
 		 connector->connector_type_id);
+
 	return buf;
 }
-EXPORT_SYMBOL(drm_get_connector_name);
+EXPORT_SYMBOL(__drm_get_connector_name);
 
 /**
  * drm_get_connector_status_name - return a string for connector status
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index c22c3097c3e8..26069e254605 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -370,6 +370,7 @@ static struct bin_attribute edid_attr = {
 int drm_sysfs_connector_add(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
+	char name[32];
 	int attr_cnt = 0;
 	int opt_cnt = 0;
 	int i;
@@ -380,9 +381,8 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 
 	connector->kdev = device_create(drm_class, dev->primary->kdev,
 					0, connector, "card%d-%s",
-					dev->primary->index, drm_get_connector_name(connector));
-	DRM_DEBUG("adding \"%s\" to sysfs\n",
-		  drm_get_connector_name(connector));
+					dev->primary->index, __drm_get_connector_name(connector, name, sizeof(name)));
+	DRM_DEBUG("adding \"%s\" to sysfs\n", name);
 
 	if (IS_ERR(connector->kdev)) {
 		DRM_ERROR("failed to register connector device: %ld\n", PTR_ERR(connector->kdev));
@@ -436,6 +436,7 @@ err_out_files:
 	device_unregister(connector->kdev);
 
 out:
+	connector->kdev = NULL;
 	return ret;
 }
 EXPORT_SYMBOL(drm_sysfs_connector_add);
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 27f828c9d7f2..b64e33837238 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -868,7 +868,8 @@ extern void drm_plane_force_disable(struct drm_plane *plane);
 
 extern void drm_encoder_cleanup(struct drm_encoder *encoder);
 
-extern const char *drm_get_connector_name(const struct drm_connector *connector);
+static inline const char *drm_get_connector_name(const struct drm_connector *connector) { return dev_name(connector->kdev); }
+extern const char *__drm_get_connector_name(const struct drm_connector *connector, char *buf, int len);
 extern const char *drm_get_connector_status_name(enum drm_connector_status status);
 extern const char *drm_get_subpixel_order_name(enum subpixel_order order);
 extern const char *drm_get_dpms_name(int val);


-- 
Chris Wilson, Intel Open Source Technology Centre
