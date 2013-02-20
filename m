Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935471Ab3BTOhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:37:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934525Ab3BTOhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:37:19 -0500
From: Peter Jones <pjones@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] block/partitions/efi.c: ensure that the GPT header is at least the size of the structure.
Date: Wed, 20 Feb 2013 09:37:01 -0500
Message-Id: <1361371021-583-2-git-send-email-pjones@redhat.com>
In-Reply-To: <1361371021-583-1-git-send-email-pjones@redhat.com>
References: <20130220173414.fa4886355efd8f85d0d349f4@canb.auug.org.au>
 <1361371021-583-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI 2.3.1D will include a change to the spec language mandating that a
GPT header must be greater than *or equal to* the size of the defined
structure.  While verifying that this would work on Linux, I discovered
that we're not actually checking the minimum bound at all.

The result of this is that when we verify the checksum, it's possible that
on a malformed header (with header_size of 0), we won't actually verify
any data.

Signed-off-by: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 block/partitions/efi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index b62fb88..62e05cf 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -310,15 +310,23 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		goto fail;
 	}
 
-	/* Check the GUID Partition Table header size */
+	/* Check the GUID Partition Table header size is too big */
 	if (le32_to_cpu((*gpt)->header_size) >
 			bdev_logical_block_size(state->bdev)) {
-		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
+		pr_debug("GUID Partition Table Header size is too large: %u > %u\n",
 			le32_to_cpu((*gpt)->header_size),
 			bdev_logical_block_size(state->bdev));
 		goto fail;
 	}
 
+	/* Check the GUID Partition Table header size is too small */
+	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
+		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
+			le32_to_cpu((*gpt)->header_size),
+			(unsigned long)sizeof(gpt_header));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
-- 
1.8.1.2

