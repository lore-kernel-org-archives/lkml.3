Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaDUR4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:56:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:33667 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaDUR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:56:20 -0400
Message-ID: <53555BBE.2020804@parallels.com>
Date: Mon, 21 Apr 2014 21:56:14 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Glauber Costa <glommer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>, <devel@openvz.org>
Subject: Re: [RFC] how should we deal with dead memcgs' kmem caches?
References: <5353A3E3.4020302@parallels.com> <alpine.DEB.2.10.1404211128450.28094@gentwo.org>
In-Reply-To: <alpine.DEB.2.10.1404211128450.28094@gentwo.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.04.2014 20:29, Christoph Lameter:
> On Sun, 20 Apr 2014, Vladimir Davydov wrote:
> 
>> * Way #1 - prevent dead kmem caches from caching slabs on free *
>>
>> We can modify sl[au]b implementation so that it won't cache any objects
>> on free if the kmem cache belongs to a dead memcg. Then it'd be enough
>> to drain per-cpu pools of all dead kmem caches on css offline - no new
>> slabs will be added there on further frees, and the last object will go
>> away along with the last slab.
> 
> You can call kmem_cache_shrink() to force slab allocators to drop cached
> objects after a free.

Yes, but the question is when and how often should we do that? Calling
it after each kfree would be an overkill, because there may be plenty of
objects in a dead cache. Calling it periodically or on vmpressure is the
first thing that springs to mind - that's covered by "way #2".

Thanks.
