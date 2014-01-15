Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaAOIrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:47:45 -0500
Received: from relay.parallels.com ([195.214.232.42]:42421 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAOIrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:47:43 -0500
Message-ID: <52D64B27.30604@parallels.com>
Date: Wed, 15 Jan 2014 12:47:35 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: shrink all slab objects if tight on memory
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com> <20140113150502.4505f661589a4a2d30e6f11d@linux-foundation.org> <52D4E5F2.5080205@parallels.com> <20140114141453.374bd18e5290876177140085@linux-foundation.org>
In-Reply-To: <20140114141453.374bd18e5290876177140085@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 02:14 AM, Andrew Morton wrote:
> On Tue, 14 Jan 2014 11:23:30 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> On 01/14/2014 03:05 AM, Andrew Morton wrote:
>>> That being said, I think I'll schedule this patch as-is for 3.14.  Can
>>> you please take a look at implementing the simpler approach, send me
>>> something for 3.15-rc1?
>> IMHO the simpler approach (Glauber's patch) is not suitable as is,
>> because it, in fact, neglects the notion of batch_size when doing low
>> prio scans, because it calls ->scan() for < batch_size objects even if
>> the slab has >= batch_size objects while AFAIU it should accumulate a
>> sufficient number of objects to scan in nr_deferred instead.
> Well.  If you mean that when nr-objects=large and batch_size=32 and
> total_scan=33, the patched code will scan 32 objects and then 1 object
> then yes, that should be fixed.

I mean if nr_objects=large and batch_size=32 and shrink_slab() is called
8 times with total_scan=4, we can either call ->scan() 8 times with
nr_to_scan=4 (Glauber's patch) or call it only once with nr_to_scan=32
(that's how it works now). Frankly, after a bit of thinking I am
starting to doubt that this can affect performance at all provided the
shrinker is implemented in a sane way, because as you've mentioned
shrink_slab() is already a slow path. It seems I misunderstood the
purpose of batch_size initially: I though we need it to limit the number
of calls to ->scan(), but now I guess the only purpose of it is limiting
the number of objects scanned in one pass to avoid latency issues. But
then another question arises - why do you think the behavior you
described above (scanning 32 and then 1 object if total_scan=33,
batch_size=32) is bad? In other words why can't we make the scan loop
look like this:

    while (total_scan > 0) {
        unsigned long ret;
        unsigned long nr_to_scan = min(total_scan, batch_size);

        shrinkctl->nr_to_scan = nr_to_scan;
        ret = shrinker->scan_objects(shrinker, shrinkctl);
        if (ret == SHRINK_STOP)
            break;
        freed += ret;

        count_vm_events(SLABS_SCANNED, nr_to_scan);
        total_scan -= nr_to_scan;

        cond_resched();
    }

?

Thanks.
