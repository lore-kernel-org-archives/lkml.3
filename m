Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966463Ab3E2OKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:10:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45145 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966359Ab3E2N6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:43 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, fuse-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH v6, part4 09/41] mm: use totalram_pages instead of num_physpages at runtime
Date: Wed, 29 May 2013 21:57:27 +0800
Message-Id: <1369835879-23553-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global variable num_physpages is scheduled to be removed, so use
totalram_pages instead of num_physpages at runtime.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: fuse-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 fs/fuse/inode.c          | 2 +-
 kernel/power/snapshot.c  | 4 ++--
 net/ipv4/inet_fragment.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 6201f81..c2d44ef 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -785,7 +785,7 @@ static const struct super_operations fuse_super_operations = {
 static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
-		*limit = ((num_physpages << PAGE_SHIFT) >> 13) /
+		*limit = ((totalram_pages << PAGE_SHIFT) >> 13) /
 			 sizeof(struct fuse_req);
 
 	if (*limit >= 1 << 16)
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0de2857..8b5d1cd 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1651,7 +1651,7 @@ unsigned long snapshot_get_image_size(void)
 static int init_header(struct swsusp_info *info)
 {
 	memset(info, 0, sizeof(struct swsusp_info));
-	info->num_physpages = num_physpages;
+	info->num_physpages = get_num_physpages();
 	info->image_pages = nr_copy_pages;
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
@@ -1795,7 +1795,7 @@ static int check_header(struct swsusp_info *info)
 	char *reason;
 
 	reason = check_image_kernel(info);
-	if (!reason && info->num_physpages != num_physpages)
+	if (!reason && info->num_physpages != get_num_physpages())
 		reason = "memory size";
 	if (reason) {
 		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 7e06641..cec5394 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -93,7 +93,7 @@ void inet_frags_init(struct inet_frags *f)
 	}
 	rwlock_init(&f->lock);
 
-	f->rnd = (u32) ((num_physpages ^ (num_physpages>>7)) ^
+	f->rnd = (u32) ((totalram_pages ^ (totalram_pages >> 7)) ^
 				   (jiffies ^ (jiffies >> 6)));
 
 	setup_timer(&f->secret_timer, inet_frag_secret_rebuild,
-- 
1.8.1.2

