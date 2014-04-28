Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaD1BbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43112 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbaD1B3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "Li Zefan" <lizefan@huawei.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.256984422@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 41/94] jffs2: remove from wait queue after schedule()
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ead9578443b66ddb3d50ed4f53af8a0c0298ec5 upstream.

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jffs2/nodemgmt.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -128,6 +128,7 @@ int jffs2_reserve_space(struct jffs2_sb_
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
+					remove_wait_queue(&c->erase_wait, &wait);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)

