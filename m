Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3JWQ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:26:54 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43822 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3JWQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:26:52 -0400
Message-ID: <5267F7B7.5060203@linux.vnet.ibm.com>
Date: Wed, 23 Oct 2013 21:52:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        tony.luck@intel.com, matthew.garrett@nebula.com, riel@redhat.com,
        arjan@linux.intel.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mark.gross@intel.com
Subject: Re: [RFC PATCH v4 16/40] mm: Introduce a "Region Allocator" to manage
 entire memory regions
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <20130925231730.26184.19552.stgit@srivatsabhat.in.ibm.com> <20131023101012.GB2043@cmpxchg.org>
In-Reply-To: <20131023101012.GB2043@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102316-1618-0000-0000-000004DA1333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 03:40 PM, Johannes Weiner wrote:
> On Thu, Sep 26, 2013 at 04:47:34AM +0530, Srivatsa S. Bhat wrote:
>> Today, the MM subsystem uses the buddy 'Page Allocator' to manage memory
>> at a 'page' granularity. But this allocator has no notion of the physical
>> topology of the underlying memory hardware, and hence it is hard to
>> influence memory allocation decisions keeping the platform constraints
>> in mind.
> 
> This is no longer true after patches 1-15 introduce regions and have
> the allocator try to stay within the lowest possible region (patch
> 15).

Sorry, the changelog is indeed misleading. What I really meant to say
here is that there is no way to keep an entire region homogeneous with
respect to allocation types: ie., have only a single type of allocations
(like movable). Patches 1-15 don't address that problem. The later ones
do.

>  Which leaves the question what the following patches are for.
> 

The region allocator is meant to help in keeping entire memory regions
homogeneous with respect to allocations. This helps in increasing the
success rate of targeted region evacuation. For example, if we know
that the region has only unmovable allocations, we can completely skip
compaction/evac on that region. And this can be determined just by looking
at the pageblock migratetype of *one* of the pages of that region; thus
its very cheap. Similarly, if we know that the region has only movable
allocations, we can try compaction on that when its lightly allocated.
And we won't have horrible scenarios where we moved say 15 pages and then
found out that there is an unmovable page stuck in that region, making
all that previous work go waste.

> This patch only adds a data structure and I gave up finding where
> among the helpers, statistics, and optimization patches an actual
> implementation is.
> 

I hope the patch-wise explanation that I gave in the other mail will
help make this understandable. Please do let me know if you need any
other clarifications.

> Again, please try to make every single a patch a complete logical
> change to the code base.

Sure, I'll strive for that in the next postings.

Regards,
Srivatsa S. Bhat

