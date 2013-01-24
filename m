Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3AXNOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:14:18 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:65357 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab3AXNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:14:09 -0500
Message-ID: <1359033178.1325.15.camel@x61.thuisdomein>
Subject: [PATCH] acer-wmi: do not use 'devices' uninitialized
From: Paul Bolle <pebolle@tiscali.nl>
To: "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Jan 2013 14:12:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jan 2013 13:12:59.0037 (UTC) FILETIME=[87FD24D0:01CDFA34]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f20aaba9819d0801fb1314363f97239da0100bac ("acer-wmi: fix obj is
NULL but dereferenced") introduced a GCC warning:
    drivers/platform/x86/acer-wmi.c: In function ‘acer_wmi_init’:
    drivers/platform/x86/acer-wmi.c:1216:14: warning: ‘devices’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/platform/x86/acer-wmi.c:1193:6: note: ‘devices’ was declared here

GCC is correct. In WMID_set_capabilities() there are now clearly codepaths
that use 'devices' uninitialized. (WMID_set_capabilities() is apparently
inlined in acer_wmi_init().) Previously that couldn't happen. So rework
the code to use the previous logic, but also make sure 'obj' will not be
dereferenced while NULL.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only!

 drivers/platform/x86/acer-wmi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index afed701..0ddac19 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1197,14 +1197,12 @@ static acpi_status WMID_set_capabilities(void)
 		return status;
 
 	obj = (union acpi_object *) out.pointer;
-	if (obj) {
-		if (obj->type == ACPI_TYPE_BUFFER &&
+	if (obj && obj->type == ACPI_TYPE_BUFFER &&
 			(obj->buffer.length == sizeof(u32) ||
 			obj->buffer.length == sizeof(u64))) {
 			devices = *((u32 *) obj->buffer.pointer);
-		} else if (obj->type == ACPI_TYPE_INTEGER) {
+	} else if (obj && obj->type == ACPI_TYPE_INTEGER) {
 			devices = (u32) obj->integer.value;
-		}
 	} else {
 		kfree(out.pointer);
 		return AE_ERROR;
-- 
1.7.11.7

