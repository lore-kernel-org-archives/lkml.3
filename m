Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbaICX2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:28:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632AbaICWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simone Gotti <simone.gotti@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH 3.14 50/88] ACPI / PCI: Fix sysfs acpi_index and label errors
Date: Wed,  3 Sep 2014 15:05:24 -0700
Message-Id: <20140903220517.464290181@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simone Gotti <simone.gotti@gmail.com>

commit dcfa9be83866e28fcb8b7e22b4eeb4ba63bd3174 upstream.

Fix errors in handling "device label" _DSM return values.

If _DSM returns a Unicode string, the ACPI type is ACPI_TYPE_BUFFER, not
ACPI_TYPE_STRING.  Fix dsm_label_utf16s_to_utf8s() to convert UTF-16 from
acpi_object->buffer instead of acpi_object->string.

Prior to v3.14, we accepted Unicode labels (ACPI_TYPE_BUFFER return
values).  But after 1d0fcef73283, we accepted only ASCII (ACPI_TYPE_STRING)
(and we incorrectly tried to convert those ASCII labels from UTF-16 to
UTF-8).

Rejecting Unicode labels made us return -EPERM when reading sysfs
"acpi_index" or "label" files, which in turn caused on-board network
interfaces on a Dell PowerEdge E420 to be renamed (by udev net_id internal)
from eno1/eno2 to enp2s0f0/enp2s0f1.

Fix this by accepting either ACPI_TYPE_STRING (and treating it as ASCII) or
ACPI_TYPE_BUFFER (and converting from UTF-16 to UTF-8).

[bhelgaas: changelog]
Fixes: 1d0fcef73283 ("ACPI / PCI: replace open-coded _DSM code with helper functions")
Signed-off-by: Simone Gotti <simone.gotti@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-label.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -168,8 +168,8 @@ enum acpi_attr_enum {
 static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 {
 	int len;
-	len = utf16s_to_utf8s((const wchar_t *)obj->string.pointer,
-			      obj->string.length,
+	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
+			      obj->buffer.length,
 			      UTF16_LITTLE_ENDIAN,
 			      buf, PAGE_SIZE);
 	buf[len] = '\n';
@@ -194,16 +194,22 @@ dsm_get_label(struct device *dev, char *
 	tmp = obj->package.elements;
 	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2 &&
 	    tmp[0].type == ACPI_TYPE_INTEGER &&
-	    tmp[1].type == ACPI_TYPE_STRING) {
+	    (tmp[1].type == ACPI_TYPE_STRING ||
+	     tmp[1].type == ACPI_TYPE_BUFFER)) {
 		/*
 		 * The second string element is optional even when
 		 * this _DSM is implemented; when not implemented,
 		 * this entry must return a null string.
 		 */
-		if (attr == ACPI_ATTR_INDEX_SHOW)
+		if (attr == ACPI_ATTR_INDEX_SHOW) {
 			scnprintf(buf, PAGE_SIZE, "%llu\n", tmp->integer.value);
-		else if (attr == ACPI_ATTR_LABEL_SHOW)
-			dsm_label_utf16s_to_utf8s(tmp + 1, buf);
+		} else if (attr == ACPI_ATTR_LABEL_SHOW) {
+			if (tmp[1].type == ACPI_TYPE_STRING)
+				scnprintf(buf, PAGE_SIZE, "%s\n",
+					  tmp[1].string.pointer);
+			else if (tmp[1].type == ACPI_TYPE_BUFFER)
+				dsm_label_utf16s_to_utf8s(tmp + 1, buf);
+		}
 		len = strlen(buf) > 0 ? strlen(buf) : -1;
 	}
 


