Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaI1J5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:57:05 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37428 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaI1J5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:57:02 -0400
X-Originating-IP: 50.43.15.134
Date: Sun, 28 Sep 2014 02:56:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH 1/1] jffs2: fix sparse warning: unexpected unlock
Message-ID: <20140928095650.GA24178@thin>
References: <1411065976-20386-1-git-send-email-fabf@skynet.be>
 <20140922181250.GN1193@ld-irv-0074>
 <20140926231727.GD20917@cloud>
 <1745266822.710655.1411807315752.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1745266822.710655.1411807315752.open-xchange@webmail.nmp.skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:41:55AM +0200, Fabian Frederick wrote:
> 
> 
> > On 27 September 2014 at 01:17 josh@joshtriplett.org wrote:
> >
> >
> > On Mon, Sep 22, 2014 at 11:12:50AM -0700, Brian Norris wrote:
> > > + linux-sparse
> > >
> > > On Thu, Sep 18, 2014 at 08:46:16PM +0200, Fabian Frederick wrote:
> > > > fs/jffs2/summary.c:846:5: warning: context imbalance in
> > > > 'jffs2_sum_write_sumnode' - unexpected unlock
> > > >
> > > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > > > ---
> > > >  fs/jffs2/summary.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
> > > > index c522d09..a0bac7b 100644
> > > > --- a/fs/jffs2/summary.c
> > > > +++ b/fs/jffs2/summary.c
> > > > @@ -844,6 +844,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info
> > > > *c, struct jffs2_eraseblock
> > > >  /* Write out summary information - called from jffs2_do_reserve_space */
> > > > 
> > > >  int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
> > > > + __releases(&c->erase_completion_lock)
> > > > + __acquires(&c->erase_completion_lock)
> > >
> > > I'm not too familiar with sparse notations, but Documentation/sparse.txt
> > > suggests the above is wrong, and the following is more accurate:
> > >
> > >     __must_hold(&c->erase_completion_lock)
> > >
> > > But it looks like there are several other examples which do this.
> > > Anyway, here's the relevant doc text, in case someone wants to clarify
> > > it for me, or else tell me the documentation is wrong:
> > >
> > >     __must_hold - The specified lock is held on function entry and exit.
> > >
> > >     __acquires - The specified lock is held on function exit, but not entry.
> > >
> > >     __releases - The specified lock is held on function entry, but not exit.
> > >
> > > So __acquires and __releases look mutually exclusive, but it's not clear
> > > if __must_hold will actually cover what we want. (I haven't tested it.)
> >
> > __must_hold is indeed the correct annotation.  (There isn't currently
> > anything enforcing that, though.)
> >
> > - Josh Triplett
> 
> There are 137 __releases && __acquires annotated functions in stable.
> 
> AFAICS those are based on lock held on function entry / lock held on exit
> 
> See
> fs/fuse/file.c:1527
> fs/kernfs/dir.c:341
> drivers/block/nbd.c:564
> 
> Does it mean that all of these should be updated to __must_hold ?

Not really worth changing yet until something actually pays closer
attention to those annotations.

- Josh Triplett
