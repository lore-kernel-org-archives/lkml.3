Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080AbaDJDWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934582AbaDJDVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        ybu <ybu@qti.qualcomm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 004/134] printk: Fix rq->lock vs logbuf_lock unlock lock inversion
Date: Wed,  9 Apr 2014 20:22:00 -0700
Message-Id: <20140410032300.218633795@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Bu, Yitian" <ybu@qti.qualcomm.com>

commit dbda92d16f8655044e082930e4e9d244b87fde77 upstream.

commit 07354eb1a74d1 ("locking printk: Annotate logbuf_lock as raw")
reintroduced a lock inversion problem which was fixed in commit
0b5e1c5255 ("printk: Release console_sem after logbuf_lock"). This
happened probably when fixing up patch rejects.

Restore the ordering and unlock logbuf_lock before releasing
console_sem.

Signed-off-by: ybu <ybu@qti.qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/E807E903FE6CBE4D95E420FBFCC273B827413C@nasanexd01h.na.qualcomm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -822,9 +822,9 @@ static int console_trylock_for_printk(un
 		}
 	}
 	printk_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 static const char recursion_bug_msg [] =


