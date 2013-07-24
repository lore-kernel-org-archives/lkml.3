Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3GXIjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3GXIjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:39:13 -0400
From: Francesco Fusco <ffusco@redhat.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] sysctl: range checking in do_proc_dointvec_ms_jiffies_conv
Date: Wed, 24 Jul 2013 10:39:07 +0200
Message-Id: <de72e4265ab874b70b127011bb1ef8c2d27bfe63.1374654531.git.ffusco@redhat.com>
In-Reply-To: <cover.1374654531.git.ffusco@redhat.com>
References: <cover.1374654531.git.ffusco@redhat.com>
In-Reply-To: <cover.1374654531.git.ffusco@redhat.com>
References: <cover.1374654531.git.ffusco@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When (integer) sysctl values are expressed in ms and have to be
represented internally as jiffies. The msecs_to_jiffies function
returns an unsigned long, which gets assigned to the integer.
This patch prevents the value to be assigned if bigger than
INT_MAX, done in a similar way as in cba9f3 ("Range checking in
do_proc_dointvec_(userhz_)jiffies_conv").

Signed-off-by: Francesco Fusco <ffusco@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
---
 kernel/sysctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ac09d98..00813e5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2346,7 +2346,11 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 					    int write, void *data)
 {
 	if (write) {
-		*valp = msecs_to_jiffies(*negp ? -*lvalp : *lvalp);
+		unsigned long jif = 0;
+		jif =  msecs_to_jiffies(*negp ? -*lvalp : *lvalp);
+		if (jif > INT_MAX)
+			return 1;
+		*valp = (int)jif;
 	} else {
 		int val = *valp;
 		unsigned long lval;
-- 
1.8.3.1

