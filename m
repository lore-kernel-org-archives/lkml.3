Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3BRMxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:53:41 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25022 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3BRMxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:53:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,687,1355126400"; 
   d="scan'208";a="23673774"
X-IronPort-AV: E=Sophos;i="4.84,687,1355126400"; 
   d="scan'208";a="400787471"
From: "Bu, Yitian" <ybu@qti.qualcomm.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Topic: [PATCH] Fix rq->lock vs logbuf_lock unlock race
Thread-Index: Ac4N1rXhQCDf/Fl/TX2FyJP1BGO59g==
Date: Mon, 18 Feb 2013 12:53:37 +0000
Message-ID: <E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for kernel V3.7.9

>From 8796f4a2175a323aaa49ea8dd0fe68678dd5dccd Mon Sep 17 00:00:00 2001
From: ybu <ybu@qti.qualcomm.com>
Date: Mon, 18 Feb 2013 19:52:01 +0800
Subject: [PATCH] Fix rq->lock vs logbuf_lock unlock race

fix up the fallout from commit 07354eb1a74d1 ("locking printk:
Annotate logbuf_lock as raw")
Release console_sem after unlocking the logbuf_lock avoids some lock
inversion troubles between logbuf_lock and rq->lock.

Change-Id: I782c1d16e0e82bd156699f0f205f19781c4819e0
Signed-off-by: ybu <ybu@qti.qualcomm.com>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f8e0b5a..3a49454 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1356,9 +1356,9 @@ static int console_trylock_for_printk(unsigned int cpu)
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
-- 
1.7.9.5

