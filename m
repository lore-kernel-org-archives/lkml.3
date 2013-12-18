Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3LRG62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:46231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3LRG6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:58:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666883"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 12/13] nouveau: fix memory leak in ACPI _DSM related code
Date: Wed, 18 Dec 2013 14:58:20 +0800
Message-Id: <1387349901-3391-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in function nouveau_optimus_dsm() and nouveau_dsm().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 95c7404..03d4911 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -110,6 +110,7 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 
 	if (obj->type == ACPI_TYPE_INTEGER)
 		if (obj->integer.value == 0x80000002) {
+			kfree(output.pointer);
 			return -ENODEV;
 		}
 
@@ -156,8 +157,10 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 	obj = (union acpi_object *)output.pointer;
 
 	if (obj->type == ACPI_TYPE_INTEGER)
-		if (obj->integer.value == 0x80000002)
+		if (obj->integer.value == 0x80000002) {
+			kfree(output.pointer);
 			return -ENODEV;
+		}
 
 	if (obj->type == ACPI_TYPE_BUFFER) {
 		if (obj->buffer.length == 4 && result) {
-- 
1.7.10.4

