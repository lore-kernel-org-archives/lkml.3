Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaJYBv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:51:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaJYBv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:51:28 -0400
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, axboe@fb.com
Subject: Re: Slow dc3dd in 3.18 on x86
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <544AA317.8070609@gmail.com> <yq1r3xxtfa7.fsf@sermon.lab.mkp.net>
	<544AEEF1.30506@gmail.com>
Date: Fri, 24 Oct 2014 21:51:12 -0400
In-Reply-To: <544AEEF1.30506@gmail.com> (Michael L. Semon's message of "Fri,
	24 Oct 2014 20:29:37 -0400")
Message-ID: <yq1wq7osyr3.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michael" == Michael L Semon <mlsemon35@gmail.com> writes:

Michael> There was nothing regarding integrity in /sys/block/sda.  I was
Michael> under the impression that both bio integrity and T10 checksums
Michael> require hardware support from good hardware, so the config
Michael> items have always been shut off. 

That's correct. But I see what's going on.

Please try this:

commit 8d331952d2cd341d5c0e64eee961f78f6eb4b968
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Fri Oct 24 21:39:12 2014 -0400

    block: Fix merge logic when CONFIG_BLK_DEV_INTEGRITY is not defined

    Commit 4eaf99beadce switched to returning bool and as a result
    reversed the logic of the integrity merge checks.  However, the
    empty stubs used when the block integrity code is compiled out were
    still returning 0. Make these stubs return "true".

    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9fbf4d3196ed..7442c6b9187e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1590,13 +1590,13 @@ static inline bool blk_integrity_merge_rq(struct request_queue *rq,
 					  struct request *r1,
 					  struct request *r2)
 {
-	return 0;
+	return true;
 }
 static inline bool blk_integrity_merge_bio(struct request_queue *rq,
 					   struct request *r,
 					   struct bio *b)
 {
-	return 0;
+	return true;
 }
 static inline bool blk_integrity_is_initialized(struct gendisk *g)
 {

