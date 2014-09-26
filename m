Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaIZKST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:18:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbaIZJqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/142] md/raid10: fix memory leak when reshaping a RAID10.
Date: Fri, 26 Sep 2014 11:45:06 +0200
Message-Id: <9fdaa2cdfcc03ae10c27863d601dccaac184403a.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 867a8b67d5b9..d1cf7734e55e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4419,7 +4419,7 @@ read_more:
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
-	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_flags |= 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt = 0;
 	read_bio->bi_size = 0;
-- 
2.1.0

