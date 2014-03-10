Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaCJF2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:28:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61875 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaCJF23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:28:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389715200"; 
   d="scan'208";a="9669955"
Message-ID: <531D4E23.4060505@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 13:31:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
CC: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
Subject: [V2 PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring page
 migration.
References: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:46,
	Serialize complete at 2014/03/10 13:25:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing aio ring page migration, we migrated the page, and update
ctx->ring_pages[]. Like the following:

aio_migratepage()
  |-> migrate_page_copy(new, old)
  |   ......				/* Need barrier here */
  |-> ctx->ring_pages[idx] = new

Actually, we need a memory barrier between these two operations.
Otherwise, if ctx->ring_pages[] is updated before memory copy due to
the compiler optimization, other processes may have an opportunity
to access to the not fully initialized new ring page.

So add a wmb and rmb to synchronize them.

v2:
   change smp_rmb() to smp_read_barrier_depends(). Thanks Miao.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
  fs/aio.c |   14 ++++++++++++++
  1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index dc70246..4133ba9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -327,6 +327,14 @@ static int aio_migratepage(struct address_space 
*mapping, struct page *new,
  		pgoff_t idx;
  		spin_lock_irqsave(&ctx->completion_lock, flags);
  		migrate_page_copy(new, old);
+
+		/*
+		 * Ensure memory copy is finished before updating
+		 * ctx->ring_pages[]. Otherwise other processes may access to
+		 * new ring pages which are not fully initialized.
+		 */
+		smp_wmb();
+
  		idx = old->index;
  		if (idx < (pgoff_t)ctx->nr_pages) {
  			/* And only do the move if things haven't changed */
@@ -1069,6 +1077,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
  		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
  		pos %= AIO_EVENTS_PER_PAGE;

+		/*
+		 * Ensure that the page's data was copied from old one by
+		 * aio_migratepage().
+		 */
+		smp_read_barrier_depends();
+
  		ev = kmap(page);
  		copy_ret = copy_to_user(event + ret, ev + pos,
  					sizeof(*ev) * avail);
-- 
1.7.7


