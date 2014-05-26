Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaEZN5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:57:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaEZN5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:57:50 -0400
Date: Mon, 26 May 2014 14:57:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140526135746.GM18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526093741.GA1765@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fsdevel and folks who'd been on d_lru corruption thread Cc'd - that's
a continuation of the same mess]

On Mon, May 26, 2014 at 12:37:41PM +0300, Mika Westerberg wrote:
> Hi,
> 
> After v3.15-rc4 my Fedora 20 system with mainline kernel has been suffering
> from the above lockup.
> 
> This is easy to reproduce:
> 
>  1) Plug in USB memory stick (to xHCI port)
>  2) Unplug it
> 
> Typically only one iteration is needed and suddenly I can see
> systemd-udev taking 100% CPU and eventually the whole system becomes
> unusable.
> 
> I've tried to investigate and it looks like we just spin in
> shrink_dentry_list() forever. Reverting following fs/dcache.c commits
> the issue goes away:
> 
> 60942f2f235ce7b817166cdf355eed729094834d dcache: don't need rcu in shrink_dentry_list()
> 9c8c10e262e0f62cb2530f1b076de979123183dd more graceful recovery in umount_collect()
> fe91522a7ba82ca1a51b07e19954b3825e4aaa22 don't remove from shrink list in select_collect()

Which means that we very likely have a reproducer for d_lru-corrupting
races in earlier kernels here.  I wonder if it can be simulated under KVM...

> (The first two commits themselves don't seem to be related but reverting
> them is needed so that the last one can be cleanly reverted).

What I really wonder is what else is going on there; it keeps finding a bunch
of dentries _already_ on shrink list(s) of somebody else.  And spins (with
eviction of everything worthy not already on shrink lists and cond_resched()
thrown in) to give whoever's trying to evict those suckers do their job.

This means that we either have somebody stuck trying to evict a dentry, or
that more and more dentries keep being added and evicted there.  Is somebody
sitting in a subdirectory of invalid one and trying to do lookups there,
perhaps?  But in that case we would have the same livelock in the older
kernels, possibly harder to hit, but still there...

FWIW, older kernels just went ahead, picked those already-on-shrink-list
dentries and did dentry_kill(), hopefully not at the time when the owner of
shrink list got around to removing the neighbor from that list.  With
list corruption in case it happened at just the wrong moment.

I don't have Fedora anywhere outside of KVM test images, and it'll take
a while to inflict it on actual hardware; in the meanwhile, could you
hit alt-sysrq-t after it gets stuck and post the results?  At least that
would give some idea whether it's somebody stuck on trying to evict a dentry
or a stream of new dentries being added and killed there.

AFAICS, kernfs ->d_release() isn't blocking and final iput() there also
doesn't look like it's likely to get stuck, but I'd rather have that
possibility excluded...
