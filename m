Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaGIXmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:42:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbaGIXma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:42:30 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Thu, 10 Jul 2014 09:41:14 +1000
Subject: [PATCH 6/6] autofs4: don't take spinlock when not needed in
 autofs4_lookup_expiring
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709234114.4525.70534.stgit@notabene.brown>
In-Reply-To: <20140709233541.4525.25151.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the expiring_list is empty, we can avoid a costly spinlock
in the rcu-walk path through authfs4_d_manage.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/root.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 1ad119407e2f..774c2dab331b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -219,6 +219,8 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
+	if (list_empty(&sbi->expiring_list))
+		return NULL;
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {


