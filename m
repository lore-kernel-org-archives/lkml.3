Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3H1WzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:55:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:18245 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3H1WzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:55:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,978,1367996400"; 
   d="scan'208";a="370001056"
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20130828211902.GA22796@shutemov.name>
References: <1377726732.3625.31.camel@schen9-DESK>
	 <20130828211902.GA22796@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Aug 2013 15:54:57 -0700
Message-ID: <1377730497.3625.43.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 00:19 +0300, Kirill A. Shutemov wrote:

> > ---
> >  fs/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 68307c0..70fa26c 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
> >   * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
> >   * take a passive reference to the superblock to avoid this from occurring.
> >   */
> > +#define SB_CACHE_LOW 5
> >  static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >  	struct super_block *sb;
> > @@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> >  	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
> >  		return -1;
> >  
> > +	/*
> > +	 * Don't prune if we have few cached objects to reclaim to
> > +	 * avoid useless sb_lock contention
> > +	 */
> > +	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
> > +		return -1;
> 
> I don't think it's correct: you don't account fs_objects here and
> prune_icache_sb() calls invalidate_mapping_pages() which can free a lot of
> memory. It's too naive approach. You can miss a memory hog easily this
> way.

Is it safe to compute sb->s_op->nr_cached_objects(sb), assuming non null
s_op without holding sb_lock to increment ref count on sb?  
I think it is safe as we hold the shrinker_rwsem so we cannot 
unregister the shrinker and the s_op and sb
structure should still be there.  However, I'm not totally sure.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/fs/super.c b/fs/super.c
index 68307c0..173d0d9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
  * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
+#define SB_CACHE_LOW 5
 static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct super_block *sb;
@@ -68,6 +69,17 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
 		return -1;
 
+	total_objects = sb->s_nr_dentry_unused + sb->s_nr_inodes_unused;
+	if (sb->s_op && sb->s_op->nr_cached_objects)
+		total_objects += sb->s_op->nr_cached_objects(sb);
+
+	/*
+	 * Don't prune if we have few cached objects to reclaim to
+	 * avoid useless sb_lock contention
+	 */
+	if (total_objects <= SB_CACHE_LOW)
+		return -1;
+
 	if (!grab_super_passive(sb))
 		return -1;
 


