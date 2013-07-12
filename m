Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3GLJIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:08:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab3GLJIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:08:02 -0400
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
In-Reply-To: <20130710204648.GE3297@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
	 <1373282357.4298.198.camel@chaos.site> <20130708173535.GB3206@free.fr>
	 <20130710204648.GE3297@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 12 Jul 2013 11:07:45 +0200
Message-ID: <1373620065.4410.25.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yann, Michal,

Le Wednesday 10 July 2013 à 22:46 +0200, Yann E. MORIN a écrit :
> Michal, All,
> 
> On 2013-07-08 19:35 +0200, Yann E. MORIN spake thusly:
> > On 2013-07-08 13:19 +0200, Jean Delvare spake thusly:
> > > Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> > > > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > [--SNIP--]
> > > > Since the search can be a regexp, it is possible that more than one symbol
> > > > matches exactly. In this case, we can't decide which to sort first, so we
> > > > fallback to alphabeticall sort.
> [--SNIP--]
> > > > Reported-by: Jean Delvare <jdelvare@suse.de>
> > > > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > > > Cc: Jean Delvare <jdelvare@suse.de>
> > > > Cc: Michal Marek <mmarek@suse.cz>
> > > > Cc: Roland Eggner <edvx1@systemanalysen.net>
> > > > Cc: Wang YanQing <udknight@gmail.com>
> > > 
> > > I tested it and it works fine, thanks!
> > > 
> > > Tested-by: Jean Delvare <jdelvare@suse.de>
> > > 
> > > Now comes my late review. Overall I like the idea and the code but a few
> > > things could be improved:
> > 
> > Since this is already in Michal's tree, on should I proceed?
> >   - send an updated patch that replaces that one, or
> >   - send another additional patch with your proposed changes?
> 
> OK, since Michal already sent his pull-request to Linus, I'll prepare a
> corrective patch I'll submit before the end of the week. Is that OK with
> you, Michal?

Sounds good to me at least. I'll do my best to test and review it
quickly this time.

> [--SNIP--]
> > > > +static int sym_rel_comp( const void *sym1, const void *sym2 )
> > > > +{
> > > > +	struct sym_match *s1 = *(struct sym_match **)sym1;
> > > > +	struct sym_match *s2 = *(struct sym_match **)sym2;
> > > 
> > > You shouldn't need these casts.
> > 
> > Probably not, indeed, but I like to write (and read) what I expect to
> > happen, and pointer arithmetics is always something I dread to foobar.
> 
> In fact, we need the cast, otherwise gcc whines about const/non-const.

And quite rightly so, as you are taking const pointers (i.e. the caller
told you you are _not_ allowed to change the contents) and making them
non-const pointers (i.e. you give yourself the right to still change the
contents.) It happens that your function doesn't actually change the
contents, so no harm done, but this is still conceptually wrong.
Preserving the const nature of pointers down the call chain lets the
compiler warn you if a function changes data it was not supposed to.

So what you want to do is:

static int sym_rel_comp(const void *sym1, const void *sym2)
{
	const struct sym_match *s1 = sym1;
	const struct sym_match *s2 = sym2; 

This is both concise and correct, and it makes gcc happy.

Thanks,
-- 
Jean Delvare
Suse L3

