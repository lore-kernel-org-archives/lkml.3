Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab3BMXQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761176Ab3BMXQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:16:12 -0500
From: Peter Jones <pjones@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Ensure that the GPT header is at least the size of the structure.
Date: Wed, 13 Feb 2013 18:15:49 -0500
Message-Id: <1360797349-19308-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1360796990-14148-1-git-send-email-pjones@redhat.com>
References: <1360796990-14148-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI 2.3.1D will include a change to the spec language mandating that a
GPT header must be greater than *or equal to* the size of the defined
structure.  While verifying that this would work on Linux, I discovered
that we're not actually checking the minimum bound at all.

The result of this is that when we verify the checksum, it's possible
that on a malformed header (with header_size of 0), we won't actually
verify any data.

(ammended to fix type error in pr_debug())

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 block/partitions/efi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index b62fb88..a7475e7 100644
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
+			sizeof(gpt_header));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
-- 
1.8.1.2

