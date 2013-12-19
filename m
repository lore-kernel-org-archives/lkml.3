Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3LSMoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:44:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:14178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3LSMoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:44:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427188237"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, David Airlie <airlied@linux.ie>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [Patch v2 12/13] nouveau: fix memory leak in ACPI _DSM related code
Date: Thu, 19 Dec 2013 20:38:21 +0800
Message-Id: <1387456702-4709-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
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

