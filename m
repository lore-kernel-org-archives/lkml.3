Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbaLBUUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:20:45 -0500
Received: from st11p01mm-asmtp002.mac.com ([17.172.204.237]:47842 "EHLO
	st11p01mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933029AbaLBUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:20:44 -0500
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-02_08:2014-12-02,2014-12-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=7.0.1-1408290000 definitions=main-1412020173
From: Louis Langholtz <lou_langholtz@me.com>
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Subject: [PATCH 3.18] kernel: avoid overflow in cmp_range()
Date: Tue, 02 Dec 2014 13:20:39 -0700
Message-id: <108D4C89-3DB3-4042-9549-461BDB5E4302@me.com>
Cc: torvalds@linux-foundation.org
To: linux-kernel@vger.kernel.org, yinghai@kernel.org, hpa@linux.intel.com
MIME-version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid overflow possibility.

Signed-off-by: Louis Langholtz <lou_langholtz@me.com>
---
diff --git a/kernel/range.c b/kernel/range.c
index 322ea8e..06d9ee7 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -113,12 +113,16 @@ static int cmp_range(const void *x1, const void *x2)
{
       const struct range *r1 = x1;
       const struct range *r2 = x2;
-       s64 start1, start2;
+       u64 start1, start2;

       start1 = r1->start;
       start2 = r2->start;

-       return start1 - start2;
+       if (start1 < start2)
+               return -1;
+       if (start1 > start2)
+               return 1;
+       return 0;
}

int clean_sort_range(struct range *range, int az)
