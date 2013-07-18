Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab3GRJHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:07:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49200 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3GRJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:07:21 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-eb-51e7b047b040
Date: Thu, 18 Jul 2013 18:07:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        "AneeshKumarK.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Eric B Munson <emunson@mgebm.net>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] hugepage: allow parallelization of the hugepage fault
 path
Message-ID: <20130718090719.GB9761@lge.com>
References: <1373671681.2448.10.camel@buesod1.americas.hpqcorp.net>
 <alpine.LNX.2.00.1307121729590.3899@eggly.anvils>
 <1373858204.13826.9.camel@buesod1.americas.hpqcorp.net>
 <20130715072432.GA28053@voom.fritz.box>
 <20130715160802.9d0cdc0ee012b5e119317a98@linux-foundation.org>
 <1374090625.15271.2.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374090625.15271.2.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:50:25PM -0700, Davidlohr Bueso wrote:

> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
> 
> - Cleaned up and forward ported to Linus' latest.
> - Cache aligned mutexes.
> - Keep non SMP systems using a single mutex.
> 
> It was found that this mutex can become quite contended
> during the early phases of large databases which make use of huge pages - for instance
> startup and initial runs. One clear example is a 1.5Gb Oracle database, where lockstat
> reports that this mutex can be one of the top 5 most contended locks in the kernel during
> the first few minutes:
> 
>     	     hugetlb_instantiation_mutex:   10678     10678
>              ---------------------------
>              hugetlb_instantiation_mutex    10678  [<ffffffff8115e14e>] hugetlb_fault+0x9e/0x340
>              ---------------------------
>              hugetlb_instantiation_mutex    10678  [<ffffffff8115e14e>] hugetlb_fault+0x9e/0x340
> 
> contentions:          10678
> acquisitions:         99476
> waittime-total: 76888911.01 us

Hello,
I have a question :)

So, each contention takes 7.6 ms in your result.
Do you map this area with VM_NORESERVE?
If we map with VM_RESERVE, when page fault, we just dequeue a huge page from a queue and clear
a page and then map it to a page table. So I guess, it shouldn't take so long.
I'm wondering why it takes so long.

And do you use 16KB-size hugepage?
If so, region handling could takes some times. If you access the area as random order,
the number of region can be more than 90000. I guess, this can be one reason to too long
waittime.

Thanks.
