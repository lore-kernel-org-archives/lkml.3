Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031410Ab3HIWeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:34:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031364Ab3HIWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:34:08 -0400
Date: Fri, 9 Aug 2013 15:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130809153407.3bcf44fadd4fa99472fb70b8@linux-foundation.org>
In-Reply-To: <20130809222104.GY2280@outflux.net>
References: <20130807151903.6281b33735f4e3f79231bf5e@canb.auug.org.au>
	<20130809222104.GY2280@outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013 15:21:04 -0700 Kees Cook <kees@outflux.net> wrote:

> Hi,
> 
> On Wed, Aug 07, 2013 at 03:19:03PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> >   	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> > + 		int ret;
> > + 
> >   		/*
> >   		 * If we have already reclaimed all extents from extent
> >   		 * status tree, just stop the loop immediately.
> 
> Which is masking the "ret" at the start, leading to warnings at build-time:
> 
> fs/ext4/extents_status.c: In function _____ext4_es_shrink___:
> fs/ext4/extents_status.c:950:6: warning: unused variable ___ret___ [-Wunused-variable]

yup.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2

fix shadowed local, spell "skipped" correctly

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents_status.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2 fs/ext4/extents_status.c
--- a/fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
+++ a/fs/ext4/extents_status.c
@@ -946,15 +946,15 @@ static int __ext4_es_shrink(struct ext4_
 {
 	struct ext4_inode_info *ei;
 	struct list_head *cur, *tmp;
-	LIST_HEAD(skiped);
-	int ret, nr_shrunk = 0;
+	LIST_HEAD(skipped);
+	int nr_shrunk = 0;
 	int retried = 0, skip_precached = 1, nr_skipped = 0;
 
 	spin_lock(&sbi->s_es_lru_lock);
 
 retry:
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
-		int ret;
+		int shrunk;
 
 		/*
 		 * If we have already reclaimed all extents from extent
@@ -974,7 +974,7 @@ retry:
 		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
 						EXT4_STATE_EXT_PRECACHED))) {
 			nr_skipped++;
-			list_move_tail(cur, &skiped);
+			list_move_tail(cur, &skipped);
 			continue;
 		}
 
@@ -982,19 +982,19 @@ retry:
 			continue;
 
 		write_lock(&ei->i_es_lock);
-		ret = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
 		if (ei->i_es_lru_nr == 0)
 			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
-		nr_shrunk += ret;
-		nr_to_scan -= ret;
+		nr_shrunk += shrunk;
+		nr_to_scan -= shrunk;
 		if (nr_to_scan == 0)
 			break;
 	}
 
 	/* Move the newer inodes into the tail of the LRU list. */
-	list_splice_tail(&skiped, &sbi->s_es_lru);
+	list_splice_tail(&skipped, &sbi->s_es_lru);
 
 	/*
 	 * If we skipped any inodes, and we weren't able to make any
_

