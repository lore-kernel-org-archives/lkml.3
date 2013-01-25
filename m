Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3AYPv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:51:28 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:23986 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab3AYPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:51:26 -0500
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, akpm@linux-foundation.org, olh@suse.de,
        Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH v2] block/partition/msdos: detect AIX formatted disks even without 55aa
Date: Fri, 25 Jan 2013 16:51:08 +0100
Message-Id: <1359129068-8965-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130125153616.GA27741@rhlx01.hs-esslingen.de>
References: <20130125153616.GA27741@rhlx01.hs-esslingen.de>
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
 block/partitions/msdos.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

v2: add a comment to avoid accidental removal of the tests order
    (suggested by Andreas Mohr <andi@lisas.de>)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 8752a5d..7681cd2 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -455,14 +455,19 @@ int msdos_partition(struct parsed_partitions *state)
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
-	if (!msdos_magic_present(data + 510)) {
+
+	/*
+	 * Note order! (some AIX disks, e.g. unbootable kind,
+	 * have no MSDOS 55aa)
+	 */
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

