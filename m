Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162376Ab3LFXnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:43:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab3LFXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 152/152] libertas: potential oops in debugfs
Date: Fri,  6 Dec 2013 15:11:16 -0800
Message-Id: <1386371476-2477-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a497e47d4aec37aaf8f13509f3ef3d1f6a717d88 upstream.

If we do a zero size allocation then it will oops.  Also we can't be
sure the user passes us a NUL terminated string so I've added a
terminator.

This code can only be triggered by root.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ kamal: 3.8 stable for CVE-2013-6378 ]
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/libertas/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 668dd27..cc6a0a5 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -913,7 +913,10 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 	char *p2;
 	struct debug_data *d = f->private_data;
 
-	pdata = kmalloc(cnt, GFP_KERNEL);
+	if (cnt == 0)
+		return 0;
+
+	pdata = kmalloc(cnt + 1, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
@@ -922,6 +925,7 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 		kfree(pdata);
 		return 0;
 	}
+	pdata[cnt] = '\0';
 
 	p0 = pdata;
 	for (i = 0; i < num_of_items; i++) {
-- 
1.8.3.2

