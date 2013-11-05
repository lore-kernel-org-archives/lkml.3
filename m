Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3KET7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:59:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38633 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3KET7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:59:51 -0500
Message-ID: <52794E22.5030807@kernel.dk>
Date: Tue, 05 Nov 2013 12:59:30 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Tushar Behera <tushar.behera@linaro.org>
CC: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Boot failure on Arndale with next-20131105
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com> <1451170.jb5zbRXgpt@amdc1227>
In-Reply-To: <1451170.jb5zbRXgpt@amdc1227>
Content-Type: multipart/mixed;
 boundary="------------020109080607070201030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109080607070201030409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/05/2013 09:42 AM, Tomasz Figa wrote:
> Hi,
> 
> On Tuesday 05 of November 2013 17:19:00 Tushar Behera wrote:
>> Hi,
>>
>> We are having a boot-time kernel panic on Samsung's Exynos5250-based
>> Arndale board with next-20131105. Bisect points to following commit.
>>
>> <<<
>> commit febca1baea1cfe2d7a0271385d89b03d5fb34f94
>> Author: Chris Mason <chris.mason@fusionio.com>
>> Date:   Thu Oct 31 13:32:42 2013 -0600
>>
>>     block: setup bi_vcnt on clones
>>
>>     commit 9fc6286f347d changed the cloning code to make clones cheaper for
>>     the case where we don't need to clone the iovec array.  But,
>>     the new clone needs the bi_vnct from the original.
>>
>>     Signed-off-by: Chris Mason <chris.mason@fusionio.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>
>> Reverting above commit, Arndale is able to boot again.
> 
> I can confirm exactly the same behavior on Exynos 4210-based Trats board,
> with exactly the same bisection results.

Can either (or both) of you try this?

-- 
Jens Axboe


--------------020109080607070201030409
Content-Type: text/x-patch;
 name="dm-clone.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dm-clone.patch"

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8e6174c..a1177e1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1123,8 +1123,13 @@ struct clone_info {
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
 {
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_iter.bi_size = to_bytes(len);
+	if (len) {
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_iter.bi_size = to_bytes(len);
+	} else {
+		bio->bi_iter.bi_size = 0;
+		bio->bi_vcnt = 0;
+	}
 }
 
 /*
@@ -1178,8 +1183,7 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
 	 __bio_clone(clone, ci->bio);
-	if (len)
-		bio_setup_sector(clone, ci->sector, len);
+	bio_setup_sector(clone, ci->sector, len);
 
 	__map_bio(tio);
 }

--------------020109080607070201030409--
