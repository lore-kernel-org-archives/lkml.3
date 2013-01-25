Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3AYPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:06:18 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:10117 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3AYPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:06:16 -0500
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, akpm@linux-foundation.org, olh@suse.de,
        Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] block/partition/msdos: detect AIX formatted disks even without 55aa
Date: Fri, 25 Jan 2013 16:05:43 +0100
Message-Id: <1359126343-3525-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIX formatted disks do not always have the MSDOS 55aa signature.
This happens e.g. for unbootable AIX disks.

Up to now, such disks were not recognized as AIX disks, because of the
missing 55aa.  Fix that by inverting the two tests.  Let's first
check for the AIX magic strings, and only if that fails check for
the MSDOS magic word.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 block/partitions/msdos.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 8752a5d..4b31ed7 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -455,14 +455,15 @@ int msdos_partition(struct parsed_partitions *state)
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
-	if (!msdos_magic_present(data + 510)) {
+
+	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
+		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
 	}
 
-	if (aix_magic_present(state, data)) {
+	if (!msdos_magic_present(data + 510)) {
 		put_dev_sector(sect);
-		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
 	}
 
-- 
1.7.1

