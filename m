Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3EQViq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab3EQViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 094/102] drm/radeon: restore nomodeset operation (v2)
Date: Fri, 17 May 2013 14:36:49 -0700
Message-Id: <20130517213254.102395284@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit e9ced8e040ebe40e9953db90acbe7d0b58702ebb upstream.

When UMS was deprecated it removed support for nomodeset commandline
we really want this in distro land so we can debug stuff, everyone
should fallback to vesa correctly.

v2: oops -1 isn't used anymore, restore original behaviour
-1 is default, so we can boot with nomodeset on the command line,
then use radeon.modeset=1 to override it for debugging later.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_drv.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -144,7 +144,7 @@ static inline void radeon_unregister_atp
 #endif
 
 int radeon_no_wb;
-int radeon_modeset = 1;
+int radeon_modeset = -1;
 int radeon_dynclks = -1;
 int radeon_r4xx_atom = 0;
 int radeon_agpmode = 0;
@@ -449,6 +449,16 @@ static struct pci_driver radeon_kms_pci_
 
 static int __init radeon_init(void)
 {
+#ifdef CONFIG_VGA_CONSOLE
+	if (vgacon_text_force() && radeon_modeset == -1) {
+		DRM_INFO("VGACON disable radeon kernel modesetting.\n");
+		radeon_modeset = 0;
+	}
+#endif
+	/* set to modesetting by default if not nomodeset */
+	if (radeon_modeset == -1)
+		radeon_modeset = 1;
+
 	if (radeon_modeset == 1) {
 		DRM_INFO("radeon kernel modesetting enabled.\n");
 		driver = &kms_driver;


