Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3GPBvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3GPBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:51:42 -0400
Message-ID: <51E4A719.4020703@redhat.com>
Date: Mon, 15 Jul 2013 21:51:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        "AneeshKumarK.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: per-vma instantiation mutexes
References: <1373671681.2448.10.camel@buesod1.americas.hpqcorp.net> <alpine.LNX.2.00.1307121729590.3899@eggly.anvils> <1373858204.13826.9.camel@buesod1.americas.hpqcorp.net> <20130715072432.GA28053@voom.fritz.box>
In-Reply-To: <20130715072432.GA28053@voom.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:24 AM, David Gibson wrote:
> On Sun, Jul 14, 2013 at 08:16:44PM -0700, Davidlohr Bueso wrote:

>>> Reading the existing comment, this change looks very suspicious to me.
>>> A per-vma mutex is just not going to provide the necessary exclusion, is
>>> it?  (But I recall next to nothing about these regions and
>>> reservations.)
>
> A per-VMA lock is definitely wrong.  I think it handles one form of
> the race, between threads sharing a VM on a MAP_PRIVATE mapping.
> However another form of the race can and does occur between different
> MAP_SHARED VMAs in the same or different processes.  I think there may
> be edge cases involving mremap() and MAP_PRIVATE that will also be
> missed by a per-VMA lock.
>
> Note that the libhugetlbfs testsuite contains tests for both PRIVATE
> and SHARED variants of the race.

Can we get away with simply using a mutex in the file?
Say vma->vm_file->mapping->i_mmap_mutex?

That might help with multiple processes initializing
multiple shared memory segments at the same time, and
should not hurt the case of a process mapping its own
hugetlbfs area.

It might have the potential to hurt when getting private
copies on a MAP_PRIVATE area, though.  I have no idea
how common it is for multiple processes to MAP_PRIVATE
the same hugetlbfs file, though...

-- 
All rights reversed
