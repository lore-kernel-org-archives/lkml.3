Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3EAGKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:10:30 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:12838 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3EAGKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:10:20 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
Date: Wed,  1 May 2013 08:09:20 +0200
Message-Id: <1367388562-2213-4-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367388562-2213-1-git-send-email-phdm@macqel.be>
References: <1367388562-2213-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>

Graft AIX partitions enumeration in partitions/msdos.c

There is already a AIX disks detection logic in msdos.c.  When an
AIX disk has been found, and if configured to, call the aix partitions
recognizer.  This avoids removal of AIX disks protection from msdos.c,
avoids code duplication, and ensures that AIX partitions enumeration
is called before plain msdos partitions enumeration.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

