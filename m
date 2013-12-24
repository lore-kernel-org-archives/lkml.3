Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3LXHps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 02:45:48 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59045 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3LXHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 02:45:47 -0500
X-AuditID: 9c930197-b7c4aae000003d84-f0-52b93ba9bd7e
Date: Tue, 24 Dec 2013 16:45:46 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
Message-ID: <20131224074546.GB27156@lge.com>
References: <52B1C143.8080301@oracle.com>
 <52B871B2.7040409@oracle.com>
 <20131224025127.GA2835@lge.com>
 <52B8F8F6.1080500@oracle.com>
 <20131224060705.GA16140@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131224060705.GA16140@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 03:07:05PM +0900, Joonsoo Kim wrote:
> On Mon, Dec 23, 2013 at 10:01:10PM -0500, Sasha Levin wrote:
> > On 12/23/2013 09:51 PM, Joonsoo Kim wrote:
> > >On Mon, Dec 23, 2013 at 12:24:02PM -0500, Sasha Levin wrote:
> > >>>Ping?
> > >>>
> > >>>I've also Cc'ed the "this page shouldn't be locked at all" team.
> > >Hello,
> > >
> > >I can't find the reason of this problem.
> > >If it is reproducible, how about bisecting?
> > 
> > While it reproduces under fuzzing it's pretty hard to bisect it with
> > the amount of issues uncovered by trinity recently.
> > 
> > I can add any debug code to the site of the BUG if that helps.
> 
> Good!
> It will be helpful to add dump_page() in migration_entry_to_page().
> 
> Thanks.
> 

Minchan teaches me that there is possible race condition between
fork and migration.

Please consider following situation.


Process A (do migration)			Process B (parents) Process C (child)

try_to_unmap() for migration <begin>		fork
setup migration entry to B's vma
...
try_to_unmap() for migration <end>
move_to_new_page()

						link new vma
						    into interval tree
remove_migration_ptes() <begin>
check and clear migration entry on C's vma
...						copy_one_pte:
...						    now, B and C have migration entry
...
...
check and clear migration entry on B's vma
...
...
remove_migration_ptes() <end>


Eventually, migration entry on C's vma is left.
And then, when C exits, above BUG_ON() can be triggered.

I'm not sure the I am right, so please think of it together. :)
And I'm not sure again that above assumption is related to this trigger report,
since this may exist for a long time.

So my question to mm folks is is above assumption possible and do we have
any protection mechanism on this race?

Thanks.
