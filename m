Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaI0Il7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:41:59 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:17931 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbaI0Il5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:41:57 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=UPm3pfgAAAAA:8 a=wlPDjZRBh5EINd2pZUoA:9
 a=QEXdDO2ut3YA:10 a=mOio7EKfaG4A:10 a=RRKCQQAfp4N9wqMx:21
 a=h46F51pvsG9XICTf:21
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukKAKp3JlTD7hTU/2dsb2JhbABfgw6EK7JuBptJAoECFgF7hAMBAQEDASMEUgULBQYYAgIYDgICVwYBEhGIJQypLIZ/jwABF4EshGaJWTMHgniBUwWzAoNlOy+CSgEBAQ
Date: Sat, 27 Sep 2014 10:41:55 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: josh@joshtriplett.org, Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Message-ID: <1745266822.710655.1411807315752.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140926231727.GD20917@cloud>
References: <1411065976-20386-1-git-send-email-fabf@skynet.be> <20140922181250.GN1193@ld-irv-0074> <20140926231727.GD20917@cloud>
Subject: Re: [PATCH 1/1] jffs2: fix sparse warning: unexpected unlock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 27 September 2014 at 01:17 josh@joshtriplett.org wrote:
>
>
> On Mon, Sep 22, 2014 at 11:12:50AM -0700, Brian Norris wrote:
> > + linux-sparse
> >
> > On Thu, Sep 18, 2014 at 08:46:16PM +0200, Fabian Frederick wrote:
> > > fs/jffs2/summary.c:846:5: warning: context imbalance in
> > > 'jffs2_sum_write_sumnode' - unexpected unlock
> > >
> > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > > ---
> > >  fs/jffs2/summary.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
> > > index c522d09..a0bac7b 100644
> > > --- a/fs/jffs2/summary.c
> > > +++ b/fs/jffs2/summary.c
> > > @@ -844,6 +844,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info
> > > *c, struct jffs2_eraseblock
> > >  /* Write out summary information - called from jffs2_do_reserve_space */
> > > 
> > >  int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
> > > + __releases(&c->erase_completion_lock)
> > > + __acquires(&c->erase_completion_lock)
> >
> > I'm not too familiar with sparse notations, but Documentation/sparse.txt
> > suggests the above is wrong, and the following is more accurate:
> >
> >     __must_hold(&c->erase_completion_lock)
> >
> > But it looks like there are several other examples which do this.
> > Anyway, here's the relevant doc text, in case someone wants to clarify
> > it for me, or else tell me the documentation is wrong:
> >
> >     __must_hold - The specified lock is held on function entry and exit.
> >
> >     __acquires - The specified lock is held on function exit, but not entry.
> >
> >     __releases - The specified lock is held on function entry, but not exit.
> >
> > So __acquires and __releases look mutually exclusive, but it's not clear
> > if __must_hold will actually cover what we want. (I haven't tested it.)
>
> __must_hold is indeed the correct annotation.  (There isn't currently
> anything enforcing that, though.)
>
> - Josh Triplett

There are 137 __releases && __acquires annotated functions in stable.

AFAICS those are based on lock held on function entry / lock held on exit

See
fs/fuse/file.c:1527
fs/kernfs/dir.c:341
drivers/block/nbd.c:564

Does it mean that all of these should be updated to __must_hold ?

Fabian
