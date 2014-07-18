Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbaGRAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:49:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbaGRAtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:49:40 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jul 2014 10:48:28 +1000
Subject: [PATCH 3/5] autofs4: don't take spinlock when not needed in
 autofs4_lookup_expiring
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140718004828.19389.67320.stgit@notabene.brown>
In-Reply-To: <20140718004353.19389.48104.stgit@notabene.brown>
References: <20140718004353.19389.48104.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the expiring_list is empty, we can avoid a costly spinlock
in the rcu-walk path through autofs4_d_manage (once the rest
of the path becomes rcu-walk friendly).

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cc87c1abac97..fb202cadd4b3 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -166,8 +166,10 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *active;
@@ -218,8 +220,10 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *expiring;


