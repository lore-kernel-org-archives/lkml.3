Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3HFF3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:29:38 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46914 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3HFF2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:28:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 1/8] partitions/efi: use lba-aware partition records
Date: Mon,  5 Aug 2013 22:21:09 -0700
Message-Id: <1375766476-4204-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's GPT implementation currently uses the generic
'struct partition' type for dealing with legacy MBR partition
records. While this is is useful for disklabels that we designed
for CHS addressing, such as msdos, it doesn't adapt well to newer
standards that use LBA instead, such as GUID partition tables.
Furthermore, these generic partition structures do not have all the
required fields to properly follow the UEFI specs.

While a CHS address can be translated to LBA, it's much simpler and
cleaner to just replace the partition type. This patch adds a new
'gpt_record' type that is fully compliant with EFI and will allow,
in the next patches, to add more checks to properly verify a protective
MBR, which is paramount to probing a device that makes use of GPT.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c |  7 +++----
 block/partitions/efi.h | 16 +++++++++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index c85fc89..3ebd3d8 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -149,11 +149,10 @@ static u64 last_lba(struct block_device *bdev)
 		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
-static inline int
-pmbr_part_valid(struct partition *part)
+static inline int pmbr_part_valid(gpt_record *part)
 {
-        if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sect) == 1UL)
+        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
+            le32_to_cpu(part->start_sector) == 1UL)
                 return 1;
         return 0;
 }
diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index b69ab72..46cf1a4 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -101,11 +101,25 @@ typedef struct _gpt_entry {
 	efi_char16_t partition_name[72 / sizeof (efi_char16_t)];
 } __attribute__ ((packed)) gpt_entry;
 
+typedef struct _gpt_record {
+        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
+        u8      start_head;     /* unused by EFI, pt start in CHS */
+        u8      start_sector;   /* unused by EFI, pt start in CHS */
+        u8      start_track;
+        u8      os_type;        /* EFI and legacy non-EFI OS types */
+        u8      end_head;       /* unused by EFI, pt end in CHS */
+        u8      end_sector;     /* unused by EFI, pt end in CHS */
+        u8      end_track;      /* unused by EFI, pt end in CHS */
+        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
+        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
+} __attribute__ ((packed)) gpt_record;
+
+
 typedef struct _legacy_mbr {
 	u8 boot_code[440];
 	__le32 unique_mbr_signature;
 	__le16 unknown;
-	struct partition partition_record[4];
+	gpt_record partition_record[4];
 	__le16 signature;
 } __attribute__ ((packed)) legacy_mbr;
 
-- 
1.7.11.7

