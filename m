Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaEIVjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:39:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62865 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571AbaEIVjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:39:08 -0400
Date: Fri, 9 May 2014 15:39:07 -0600
From: Jens Axboe <axboe@fb.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>
Subject: [PATCH] Avoid always dirtying mapping->flags on O_DIRECT
Message-ID: <20140509213907.GA20698@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-09_08:2014-05-09,2014-05-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.76840789076505e-14 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997696947966296
 urlsuspect_oldscore=0.997696947966296 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405090282
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In some testing I ran today, we end up spending 40% of the time in
filemap_check_errors(). That smells fishy. Looking further, this is
basically what happens:

blkdev_aio_read()
    generic_file_aio_read()
        filemap_write_and_wait_range()
            if (!mapping->nr_pages)
                filemap_check_errors()

and filemap_check_errors() always attempts two test_and_clear_bit() on
the mapping flags, thus dirtying it for every single invocation. The
patch below tests each of these bits before clearing them, avoiding this
issue. In my test case (4-socket box), performance went from 1.7M IOPS
to 4.0M IOPS.

Signed-off-by: Jens Axboe <axboe@fb.com>

diff --git a/mm/filemap.c b/mm/filemap.c
index 000a220..088358c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -257,9 +257,11 @@ static int filemap_check_errors(struct address_space *mapping)
 {
 	int ret = 0;
 	/* Check for outstanding write errors */
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+	if (test_bit(AS_ENOSPC, &mapping->flags) &&
+	    test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+	if (test_bit(AS_EIO, &mapping->flags) &&
+	    test_and_clear_bit(AS_EIO, &mapping->flags))
 		ret = -EIO;
 	return ret;
 }


-- 
Jens Axboe

