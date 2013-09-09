Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3IITUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:20:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3IITUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:20:31 -0400
Date: Mon, 9 Sep 2013 21:20:28 +0200
From: Jan Kara <jack@suse.cz>
To: Olof Johansson <olof@lixom.net>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build warning after merge of the final tree (Linus'
 tree related - vai vfs tree)
Message-ID: <20130909192028.GA29973@quack.suse.cz>
References: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
 <CAMuHMdXib30o3-70EuYj3to0==b7LfwPbivF9DaBrpHPejsDFg@mail.gmail.com>
 <20130909032154.GA18168@quad.lixom.net>
 <20130909143954.GE1612@quack.suse.cz>
 <CAOesGMjyFVGXGiK9uccg+jeANP6EH4nbbpCHgkucvo9au8kjvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjyFVGXGiK9uccg+jeANP6EH4nbbpCHgkucvo9au8kjvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-09-13 09:45:52, Olof Johansson wrote:
> On Mon, Sep 9, 2013 at 7:39 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sun 08-09-13 20:21:54, Olof Johansson wrote:
> >> On Fri, Sep 06, 2013 at 10:52:52AM +0200, Geert Uytterhoeven wrote:
> >> > On Fri, Sep 6, 2013 at 9:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> > > After merging the final tree, today's linux-next build (arm defconfig)
> >> > > produced this warning:
> >> > >
> >> > > fs/direct-io.c: In function 'sb_init_dio_done_wq':
> >> > > fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]
> >> > >
> >> > > This is:
> >> > >
> >> > >         cmpxchg(&sb->s_dio_done_wq, NULL, wq);
> >> > >
> >> > > Introduced by commit 7b7a8665edd8 ("direct-io: Implement generic deferred
> >> > > AIO completions").
> >> >
> >> > This happens for include/asm-generic/cmpxchg.h and several other
> >> > arch-specific implementations that cast the return value of cmpxchg()
> >> > like
> >> >
> >> > #define cmpxchg(ptr, o, n)   ((__typeof__(*(ptr)))__cmpxchg(....
> >> >
> >> > If the caller of cmpxchg() doesn't use the return value, we get a
> >> > compiler warning,
> >> > at least with some versions of gcc.
> >> >
> >> > Any idea how to fix this once and for good?
> >>
> >> Should it be fixed? Chances are that the caller needs to do actions
> >> depending on if the change happened, and checking the value afterwards
> >> is inherently racy.
> >>
> >> For this specific fs/direct-io.c case it seems to be safe since the
> >> workqueue is only ever set and never cleared, but it might still be a
> >> good idea to do:
> >   I'm not against this change - feel free to add my:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> >
> >   to it and merge it. However I maintain there are valid usecases where you
> > do not care about the return value so warning about it doesn't seem right.
> 
> Yes, similar to (some) __must_check-annotated functions.
> 
> > OTOH thinking about it some more I agree we have other precedents where
> > sometimes-correct-often-bugs constructs are warned about and I can see how
> > people can consider cmpxchg() to be that case. But in that case we should:
> >   a) be consistent among architectures about the warning
> >   b) comment at cmpxchg definition that you are supposed to check its
> >      return value. If you really know what you are doing, you can cast the
> >      return value to (void) and comment why it's safe.
> 
> Unfortunately cmpxchg() is a #define since it needs to use __typeof__.
> Marking it __must_check isn't feasible. I'm open for better
> suggestions.
  Well, if you explicitely type return value of cmpxchg() to its type like
some architectures do, then recent gccs will complain when the return value
isn't used. But I agree this probably isn't very futureproof.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
