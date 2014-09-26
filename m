Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaIZXRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:17:35 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50632 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaIZXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:17:33 -0400
Date: Fri, 26 Sep 2014 16:17:27 -0700
From: josh@joshtriplett.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH 1/1] jffs2: fix sparse warning: unexpected unlock
Message-ID: <20140926231727.GD20917@cloud>
References: <1411065976-20386-1-git-send-email-fabf@skynet.be>
 <20140922181250.GN1193@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922181250.GN1193@ld-irv-0074>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:12:50AM -0700, Brian Norris wrote:
> + linux-sparse
> 
> On Thu, Sep 18, 2014 at 08:46:16PM +0200, Fabian Frederick wrote:
> > fs/jffs2/summary.c:846:5: warning: context imbalance in 'jffs2_sum_write_sumnode' - unexpected unlock
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  fs/jffs2/summary.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
> > index c522d09..a0bac7b 100644
> > --- a/fs/jffs2/summary.c
> > +++ b/fs/jffs2/summary.c
> > @@ -844,6 +844,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
> >  /* Write out summary information - called from jffs2_do_reserve_space */
> >  
> >  int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
> > +	__releases(&c->erase_completion_lock)
> > +	__acquires(&c->erase_completion_lock)
> 
> I'm not too familiar with sparse notations, but Documentation/sparse.txt
> suggests the above is wrong, and the following is more accurate:
> 
> 	__must_hold(&c->erase_completion_lock)
> 
> But it looks like there are several other examples which do this.
> Anyway, here's the relevant doc text, in case someone wants to clarify
> it for me, or else tell me the documentation is wrong:
> 
>     __must_hold - The specified lock is held on function entry and exit.
> 
>     __acquires - The specified lock is held on function exit, but not entry.
> 
>     __releases - The specified lock is held on function entry, but not exit.
> 
> So __acquires and __releases look mutually exclusive, but it's not clear
> if __must_hold will actually cover what we want. (I haven't tested it.)

__must_hold is indeed the correct annotation.  (There isn't currently
anything enforcing that, though.)

- Josh Triplett
