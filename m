Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaKYUOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:14:45 -0500
Received: from st11p01mm-asmtpout002.mac.com ([17.172.204.237]:62619 "EHLO
	st11p01mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaKYUOo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:14:44 -0500
X-Greylist: delayed 3607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2014 15:14:43 EST
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-25_05:2014-11-25,2014-11-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=1 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=7.0.1-1408290000 definitions=main-1411250126
From: Louis Langholtz <lou_langholtz@me.com>
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Subject: PATCH: avoid possible integer overflow with cmp_range() in
 kernel/range.c
Date: Tue, 25 Nov 2014 12:14:15 -0700
Message-id: <6F1FC669-B4AE-4593-A1EE-6F72C38D117B@me.com>
Cc: yinghai@kernel.org, hpa@linux.intel.com
To: linux-kernel@vger.kernel.org
MIME-version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmp_range function (in kernel/range.c) is returning the difference between two s64 values (actually coming from u64 typed variables) in an int which can overflow (depending on the size of int). This function is used as a compare function for linux's sort function (in lib/sort.c). Linux's sort function however only cares if the compare function returns a value less than, equal to, or greater than zero.

As sort doesn't need the actual difference, this overflow potential is avoided with the following patch (against linux kernel 3.18 code from Linus's git repo and commit 0541881502a1276149889fe468662ff6a8fc8f6d):

commit 641362d32fef0cfd7b12e1821c1139d75dd23330
Author: Lou Langholtz <lou_langholtz@me.com>
Date:   Mon Nov 24 09:31:01 2014 -0700

    Avoid overflow possibility

diff --git a/kernel/range.c b/kernel/range.c
index 322ea8e..86337e2 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -113,12 +113,17 @@ static int cmp_range(const void *x1, const void *x2)
 {
        const struct range *r1 = x1;
        const struct range *r2 = x2;
-       s64 start1, start2;
+       u64 start1, start2;
 
        start1 = r1->start;
        start2 = r2->start;
 
-       return start1 - start2;
+       /* avoid any overflow possibilities and don't just return start1 - start2 */
+       if (start1 > start2)
+               return 1;
+       if (start2 > start1)
+               return -1;
+       return 0;
 }
 
 int clean_sort_range(struct range *range, int az)

