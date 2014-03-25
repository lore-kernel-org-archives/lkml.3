Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaCYSUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:20:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49415 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaCYSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:19:54 -0400
Date: Tue, 25 Mar 2014 14:19:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, mgorman@suse.de,
        akpm@linux-foundation.org, steven@uplinklabs.net,
        boris.ostrovsky@oracle.com
Cc: David Sutton <kantras@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 1/2] Revert "xen: properly account for
 _PAGE_NUMA during xen pte translations"
Message-ID: <20140325181939.GA11073@phenom.dumpdata.com>
References: <CAPCj91+c8kE8dgp7U3N1ti=XOzFrgcg3Z3S9dYK4AG1tEMqsaA@mail.gmail.com>
 <5331B94F.9020601@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5331B94F.9020601@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:13:51PM +0000, David Vrabel wrote:
> On 25/03/14 15:28, David Sutton wrote:
> > David,
> > 
> >> This reverts commit a9c8e4beeeb64c22b84c803747487857fe424b68.
> >>
> > Please note: this particular patch also helped to resolve an issue
> > reported by some of the people using the xen package under Arch Linux,
> > where they would see stability issues running certain software
> > (particularly firefox) under dom0 - the software would start crashing
> > under relatively light usage, with a kernel BUG message.
> 
> We are aware that Xen PV guests will not work if CONFIG_NUMA_BALANCING
> is enabled with this revert.  But that patch introduced fundamental
> breakage to how a guest must read/write non-present page tables entries
> which caused even worse breakage.
> 
> I suspect that the problematic patch 1667918b6483 ("mm: numa: clear numa
> hinting information on mprotect") is not needed on x86 and could be
> safely reverted as a temporarily fix.

Hey Andrew,

In the rc3 time-frame Steve Noonan (Amazon EC2 engineering) found an issue
with Mel's "mm: numa: clear numa hinting information on mprotect" patch
(see http://lists.xen.org/archives/html/xen-devel/2014-02/msg00169.html)

A patch was proposed, looked good, you took it in and .. an rc later I
realized that migration was busted (of course only seen on my automated
test system). Boris Ostrovsky took a look and after a lot of digging realized
that it is an general issue wherein we lose page's contents after a migration
if they have been treated with the hinting information. I saw it with
'iscsid' halting, but Boris confirmed that it is a general problem:

"This can be easily triggered by Linux' page-types
(tools/vm/page-types.c) after save/restore.

All it does is it walks the page tables (in fs/proc/task_mmu.c) and
eventually trips on bad page. For example:

# /page-types -p  2273 -L> /tmp/new
[ 2634.501440] pfn 0x159f75 highest_memmap_pfn=0x3ffff
[ 2634.502345] BUG: Bad page map in process page-types pte:159f75420
pmd:3178a067
"
Which means that any application should be able to trigger this depending
on whether 'mprotect' was doing its stuff and migration happend.

Please note that these guests have no NUMA information exposed at all.

I should also mention that the initial report was reproduced when
CONFIG_NUMA_BALANCING was enabled, and the 'xen: properly account for _PAGE_NUMA
during xen pte translations' fixed that. However it introduced another
bug that can be seen with either CONFIG_NUMA_BALANCING enabled or disabled.

So, we are reverting the 'xen: properly account for _PAGE_NUMA during xen pte translations'
and an GIT PULL to Linus was sent today with said revert along with
another fix. However going forward there needs to be a fix for the
regression that '("mm: numa: clear numa hinting information on mprotect'
introduced.

David Vrabel is furiously trying to figure out a nice fix that will satisfy
everybody - and Linus has been saying he might do an rc8 - but Linus might
change his mind and the fix might take more than a week to be hammered out,
tested, Acked, etc.

With that in mind I was wondering whether it would be possible to revert 
Mel's 1667918b6483 ("mm: numa: clear numa hinting information on mprotect")
so there is a bit more time in 3.15 to re-introduce his patch and also a
proper fix so that Xen guests won't fall flat on their face?

Thanks!
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
