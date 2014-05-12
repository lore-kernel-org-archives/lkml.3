Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaELCJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:09:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34512 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaELBmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:17 -0400
Message-Id: <20140512003205.563383127@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 118/143] libertas: potential oops in debugfs
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

If we do a zero size allocation then it will oops.  Also we can't be
sure the user passes us a NUL terminated string so I've added a
terminator.

This code can only be triggered by root.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
(cherry picked from commit a497e47d4aec37aaf8f13509f3ef3d1f6a717d88)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/wireless/libertas/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 893a55c..89532a6 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -925,7 +925,10 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 	char *p2;
 	struct debug_data *d = (struct debug_data *)f->private_data;
 
-	pdata = kmalloc(cnt, GFP_KERNEL);
+	if (cnt == 0)
+		return 0;
+
+	pdata = kmalloc(cnt + 1, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
@@ -934,6 +937,7 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 		kfree(pdata);
 		return 0;
 	}
+	pdata[cnt] = '\0';
 
 	p0 = pdata;
 	for (i = 0; i < num_of_items; i++) {
-- 
1.7.12.2.21.g234cd45.dirty



