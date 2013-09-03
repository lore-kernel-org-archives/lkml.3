Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab3ICFBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:01:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39346 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3ICFBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:01:51 -0400
Message-ID: <1378184510.3243.30.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/8] partitions/efi: use lba-aware partition records
From: Davidlohr Bueso <davidlohr@hp.com>
To: Karel Zak <kzak@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Peter Jones <pjones@redhat.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Date: Mon, 02 Sep 2013 22:01:50 -0700
In-Reply-To: <20130902101042.GB30710@x2.net.home>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
	 <1375766476-4204-2-git-send-email-davidlohr@hp.com>
	 <20130902101042.GB30710@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 12:10 +0200, Karel Zak wrote:
> On Mon, Aug 05, 2013 at 10:21:09PM -0700, Davidlohr Bueso wrote:
> >  
> > +typedef struct _gpt_record {
> > +        u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
> > +        u8      start_head;     /* unused by EFI, pt start in CHS */
> > +        u8      start_sector;   /* unused by EFI, pt start in CHS */
> > +        u8      start_track;
> > +        u8      os_type;        /* EFI and legacy non-EFI OS types */
> > +        u8      end_head;       /* unused by EFI, pt end in CHS */
> > +        u8      end_sector;     /* unused by EFI, pt end in CHS */
> > +        u8      end_track;      /* unused by EFI, pt end in CHS */
> > +        __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
> > +        __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
> > +} __attribute__ ((packed)) gpt_record;
> > +
> 
>  Maybe it would be better to rename this struct to "gpt_mbr_record" to
>  make it more obvious.

Yes, good idea. I've added the patch below.

8<------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] partitions/efi: rename gpt_record structure

Since the gpt_record structure is an MBR-specific
type, rename it to gpt_mbr_record for obvious
reading.

Suggested-by: Karel Zak <kzak@redhat.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 2 +-
 block/partitions/efi.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 8e6d77e..9a4eba7 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -152,7 +152,7 @@ static u64 last_lba(struct block_device *bdev)
 		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
-static inline int pmbr_part_valid(gpt_record *part)
+static inline int pmbr_part_valid(gpt_mbr_record *part)
 {
         if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
                 goto invalid;
diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index 9ab8ee9..54b2687 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -104,7 +104,7 @@ typedef struct _gpt_entry {
 	efi_char16_t partition_name[72 / sizeof (efi_char16_t)];
 } __attribute__ ((packed)) gpt_entry;
 
-typedef struct _gpt_record {
+typedef struct _gpt_mbr_record {
         u8      boot_indicator; /* unused by EFI, set to 0x80 for bootable */
         u8      start_head;     /* unused by EFI, pt start in CHS */
         u8      start_sector;   /* unused by EFI, pt start in CHS */
@@ -115,14 +115,14 @@ typedef struct _gpt_record {
         u8      end_track;      /* unused by EFI, pt end in CHS */
         __le32  starting_lba;   /* used by EFI - start addr of the on disk pt */
         __le32  size_in_lba;    /* used by EFI - size of pt in LBA */
-} __attribute__ ((packed)) gpt_record;
+} __attribute__ ((packed)) gpt_mbr_record;
 
 
 typedef struct _legacy_mbr {
 	u8 boot_code[440];
 	__le32 unique_mbr_signature;
 	__le16 unknown;
-	gpt_record partition_record[4];
+	gpt_mbr_record partition_record[4];
 	__le16 signature;
 } __attribute__ ((packed)) legacy_mbr;
 
-- 
1.7.11.7



