Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaEWP0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:26:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51665 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaEWP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:26:53 -0400
Date: Fri, 23 May 2014 19:26:43 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
Message-ID: <20140523152642.GD3147@esperanza>
References: <20140516132234.GF32113@esperanza>
 <alpine.DEB.2.10.1405160957100.32249@gentwo.org>
 <20140519152437.GB25889@esperanza>
 <alpine.DEB.2.10.1405191056580.22956@gentwo.org>
 <537A4D27.1050909@parallels.com>
 <alpine.DEB.2.10.1405210937440.8038@gentwo.org>
 <20140521150408.GB23193@esperanza>
 <alpine.DEB.2.10.1405211912400.4433@gentwo.org>
 <20140522134726.GA3147@esperanza>
 <alpine.DEB.2.10.1405221422390.15766@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405221422390.15766@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 02:25:30PM -0500, Christoph Lameter wrote:
> slab_free calls __slab_free which can release slabs via
> put_cpu_partial()/unfreeze_partials()/discard_slab() to the page
> allocator. I'd rather have preemption enabled there.

Hmm, why? IMO, calling __free_pages with preempt disabled won't hurt
latency, because it proceeds really fast. BTW, we already call it for a
bunch of pages from __slab_free() -> put_cpu_partial() ->
unfreeze_partials() with irqs disabled, which is harder. FWIW, SLAB has
the whole obj free path executed under local_irq_save/restore, and it
doesn't bother enabling irqs for freeing pages.

IMO, the latency improvement we can achieve by enabling preemption while
calling __free_pages is rather minor, and it isn't worth complicating
the code.

Thanks.
