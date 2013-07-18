Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3GRImk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:42:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48651 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3GRImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:42:37 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-9b-51e7aa7be347
Date: Thu, 18 Jul 2013 17:42:35 +0900
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
Message-ID: <20130718084235.GA9761@lge.com>
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
> From: David Gibson <david@gibson.dropbear.id.au>
> 
> At present, the page fault path for hugepages is serialized by a
> single mutex. This is used to avoid spurious out-of-memory conditions
> when the hugepage pool is fully utilized (two processes or threads can
> race to instantiate the same mapping with the last hugepage from the
> pool, the race loser returning VM_FAULT_OOM).  This problem is
> specific to hugepages, because it is normal to want to use every
> single hugepage in the system - with normal pages we simply assume
> there will always be a few spare pages which can be used temporarily
> until the race is resolved.
> 
> Unfortunately this serialization also means that clearing of hugepages
> cannot be parallelized across multiple CPUs, which can lead to very
> long process startup times when using large numbers of hugepages.
> 
> This patch improves the situation by replacing the single mutex with a
> table of mutexes, selected based on a hash, which allows us to know
> which page in the file we're instantiating. For shared mappings, the
> hash key is selected based on the address space and file offset being faulted.
> Similarly, for private mappings, the mm and virtual address are used.
> 

Hello.

With this table mutex, we cannot protect region tracking structure.
See below comment.

/*
 * Region tracking -- allows tracking of reservations and instantiated pages
 *                    across the pages in a mapping.
 *
 * The region data structures are protected by a combination of the mmap_sem
 * and the hugetlb_instantion_mutex.  To access or modify a region the caller
 * must either hold the mmap_sem for write, or the mmap_sem for read and
 * the hugetlb_instantiation mutex:
 *
 *      down_write(&mm->mmap_sem);
 * or
 *      down_read(&mm->mmap_sem);
 *      mutex_lock(&hugetlb_instantiation_mutex);
 */

Thanks.
