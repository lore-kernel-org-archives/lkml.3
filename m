Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab3GOQ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:56:59 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46228 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:56:57 -0400
Subject: [PATCH 09/11] erst: Read and write to the 'compressed' flag of
 pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:26:45 +0530
Message-ID: <20130715165645.1520.72286.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-8256-0000-0000-0000085973BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pstore write, set the section type to CPER_SECTION_TYPE_DMESG_COMPR
if the data is compressed. In pstore read, read the section type and
update the 'compressed' flag accordingly.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 drivers/acpi/apei/erst.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index b0dca8e..62df189 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -956,6 +956,9 @@ static struct pstore_info erst_info = {
 #define CPER_SECTION_TYPE_DMESG						\
 	UUID_LE(0xc197e04e, 0xd545, 0x4a70, 0x9c, 0x17, 0xa5, 0x54,	\
 		0x94, 0x19, 0xeb, 0x12)
+#define CPER_SECTION_TYPE_DMESG_Z					\
+	UUID_LE(0x4f118707, 0x04dd, 0x4055, 0xb5, 0xdd, 0x95, 0x6d,	\
+		0x34, 0xdd, 0xfa, 0xc6)
 #define CPER_SECTION_TYPE_MCE						\
 	UUID_LE(0xfe08ffbe, 0x95e4, 0x4be7, 0xbc, 0x73, 0x40, 0x96,	\
 		0x04, 0x4a, 0x38, 0xfc)
@@ -1034,7 +1037,12 @@ skip:
 	}
 	memcpy(*buf, rcd->data, len - sizeof(*rcd));
 	*id = record_id;
+	*compressed = false;
 	if (uuid_le_cmp(rcd->sec_hdr.section_type,
+			CPER_SECTION_TYPE_DMESG_Z) == 0) {
+		*type = PSTORE_TYPE_DMESG;
+		*compressed = true;
+	} else if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			CPER_SECTION_TYPE_DMESG) == 0)
 		*type = PSTORE_TYPE_DMESG;
 	else if (uuid_le_cmp(rcd->sec_hdr.section_type,
@@ -1085,7 +1093,10 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 	rcd->sec_hdr.flags = CPER_SEC_PRIMARY;
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-		rcd->sec_hdr.section_type = CPER_SECTION_TYPE_DMESG;
+		if (compressed)
+			rcd->sec_hdr.section_type = CPER_SECTION_TYPE_DMESG_Z;
+		else
+			rcd->sec_hdr.section_type = CPER_SECTION_TYPE_DMESG;
 		break;
 	case PSTORE_TYPE_MCE:
 		rcd->sec_hdr.section_type = CPER_SECTION_TYPE_MCE;

