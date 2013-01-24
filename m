Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3AXDmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:42:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44206 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3AXD3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabrizio Narni <shibotto@gmail.com>, <mus.svz@gmail.com>,
        Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 22/74] sony-laptop: fix SNC buffer calls when SN06 returns Integers
Date: Thu, 24 Jan 2013 01:26:34 -0200
Message-Id: <1358998046-613-23-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Dongili <malattia@linux.it>

commit dcbeec264d73b7228ffdfe767eab69b2353099b1 upstream.

SN06 in some cases returns an Integer instead of a buffer. While the
code handling the return value was trying to cope with the difference,
the memcpy call was not making any difference between the two types of
acpi_object union. This regression was introduced in 3.5.
While there also rework the return value logic to improve readability.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48671
Cc: Fabrizio Narni <shibotto@gmail.com>
Cc: <mus.svz@gmail.com>
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/platform/x86/sony-laptop.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index d456ff0..d4a6172 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -784,28 +784,29 @@ static int sony_nc_int_call(acpi_handle handle, char *name, int *value,
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
+	int ret = 0;
 	size_t len = len;
 	union acpi_object *object = __call_snc_method(handle, name, value);
 
 	if (!object)
 		return -EINVAL;
 
-	if (object->type == ACPI_TYPE_BUFFER)
+	if (object->type == ACPI_TYPE_BUFFER) {
 		len = MIN(buflen, object->buffer.length);
+		memcpy(buffer, object->buffer.pointer, len);
 
-	else if (object->type == ACPI_TYPE_INTEGER)
+	} else if (object->type == ACPI_TYPE_INTEGER) {
 		len = MIN(buflen, sizeof(object->integer.value));
+		memcpy(buffer, &object->integer.value, len);
 
-	else {
+	} else {
 		pr_warn("Invalid acpi_object: expected 0x%x got 0x%x\n",
 				ACPI_TYPE_BUFFER, object->type);
-		kfree(object);
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	memcpy(buffer, object->buffer.pointer, len);
 	kfree(object);
-	return 0;
+	return ret;
 }
 
 struct sony_nc_handles {
-- 
1.7.9.5

