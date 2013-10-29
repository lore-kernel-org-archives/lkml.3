Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3J2Ua5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:30:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3J2Ua4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:30:56 -0400
Date: Tue, 29 Oct 2013 21:30:50 +0100
From: Jan Kara <jack@suse.cz>
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131029203050.GE9568@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
 <20131025091555.GA30895@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025091555.GA30895@kipc2.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-10-13 11:15:55, Karl Kiniger wrote:
> On Fri 131025, Linus Torvalds wrote:
> > On Fri, Oct 25, 2013 at 9:30 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> > >
> > > My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
> > > percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
> > > more) this value becomes unrealistic (13GB) and I've already had some
> > > unpleasant effects due to it.
> > 
> > Right. The percentage notion really goes back to the days when we
> > typically had 8-64 *megabytes* of memory So if you had a 8MB machine
> > you wouldn't want to have more than one megabyte of dirty data, but if
> > you were "Mr Moneybags" and could afford 64MB, you might want to have
> > up to 8MB dirty!!
> > 
> > Things have changed.
> > 
> > So I would suggest we change the defaults. Or pwehaps make the rule be
> > that "the ratio numbers are 'ratio of memory up to 1GB'", to make the
> > semantics similar across 32-bit HIGHMEM machines and 64-bit machines.
> > 
> > The modern way of expressing the dirty limits are to give the actual
> > absolute byte amounts, but we default to the legacy ratio mode..
> > 
> >                 Linus
> 
> Is it currently possible to somehow set above values per block device?
  Yes, to some extent. You can set /sys/block/<device>/bdi/max_ratio to
the maximum proportion the device's dirty data can take from the total
amount. The caveat currently is that this setting only takes effect after
we have more than (dirty_background_ratio + dirty_ratio)/2 dirty data in
total because that is an amount of dirty data when we start to throttle
processes. So if the device you'd like to limit is the only one which is
currently written to, the limiting doesn't have a big effect.

Andrew has queued up a patch series from Maxim Patlasov which removes this
caveat but currently we don't have a way admin can switch that from
userspace. But I'd like to have that tunable from userspace exactly for the
cases as you describe below.

> I want default behaviour for almost everything but  DVD drives in DVD+RW
> packet writing mode may easily take several minutes in case of a sync.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
