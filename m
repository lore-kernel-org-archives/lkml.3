Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883Ab3GWVQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:16:04 -0400
Received: from dupo.coraid.com ([208.71.232.133]:64616 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757721Ab3GWVQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:16:02 -0400
Message-Id: <361157cf24bff1fab81101562d5badf9995afa46.1374610591.git.ecashin@coraid.com>
In-Reply-To: <cover.1374610591.git.ecashin@coraid.com>
References: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 4/6] aoe: fill in per-AoE-target information for debugfs file
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:15:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This information is presented in a compact format that has
evolved for easy routine scanning by expert humans, mostly
developers and support technicians helping to troubleshoot
or test AoE-based systems.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 0511d38..b58cbeb 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -113,11 +113,42 @@ static ssize_t aoedisk_show_payload(struct device *dev,
 static int aoedisk_debugfs_show(struct seq_file *s, void *ignored)
 {
 	struct aoedev *d;
+	struct aoetgt **t, **te;
+	struct aoeif *ifp, *ife;
 	unsigned long flags;
+	char c;
 
 	d = s->private;
+	seq_printf(s, "rttavg: %d rttdev: %d\n",
+		d->rttavg >> RTTSCALE,
+		d->rttdev >> RTTDSCALE);
+	seq_printf(s, "nskbpool: %d\n", skb_queue_len(&d->skbpool));
+	seq_printf(s, "kicked: %ld\n", d->kicked);
+	seq_printf(s, "maxbcnt: %ld\n", d->maxbcnt);
+	seq_printf(s, "ref: %ld\n", d->ref);
+
 	spin_lock_irqsave(&d->lock, flags);
-	seq_printf(s, "%s\n", d->gd->disk_name); /* place holder */
+	t = d->targets;
+	te = t + d->ntargets;
+	for (; t < te && *t; t++) {
+		c = '\t';
+		seq_printf(s, "falloc: %ld\n", (*t)->falloc);
+		seq_printf(s, "ffree: %p\n",
+			list_empty(&(*t)->ffree) ? NULL : (*t)->ffree.next);
+		seq_printf(s, "%pm:%d:%d:%d\n", (*t)->addr, (*t)->nout,
+			(*t)->maxout, (*t)->nframes);
+		seq_printf(s, "\tssthresh:%d\n", (*t)->ssthresh);
+		seq_printf(s, "\ttaint:%d\n", (*t)->taint);
+		seq_printf(s, "\tr:%d\n", (*t)->rpkts);
+		seq_printf(s, "\tw:%d\n", (*t)->wpkts);
+		ifp = (*t)->ifs;
+		ife = ifp + ARRAY_SIZE((*t)->ifs);
+		for (; ifp->nd && ifp < ife; ifp++) {
+			seq_printf(s, "%c%s", c, ifp->nd->name);
+			c = ',';
+		}
+		seq_puts(s, "\n");
+	}
 	spin_unlock_irqrestore(&d->lock, flags);
 
 	return 0;
-- 
1.7.1

