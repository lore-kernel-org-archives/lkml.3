Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbaGXJz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:55:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292AbaGXJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:55:23 -0400
Date: Thu, 24 Jul 2014 11:55:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140724095517.GS12054@laptop.lan>
References: <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
 <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53D0B358.5010400@daenzer.net>
 <20140724075157.GJ3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724075157.GJ3935@laptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:51:57AM +0200, Peter Zijlstra wrote:
> > I hope the assembly output I sent earlier helps, I'm afraid bisecting
> > this could be painful.
> 
> Yeah, lemme go have a look...

So I'm not seeing it, the cpus value is kept at -136(%rbp), so
-128(%rbp) comes after and that's struct lb_env env. And -140(%rbp)
comes before and that ends up being @idle.

The compiler likes to spill for sure, but aside from stupid I don't
see it doing wrong in the relatively short code from function start to
the rep movsl.

It does a rep stosl on -128(%rbp) and then fills it out, but none of
that looks to stomp on our -136(%rbp) value. And the -140(%rbp) thing is
only written to once, and while that is done after the 136 thing its a
single movl and that's not going to clobber anything.

And the fault happens before we pass @env around, so there no chance
someone writes before it either.

So I'm still entirely clueless..
