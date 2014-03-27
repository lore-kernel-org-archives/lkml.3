Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaC0HeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:34:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:46594 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaC0HeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:34:19 -0400
Message-ID: <5333D472.2000606@parallels.com>
Date: Thu, 27 Mar 2014 11:34:10 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, <glommer@gmail.com>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 1/4] sl[au]b: do not charge large allocations to memcg
References: <cover.1395846845.git.vdavydov@parallels.com> <5a5b09d4cb9a15fc120b4bec8be168630a3b43c2.1395846845.git.vdavydov@parallels.com> <20140326215320.GA22656@dhcp22.suse.cz>
In-Reply-To: <20140326215320.GA22656@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 03/27/2014 01:53 AM, Michal Hocko wrote:
> On Wed 26-03-14 19:28:04, Vladimir Davydov wrote:
>> We don't track any random page allocation, so we shouldn't track kmalloc
>> that falls back to the page allocator.
> Why did we do that in the first place? d79923fad95b (sl[au]b: allocate
> objects from memcg cache) didn't tell me much.

I don't know, we'd better ask Glauber about that.

> How is memcg_kmem_skip_account removal related?

The comment this patch removes along with the memcg_kmem_skip_account
check explains that pretty well IMO. In short, we only use
memcg_kmem_skip_account to prevent kmalloc's from charging, which is
crucial for recursion-avoidance in memcg_kmem_get_cache. Since we don't
charge pages allocated from a root (not per-memcg) cache, from the first
glance it would be enough to check for memcg_kmem_skip_account only in
memcg_kmem_get_cache and return the root cache if it's set. However, for
we can also kmalloc w/o issuing memcg_kmem_get_cache (kmalloc_large), we
also need this check in memcg_kmem_newpage_charge. This patch removes
kmalloc_large accounting, so we don't need this check anymore.

Thanks.
