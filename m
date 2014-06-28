Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaF1STW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:19:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbaF1Rvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weijie Yang <weijie.yang@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 030/139] zram: correct offset usage in zram_bio_discard
Date: Sat, 28 Jun 2014 10:46:31 -0700
Message-Id: <20140628174606.793949221@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit 38515c73398a4c58059ecf1087e844561b58ee0f upstream.

We want to skip the physical block(PAGE_SIZE) which is partially covered
by the discard bio, so we check the remaining size and subtract it if
there is a need to goto the next physical block.

The current offset usage in zram_bio_discard is incorrect, it will cause
its upper filesystem breakdown.  Consider the following scenario:

On some architecture or config, PAGE_SIZE is 64K for example, filesystem
is set up on zram disk without PAGE_SIZE aligned, a discard bio leads to a
offset = 4K and size=72K, normally, it should not really discard any
physical block as it partially cover two physical blocks.  However, with
the current offset usage, it will discard the second physical block and
free its memory, which will cause filesystem breakdown.

This patch corrects the offset usage in zram_bio_discard.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram
 	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
-		if (n < offset)
+		if (n <= (PAGE_SIZE - offset))
 			return;
 
-		n -= offset;
+		n -= (PAGE_SIZE - offset);
 		index++;
 	}
 


