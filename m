Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3AVOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:23:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35859 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3AVOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:23:47 -0500
Date: Tue, 22 Jan 2013 14:23:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] making HAVE_SYSCALL_WRAPPERS universal (Re: Issues with
 "x86, um: switch to generic fork/vfork/clone" commit)
Message-ID: <20130122142341.GW4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
 <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
 <20130121012217.GQ4939@ZenIV.linux.org.uk>
 <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
 <20130121023010.GR4939@ZenIV.linux.org.uk>
 <20130121225517.GV4939@ZenIV.linux.org.uk>
 <50FE8A55.2000703@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FE8A55.2000703@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 12:47:17PM +0000, James Hogan wrote:
> On 21/01/13 22:55, Al Viro wrote:
> > I've tried to sanitize cond_syscall/SYSCALL_ALIAS situation; the tree is in
> > git.kernel.org/pub/scm/linux/kernel/git/viro/signal experimental-syscalls
> > NOTE: this is absolutely untested and might very well blow up
> > on any number of architectures.
> > 
> > Review and comments would be very welcome.
> 
> Looking at "consolidate cond_syscall and SYSCALL_ALIAS declarations",
> is it worth having the default __SYMBOL_NAME declaration in
> include/linux/linkage.h make use of CONFIG_SYMBOL_PREFIX?
> 
> E.g. in the metag patchset we currently have the patch below.
> 
> Admittedly CONFIG_SYMBOL_PREFIX is a string which would make it's use in
> SYMBOL_NAME a bit awkward.

Umm...  TBH, I simply followed the existing macro (from h8300), but I really
suspect that it's better than your approach - sure, you leave populating the
syscall table to cc(1) and generally have fewer things in asm glue, but
you still have things like _clear_page, _ip_fast_csum, ___ashldi3, etc.
Having a macro converting C identifier to asm one might be a win for such
situations; if nothing else, it helps with grep - blackfin is a constant
source of annoyance, since e.g. git grep -n -w do_notify_resume will miss
things like
        pseudo_long_call _do_notify_resume, p5;

I'm not saying that SYMBOL_NAME is particulary good as identifiers go,
but the functionality is more useful than CONFIG_SYMBOL_PREFIX, IMO...
