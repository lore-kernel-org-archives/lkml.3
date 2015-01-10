Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbAJMKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 07:10:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbbAJMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 07:10:36 -0500
X-AuditID: cbfee61a-f79c06d000004e71-7b-54b116baf614
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <009c01d0298c$946435e0$bd2ca1a0$@samsung.com>
 <20150106194834.GC54001@jaegeuk-mac02>
In-reply-to: <20150106194834.GC54001@jaegeuk-mac02>
Subject: RE: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in
 debugfs
Date: Sat, 10 Jan 2015 20:09:52 +0800
Message-id: <000201d02cce$70f628d0$52e27a70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGGMMlccBnlfi+OEdDXaWNleUrjngIFtej9nT0A1lA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd1dYhtDDPouK1pc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro2Pva8aC
	t5IVq5f3sDUwzhLtYuTgkBAwkVh4SbWLkRPIFJO4cG89G4gtJLCIUeLjBNMuRi4g+wejxIvm
	zWAJNgEVieUd/5lAbBEBNYnefVOYQOYwCxRJrFohANGbJLGrtYkdxOYUMJb4vaafGcQWFgiX
	eLWhF2wMi4CqxJfLnewgrbwClhLrPmqChHkFBCV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8SZ
	ChI7zr5mBGkVEbCS2DlFCKJEXGLjkVssExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnDoP5PawbiyweIQowAHoxIP74/ODSFCrIllxZW5hxglOJiVRHil
	7gCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrZt4UICaQnlqRmp6YWpBbBZJk4OKUaGI9ZRJ+c
	GpgqbGZW8LDHW5tdIPX/T+Yo5tpD/06/e1FY+STZTeXnr32aZ4V9d/mKna0Uvr3nwKcva6zd
	Xqjcm/dOQdDqeNzWdMvCdQdDwswvvCnQyeKpfTf9/dOJy6cr3Mw1e7PN43bwhsPnZ5R8MC9q
	tuLWat5Y5X513ZIsF+f1B8/Hp66yPaDEUpyRaKjFXFScCACRhBTneQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, January 07, 2015 3:49 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in debugfs
> 
> Hi Chao,
> 
> On Tue, Jan 06, 2015 at 04:40:49PM +0800, Chao Yu wrote:
> > Our value of memory footprint statistics showed in debugfs is not calculated
> > correctly. Fix it in this patch.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/debug.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> > index dd7835b..6aeaf46 100644
> > --- a/fs/f2fs/debug.c
> > +++ b/fs/f2fs/debug.c
> > @@ -125,7 +125,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
> >  	int i;
> >
> >  	if (si->base_mem)
> > -		goto get_cache;
> > +		goto get_dynamic_cache;
> >
> >  	si->base_mem = sizeof(struct f2fs_sb_info) + sbi->sb->s_blocksize;
> >  	si->base_mem += 2 * sizeof(struct f2fs_inode_info);
> > @@ -161,13 +161,18 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
> >  	si->base_mem += sizeof(struct f2fs_nm_info);
> >  	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
> >
> > +get_dynamic_cache:
> >  	/* build gc */
> > -	si->base_mem += sizeof(struct f2fs_gc_kthread);
> > +	if (sbi->gc_thread)
> > +		si->base_mem += sizeof(struct f2fs_gc_kthread);
> > +
> > +	/* build merge flush thread */
> > +	if (SM_I(sbi)->cmd_control_info)
> > +		si->base_mem += sizeof(struct flush_cmd_control);
> 
> It seems base_mem increases repeatedly?

Right, my mistaken. How about counting memory of these two cache into cache_mem
as following?

>From edfa0beaed83ebfec34b07bfcb5e8ce3cdcb0858 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao2.yu@samsung.com>
Date: Sat, 10 Jan 2015 19:24:24 +0800
Subject: [PATCH] f2fs: fix wrong memory footprint statistics in debugfs

Our value of memory footprint statistics showed in debugfs is not calculated
correctly. Fix it in this patch.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/debug.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 1f0fb58..b45daab 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -163,13 +163,20 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	si->base_mem += sizeof(struct f2fs_nm_info);
 	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
 
+get_cache:
+	si->cache_mem = 0;
+
 	/* build gc */
-	si->base_mem += sizeof(struct f2fs_gc_kthread);
+	if (sbi->gc_thread)
+		si->cache_mem += sizeof(struct f2fs_gc_kthread);
+
+	/* build merge flush thread */
+	if (SM_I(sbi)->cmd_control_info)
+		si->cache_mem += sizeof(struct flush_cmd_control);
 
-get_cache:
 	/* free nids */
-	si->cache_mem = NM_I(sbi)->fcnt;
-	si->cache_mem += NM_I(sbi)->nat_cnt;
+	si->cache_mem += NM_I(sbi)->fcnt * sizeof(struct free_nid);
+	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);
 	npages = NODE_MAPPING(sbi)->nrpages;
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	npages = META_MAPPING(sbi)->nrpages;
-- 
2.2.1


