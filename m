Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbANVbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:31:48 -0500
Received: from st11p01mm-asmtpout002.mac.com ([17.172.204.237]:53169 "EHLO
	st11p01mm-asmtp002.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbbANVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:31:47 -0500
X-Greylist: delayed 3610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 16:31:46 EST
From: Louis Langholtz <lou_langholtz@me.com>
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Subject: [PATCH] kernel: avoid overflow in cmp_range
Date: Wed, 14 Jan 2015 13:31:18 -0700
Message-id: <3E2D3190-D01C-4BCE-8E6F-B2BB9BC29984@me.com>
Cc: torvalds@linux-foundation.org
To: linux-kernel@vger.kernel.org, yinghai@kernel.org, hpa@linux.intel.com
MIME-version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_05:2015-01-14,2015-01-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=7.0.1-1412080000 definitions=main-1501140202
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
