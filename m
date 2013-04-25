Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3DYVSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:18:30 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:27823 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab3DYVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:18:26 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
Date: Thu, 25 Apr 2013 23:10:27 +0200
Message-Id: <1366924229-21569-4-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366924229-21569-1-git-send-email-phdm@macqel.be>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graft AIX partitions enumeration in partitions/msdos.c

There is already a AIX disks detection logic in msdos.c.  When an
AIX disk has been found, and if configured to, call the aix partitions
recognizer.  This avoids removal of AIX disks protection from msdos.c,
avoids code duplication, and ensures that AIX partitions enumeration
is called before plain msdos partitions enumeration.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/partitions/msdos.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 9bf19e6..9123f25 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -23,6 +23,7 @@
 #include "check.h"
 #include "msdos.h"
 #include "efi.h"
+#include "aix.h"
 
 /*
  * Many architectures don't like unaligned accesses, while
@@ -462,8 +463,12 @@ int msdos_partition(struct parsed_partitions *state)
 	 */
 	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
+#ifdef CONFIG_AIX_PARTITION
+		return aix_partition(state);
+#else
 		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
+#endif
 	}
 
 	if (!msdos_magic_present(data + 510)) {
-- 
1.7.1

