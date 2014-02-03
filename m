Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaBCKFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:05:52 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33209 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBCKFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:05:51 -0500
MIME-Version: 1.0
In-Reply-To: <52EF3DBF.3000404@parallels.com>
References: <cover.1391356789.git.vdavydov@parallels.com>
	<570a97e4dfaded0939a9ddbea49055019dcc5803.1391356789.git.vdavydov@parallels.com>
	<alpine.DEB.2.02.1402022219101.10847@chino.kir.corp.google.com>
	<52EF3DBF.3000404@parallels.com>
Date: Mon, 3 Feb 2014 14:05:50 +0400
Message-ID: <CAA6-i6p5V4SvmtABw6xC7M4M86tUrAFEVyHaOP8uqse3Az1iHg@mail.gmail.com>
Subject: Re: [PATCH 1/8] memcg: export kmemcg cache id via cgroup fs
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 10:57 AM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> On 02/03/2014 10:21 AM, David Rientjes wrote:
>> On Sun, 2 Feb 2014, Vladimir Davydov wrote:
>>
>>> Per-memcg kmem caches are named as follows:
>>>
>>>   <global-cache-name>(<cgroup-kmem-id>:<cgroup-name>)
>>>
>>> where <cgroup-kmem-id> is the unique id of the memcg the cache belongs
>>> to, <cgroup-name> is the relative name of the memcg on the cgroup fs.
>>> Cache names are exposed to userspace for debugging purposes (e.g. via
>>> sysfs in case of slub or via dmesg).
>>>
>>> Using relative names makes it impossible in general (in case the cgroup
>>> hierarchy is not flat) to find out which memcg a particular cache
>>> belongs to, because <cgroup-kmem-id> is not known to the user. Since
>>> using absolute cgroup names would be an overkill, let's fix this by
>>> exporting the id of kmem-active memcg via cgroup fs file
>>> "memory.kmem.id".
>>>
>> Hmm, I'm not sure exporting additional information is the best way to do
>> it only for this purpose.  I do understand the problem in naming
>> collisions if the hierarchy isn't flat and we typically work around that
>> by ensuring child memcgs still have a unique memcg.  This isn't only a
>> problem in slab cache naming, me also avoid printing the entire absolute
>> names for things like the oom killer.
>
> AFAIU, cgroup identifiers dumped on oom (cgroup paths, currently) and
> memcg slab cache names serve for different purposes. The point is oom is
> a perfectly normal situation for the kernel, and info dumped to dmesg is
> for admin to find out the cause of the problem (a greedy user or
> cgroup). On the other hand, slab cache names are dumped to dmesg only on
> extraordinary situations - like bugs in slab implementation, or double
> free, or detected memory leaks - where we usually do not need the name
> of the memcg that triggered the problem, because the bug is likely to be
> in the kernel subsys using the cache. Plus, the names are exported to
> sysfs in case of slub, again for debugging purposes, AFAIK. So IMO the
> use cases for oom vs slab names are completely different - information
> vs debugging - and I want to export kmem.id only for the ability of
> debugging kmemcg and slab subsystems.
>

Then maybe it is better to wrap it into some kind of CONFIG_DEBUG wrap.
We already have other files like that.

>> So it would be nice to have
>> consensus on how people are supposed to identify memcgs with a hierarchy:
>> either by exporting information like the id like you do here (but leave
>> the oom killer still problematic) or by insisting people name their memcgs
>> with unique names if they care to differentiate them.
>
> Anyway, I agree with you that this needs a consensus, because this is a
> functional change.
>
> Thanks.



-- 
E Mare, Libertas
