Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaJVPzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:55:36 -0400
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:59030 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbaJVPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:55:29 -0400
Message-Id: <20141022155517.560385718@linux.com>
Date: Wed, 22 Oct 2014 10:55:17 -0500
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for RT) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had to insert a preempt enable/disable in the fastpath a while ago. This
was mainly due to a lot of state that is kept to be allocating from the per
cpu freelist. In particular the page field is not covered by
this_cpu_cmpxchg used in the fastpath to do the necessary atomic state
change for fast path allocation and freeing.

This patch removes the need for the page field to describe the state of the
per cpu list. The freelist pointer can be used to determine the page struct
address if necessary.

However, currently this does not work for the termination value of a list
which is NULL and the same for all slab pages. If we use a valid pointer
into the page as well as set the last bit then all freelist pointers can
always be used to determine the address of the page struct and we will not
need the page field anymore in the per cpu are for a slab. Testing for the
end of the list is a test if the first bit is set.

So the first patch changes the termination pointer for freelists to do just
that. The second removes the page field and then third can then remove the
preempt enable/disable.

There are currently a number of caveats because we are adding calls to
page_address() and virt_to_head_page() in a number of code paths. These
can hopefully be removed one way or the other.

Removing the ->page field reduces the cache footprint of the fastpath so hopefully overall
allocator effectiveness will increase further. Also RT uses full preemption which means
that currently pretty expensive code has to be inserted into the fastpath. This approach
allows the removal of that code and a corresponding performance increase.



