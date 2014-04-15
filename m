Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaDOTIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:08:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:38848 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaDOTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:08:34 -0400
Message-ID: <534D83AB.6040107@parallels.com>
Date: Tue, 15 Apr 2014 23:08:27 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, <akpm@linux-foundation.org>,
        <mhocko@suse.cz>, <glommer@gmail.com>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH -mm 1/4] memcg, slab: do not schedule cache destruction
 when last page goes away
References: <cover.1397054470.git.vdavydov@parallels.com> <8ea8b57d5264f16ee33497a4317240648645704a.1397054470.git.vdavydov@parallels.com> <20140415021614.GC7969@cmpxchg.org> <534CD08F.30702@parallels.com> <alpine.DEB.2.10.1404151016400.11231@gentwo.org>
In-Reply-To: <alpine.DEB.2.10.1404151016400.11231@gentwo.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.24.253]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

15.04.2014 19:17, Christoph Lameter:
> On Tue, 15 Apr 2014, Vladimir Davydov wrote:
>
>> 2) When freeing an object of a dead memcg cache, initiate thorough check
>> if the cache is really empty and destroy it then. That could be
>> implemented by poking the reaping thread on kfree, and actually does not
>> require the schedule_work in memcg_release_pages IMO.
>
> There is already logic in both slub and slab that does that on cache
> close.

Yeah, but here the question is when we should close caches left after 
memcg offline. Obviously we should do it after all objects of such a 
cache have gone, but when exactly? Do it immediately after the last 
kfree (have to count objects per cache then AFAIU) or may be check 
periodically (or on vmpressure) that the cache is empty by issuing 
kmem_cache_shrink and looking if memcg_params::nr_pages = 0?

Thanks.
