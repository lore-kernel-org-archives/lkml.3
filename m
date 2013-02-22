Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3BVPAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:00:24 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:11589 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756181Ab3BVPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:00:21 -0500
Date: Fri, 22 Feb 2013 15:00:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
In-Reply-To: <1361529030-17462-1-git-send-email-glommer@parallels.com>
Message-ID: <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Glauber Costa wrote:

> Although not verified in practice, I also point out that it is not safe to scan
> the full list only when debugging is on in this case. As unlikely as it is, it
> is theoretically possible for the pages to be full. If they are, they will
> become unreachable. Aside from scanning the full list, we also need to make
> sure that the pages indeed sit in there: the easiest way to do it is to make
> sure the boot caches have the SLAB_STORE_USER debug flag set.

SLAB_STORE_USER typically increases the size of the managed object. It is
not available when slab debugging is not compiled in. There is no list of
full slab objects that is maintained in the non debug case and if the
allocator is compiled without debug support also the code to manage full
lists will not be present.

Only one or two kmem_cache item is allocated in the bootstrap code and so
far the size of the objects was signficantly smaller than page size. So
the slab pages will be on the partial lists. Why are your slab management
structures so large that a page can no longer contain multiple objects?

If you have that issue then I would suggest to find another way to track
the early object (you could f.e. determine the page addresses from the
object and go through the slab pages like that).
