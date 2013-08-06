Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3HFFWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:22:01 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:7157 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3HFFVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:21:42 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 6/8] partitions/efi: compare first and last usable LBAs
Date: Mon,  5 Aug 2013 22:21:14 -0700
Message-Id: <1375766476-4204-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When verifying GPT header integrity, make sure that
first usable LBA is smaller than last usable LBA.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index ab6cd08..9a81c3b 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -409,7 +409,12 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 			 (unsigned long long)lastlba);
 		goto fail;
 	}
-
+	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
+		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
+			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
+		goto fail;
+	}
 	/* Check that sizeof_partition_entry has the correct value */
 	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
 		pr_debug("GUID Partitition Entry Size check failed.\n");
-- 
1.7.11.7

