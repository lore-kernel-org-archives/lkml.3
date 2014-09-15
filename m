Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaIOUQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbaIOTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:46:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        mdraid.pkoch@dfgh.net (Peter Koch), NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 086/114] md/raid10: fix memory leak when reshaping a RAID10.
Date: Mon, 15 Sep 2014 12:26:26 -0700
Message-Id: <20140915192644.118077738@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4410,7 +4410,7 @@ read_more:
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
-	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_flags |= 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt = 0;
 	read_bio->bi_iter.bi_size = 0;


