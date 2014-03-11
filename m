Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaCKIbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:31:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:57190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaCKIbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:31:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] dm: era: use do_div for 64-bit division
Date: Tue, 11 Mar 2014 09:31:33 +0100
Message-ID: <3014967.i7OXqBNQ5E@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BRnHBFzfnWqyniqmYnKKDCi2LHPStSTJJIPs5OqV5q3
 6U3Zd7ESTPDqXbbcHVWaya2o/DQN3DZGYMh9n6Bm5vte8hFfVG
 u3Os1HwTsPNRXMQ0aoY9HnxewV1xNqQZJFafPx3qwIg/3aWgVa
 A0Puea1EvS2x5qrupWr5SSLH+8xxF4fWH7+PPb68KtGAu2TJVs
 XpXlfeRByXkBkLWcKolgTUjWsAf/HLOinirCPdXqHu/d6LeUMD
 Jk0kk2fNYbD83+zcQaTwvps0BtjOIMQTl5ug8HATRGInz7lv5/
 jnUxynqN9oQIl/CKkl+Nzo8V9mmUgIboCY8u9Br1e6E4HDzBwr
 6/x3xr/q5GGx9K/r6utw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 983043be0c1de "dm era: support non power-of-2 blocksize"
introduced the use of sector_div to divide a variable of type
dm_block_t by an integer. This fails on 32-bit machines when
CONFIG_LBDAF is not set, because that assumes that the first
argument is a 32-bit number.

To allow building this driver in all configurations, we either
have to cast the dm_block_t to sector_t or use do_div(), which
always takes a 64-bit argument. This patch uses the second
approach in order to cope with theoretical configurations where
dm_block_t contains a number that does not fit into sector_t.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This currently only occurs in linux-next. Please apply.

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d7bd7b3..3383423 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1123,7 +1123,7 @@ static dm_block_t get_block(struct era *era, struct bio *bio)
 	dm_block_t block_nr = bio->bi_iter.bi_sector;
 
 	if (!block_size_is_power_of_two(era))
-		(void) sector_div(block_nr, era->sectors_per_block);
+		(void) do_div(block_nr, era->sectors_per_block);
 	else
 		block_nr >>= era->sectors_per_block_shift;
 

