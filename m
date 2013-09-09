Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3IIOkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:40:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3IIOkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:40:01 -0400
Date: Mon, 9 Sep 2013 16:39:54 +0200
From: Jan Kara <jack@suse.cz>
To: Olof Johansson <olof@lixom.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build warning after merge of the final tree (Linus'
 tree related - vai vfs tree)
Message-ID: <20130909143954.GE1612@quack.suse.cz>
References: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
 <CAMuHMdXib30o3-70EuYj3to0==b7LfwPbivF9DaBrpHPejsDFg@mail.gmail.com>
 <20130909032154.GA18168@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909032154.GA18168@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 08-09-13 20:21:54, Olof Johansson wrote:
> On Fri, Sep 06, 2013 at 10:52:52AM +0200, Geert Uytterhoeven wrote:
> > On Fri, Sep 6, 2013 at 9:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > After merging the final tree, today's linux-next build (arm defconfig)
> > > produced this warning:
> > >
> > > fs/direct-io.c: In function 'sb_init_dio_done_wq':
> > > fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]
> > >
> > > This is:
> > >
> > >         cmpxchg(&sb->s_dio_done_wq, NULL, wq);
> > >
> > > Introduced by commit 7b7a8665edd8 ("direct-io: Implement generic deferred
> > > AIO completions").
> > 
> > This happens for include/asm-generic/cmpxchg.h and several other
> > arch-specific implementations that cast the return value of cmpxchg()
> > like
> > 
> > #define cmpxchg(ptr, o, n)   ((__typeof__(*(ptr)))__cmpxchg(....
> > 
> > If the caller of cmpxchg() doesn't use the return value, we get a
> > compiler warning,
> > at least with some versions of gcc.
> > 
> > Any idea how to fix this once and for good?
> 
> Should it be fixed? Chances are that the caller needs to do actions
> depending on if the change happened, and checking the value afterwards
> is inherently racy.
> 
> For this specific fs/direct-io.c case it seems to be safe since the
> workqueue is only ever set and never cleared, but it might still be a
> good idea to do:
  I'm not against this change - feel free to add my:
Reviewed-by: Jan Kara <jack@suse.cz>

  to it and merge it. However I maintain there are valid usecases where you
do not care about the return value so warning about it doesn't seem right.
OTOH thinking about it some more I agree we have other precedents where
sometimes-correct-often-bugs constructs are warned about and I can see how
people can consider cmpxchg() to be that case. But in that case we should:
  a) be consistent among architectures about the warning
  b) comment at cmpxchg definition that you are supposed to check its
     return value. If you really know what you are doing, you can cast the
     return value to (void) and comment why it's safe.

								Honza
> 
> 
> ---8<----------8<----------8<----------8<----------8<----------8<----------8<--
> 
> From 7fdfa2da727aa9153a7df919c240abfe4f564d7a Mon Sep 17 00:00:00 2001
> From: Olof Johansson <olof@lixom.net>
> Date: Sun, 8 Sep 2013 20:12:57 -0700
> Subject: [PATCH] direct-io: Use return from cmpxchg to decide of assignment happened
> 
> Not using the return value can in the generic case be racy, so it's better to
> use the expected way of using that instead of comparing later.
> 
> This also resolved the warning caused on ARM and other architectures:
> 
> fs/direct-io.c: In function 'sb_init_dio_done_wq':
> fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  fs/direct-io.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 1782023..0e04142 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -544,6 +544,7 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
>   */
>  static int sb_init_dio_done_wq(struct super_block *sb)
>  {
> +	struct workqueue_struct *old;
>  	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
>  						      WQ_MEM_RECLAIM, 0,
>  						      sb->s_id);
> @@ -552,9 +553,9 @@ static int sb_init_dio_done_wq(struct super_block *sb)
>  	/*
>  	 * This has to be atomic as more DIOs can race to create the workqueue
>  	 */
> -	cmpxchg(&sb->s_dio_done_wq, NULL, wq);
> +	old = cmpxchg(&sb->s_dio_done_wq, NULL, wq);
>  	/* Someone created workqueue before us? Free ours... */
> -	if (wq != sb->s_dio_done_wq)
> +	if (old)
>  		destroy_workqueue(wq);
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
