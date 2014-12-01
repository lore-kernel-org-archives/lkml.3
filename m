Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaLAIwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:52:25 -0500
Received: from ozlabs.org ([103.22.144.67]:34253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaLAIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:52:23 -0500
Message-ID: <1417423941.25107.2.camel@concordia>
Subject: Re: [PATCH v2] slab: Fix nodeid bounds check for non-contiguous
 node IDs
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        linuxppc-dev@ozlabs.org, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 01 Dec 2014 19:52:21 +1100
In-Reply-To: <20141201052448.GC11234@drongo>
References: <20141201042844.GB11234@drongo>
	 <1417410134.16178.2.camel@concordia> <20141201052448.GC11234@drongo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 16:24 +1100, Paul Mackerras wrote:
> On Mon, Dec 01, 2014 at 04:02:14PM +1100, Michael Ellerman wrote:
> > On Mon, 2014-12-01 at 15:28 +1100, Paul Mackerras wrote:
> > > The bounds check for nodeid in ____cache_alloc_node gives false
> > > positives on machines where the node IDs are not contiguous, leading
> > > to a panic at boot time.  For example, on a POWER8 machine the node
> > > IDs are typically 0, 1, 16 and 17.  This means that num_online_nodes()
> > > returns 4, so when ____cache_alloc_node is called with nodeid = 16 the
> > > VM_BUG_ON triggers, like this:
> > ...
> > > 
> > > To fix this, we instead compare the nodeid with MAX_NUMNODES, and
> > > additionally make sure it isn't negative (since nodeid is an int).
> > > The check is there mainly to protect the array dereference in the
> > > get_node() call in the next line, and the array being dereferenced is
> > > of size MAX_NUMNODES.  If the nodeid is in range but invalid (for
> > > example if the node is off-line), the BUG_ON in the next line will
> > > catch that.
> > 
> > When did this break? How come we only just noticed?
> 
> Commit 14e50c6a9bc2, which went into 3.10-rc1.

OK. So a Fixes tag is nice:

Fixes: 14e50c6a9bc2 ("mm: slab: Verify the nodeid passed to ____cache_alloc_node")

> You'll only notice if you have CONFIG_SLAB=y and CONFIG_DEBUG_VM=y
> and you're running on a machine with discontiguous node IDs.

Right. And we have SLUB=y for all the defconfigs that are likely to hit that.

> > Also needs:
> > 
> > Cc: stable@vger.kernel.org
> 
> It does.  I remembered that a minute after I sent the patch.

OK. Hopefully one of the slab maintainers will be happy to add it for us when
they merge this?

cheers



