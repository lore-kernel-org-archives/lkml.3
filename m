Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3IIDWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:22:33 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39426 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3IIDWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:22:31 -0400
Date: Sun, 8 Sep 2013 20:21:54 -0700
From: Olof Johansson <olof@lixom.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build warning after merge of the final tree (Linus'
 tree related - vai vfs tree)
Message-ID: <20130909032154.GA18168@quad.lixom.net>
References: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
 <CAMuHMdXib30o3-70EuYj3to0==b7LfwPbivF9DaBrpHPejsDFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXib30o3-70EuYj3to0==b7LfwPbivF9DaBrpHPejsDFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:52:52AM +0200, Geert Uytterhoeven wrote:
> On Fri, Sep 6, 2013 at 9:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the final tree, today's linux-next build (arm defconfig)
> > produced this warning:
> >
> > fs/direct-io.c: In function 'sb_init_dio_done_wq':
> > fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]
> >
> > This is:
> >
> >         cmpxchg(&sb->s_dio_done_wq, NULL, wq);
> >
> > Introduced by commit 7b7a8665edd8 ("direct-io: Implement generic deferred
> > AIO completions").
> 
> This happens for include/asm-generic/cmpxchg.h and several other
> arch-specific implementations that cast the return value of cmpxchg()
> like
> 
> #define cmpxchg(ptr, o, n)   ((__typeof__(*(ptr)))__cmpxchg(....
> 
> If the caller of cmpxchg() doesn't use the return value, we get a
> compiler warning,
> at least with some versions of gcc.
> 
> Any idea how to fix this once and for good?

Should it be fixed? Chances are that the caller needs to do actions
depending on if the change happened, and checking the value afterwards
is inherently racy.

For this specific fs/direct-io.c case it seems to be safe since the
workqueue is only ever set and never cleared, but it might still be a
good idea to do:


---8<----------8<----------8<----------8<----------8<----------8<----------8<--

>From 7fdfa2da727aa9153a7df919c240abfe4f564d7a Mon Sep 17 00:00:00 2001
From: Olof Johansson <olof@lixom.net>
Date: Sun, 8 Sep 2013 20:12:57 -0700
Subject: [PATCH] direct-io: Use return from cmpxchg to decide of assignment happened

Not using the return value can in the generic case be racy, so it's better to
use the expected way of using that instead of comparing later.

This also resolved the warning caused on ARM and other architectures:

fs/direct-io.c: In function 'sb_init_dio_done_wq':
fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 fs/direct-io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1782023..0e04142 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -544,6 +544,7 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
  */
 static int sb_init_dio_done_wq(struct super_block *sb)
 {
+	struct workqueue_struct *old;
 	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
 						      WQ_MEM_RECLAIM, 0,
 						      sb->s_id);
@@ -552,9 +553,9 @@ static int sb_init_dio_done_wq(struct super_block *sb)
 	/*
 	 * This has to be atomic as more DIOs can race to create the workqueue
 	 */
-	cmpxchg(&sb->s_dio_done_wq, NULL, wq);
+	old = cmpxchg(&sb->s_dio_done_wq, NULL, wq);
 	/* Someone created workqueue before us? Free ours... */
-	if (wq != sb->s_dio_done_wq)
+	if (old)
 		destroy_workqueue(wq);
 	return 0;
 }
-- 
1.7.10.4

