Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JJX3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:29:02 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:54700 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3JJX3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:29:00 -0400
From: Doug Anderson <dianders@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Doug Anderson <dianders@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] partitions/efi: treat size mismatch as a warning, not an error
Date: Thu, 10 Oct 2013 16:28:22 -0700
Message-Id: <1381447702-6240-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131009232642.GA12776@jtriplet-mobl1>
References: <20131009232642.GA12776@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (27a7c64 partitions/efi: account for pmbr size in lba) we started
treating bad sizes in lba field of the partition that has the 0xEE
(GPT protective) as errors.  However, we may run into these "bad
sizes" in the real world if someone uses dd to copy an image from a
smaller disk to a bigger disk.  Since this case used to work (even
without using force_gpt), keep it working and treat the size mismatch
as a warning instead of an error.

Reported-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 block/partitions/efi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 1eb09ee..ac23dc1 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -222,11 +222,15 @@ check_hybrid:
 	 * the disk size.
 	 *
 	 * Hybrid MBRs do not necessarily comply with this.
+	 *
+	 * Consider a bad value here to be a warning to support dd-ing
+	 * an image from a smaller disk to a bigger disk.
 	 */
 	if (ret == GPT_MBR_PROTECTIVE) {
 		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
 		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
-			ret = 0;
+			pr_warn("%s: mbr size mismatch (%u != %u)\n", __func__,
+				sz, (uint32_t)((uint32_t) total_sectors - 1));
 	}
 done:
 	return ret;
-- 
1.8.4

