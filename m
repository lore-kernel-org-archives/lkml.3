Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaKAWFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:05:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKAWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:05:01 -0400
Date: Sat, 1 Nov 2014 22:04:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W.Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141101220458.GT7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
 <87r3ybwq0b.fsf@x220.int.ebiederm.org>
 <20141101083804.GO7996@ZenIV.linux.org.uk>
 <20141101150620.GP7996@ZenIV.linux.org.uk>
 <cfb295aa-0e4b-4185-875f-3745d2c5c01a@email.android.com>
 <20141101183802.GR7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101183802.GR7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 06:38:02PM +0000, Al Viro wrote:
> On Sat, Nov 01, 2014 at 11:23:34AM -0700, Eric W.Biederman wrote:
> 
> > >From your description I am concerned about using the letter combination nsfs.   I once used nsfd, and that was so close to nfsd that Linus got confused, and hilarity ensued.   nsfs isn't quite as bad but the abbreviation still seems close enough to nfs that confusion could result.
> 
> Well, yes, but... the only non-static object in there with "nsfs" in the
> name is nsfs_init().  As for the filename itself... any better suggestions
> would be welcome, but it doesn't really mess the completion tree.
> 
> I've no strong preferences here - we might even move it into kernel/nsproxy.c.
> In the latest variant it's ~160 lines...

BTW, as an immediate followup, definition of struct nameidata can be
taken to fs/namei.c now.  nd_get_link/nd_set_link become exported, actual
declaration of struct nameidata goes into fs/namei.c and for everything
outside of fs/namei.c it becomes completely opaque.

TBH, I'm somewhat tempted to do something even more extreme - try to treat
it the way we treat pt_regs.  I.e. have a pointer to such sucker in
task_struct (NULL most of the time) and chain the instances.  That way
we'd be rid of passing that sucker even to ->follow_link() (and to
nd_{set,get}_link() as well).  path_init() would push the sucker to the
top of the chain, path_finish(nd, base) (currently open-coded bunch of
        if (nd->root.mnt && !(nd->flags & LOOKUP_ROOT))
                path_put(&nd->root);
	if (base)
		fput(base);
) - remove it from the chain.  Not sure if it's worth doing - it's slightly
less boilerplate in ->follow_link() and ->put_link() instances and it _might_
reduce the stack footprint in a bunch of places in fs/namei.c (including the
recursion in there), but it might easily end up increasing it instead...
