Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaI3WEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:04:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaI3Vg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 026/103] md/raid10: fix memory leak when reshaping a RAID10.
Date: Tue, 30 Sep 2014 14:30:31 -0700
Message-Id: <1412112708-27356-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit ce0b0a46955d1bb389684a2605dbcaa990ba0154 upstream.

raid10 reshape clears unwanted bits from a bio->bi_flags using
a method which, while clumsy, worked until 3.10 when BIO_OWNS_VEC
was added.
Since then it clears that bit but shouldn't.  This results in a
memory leak.

So change to used the approved method of clearing unwanted bits.

As this causes a memory leak which can consume all of memory
the fix is suitable for -stable.

Fixes: a38352e0ac02dbbd4fa464dc22d1352b5fbd06fd
Reported-by: mdraid.pkoch@dfgh.net (Peter Koch)
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 496a46e..4800e56 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4421,7 +4421,7 @@ read_more:
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
-	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_flags |= 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt = 0;
 	read_bio->bi_size = 0;
-- 
1.9.1

