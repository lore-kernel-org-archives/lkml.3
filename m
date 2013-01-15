Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3APAMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:12:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:42832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab3AOWcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 132/221] udldrmfb: Fix EDID not working with monitors with EDID extension blocks
Date: Tue, 15 Jan 2013 10:50:59 -0800
Message-Id: <20130115185007.569346488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c930812fe5ebe725760422c9c351d1f6fde1502d upstream.

udldrmfb only reads the main EDID block, and if that advertises extensions
the drm_edid code expects them to be present, and starts reading beyond the
buffer udldrmfb passes it.

Although it may be possible to read more EDID info with the udl we simpy don't
know how, and even if trial and error gets it working on one device, that is
no guarantee it will work on other revisions. So this patch does a simple fix
in the form of patching the EDID info to report 0 extension blocks, this
fixes udldrmfb only doing 1024x768 on monitors with EDID extension blocks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_connector.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -57,6 +57,14 @@ static int udl_get_modes(struct drm_conn
 
 	edid = (struct edid *)udl_get_edid(udl);
 
+	/*
+	 * We only read the main block, but if the monitor reports extension
+	 * blocks then the drm edid code expects them to be present, so patch
+	 * the extension count to 0.
+	 */
+	edid->checksum += edid->extensions;
+	edid->extensions = 0;
+
 	drm_mode_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
 	kfree(edid);


