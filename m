Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaLAFZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:25:11 -0500
Received: from ozlabs.org ([103.22.144.67]:48025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaLAFZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:25:10 -0500
Date: Mon, 1 Dec 2014 16:24:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        linuxppc-dev@ozlabs.org, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2] slab: Fix nodeid bounds check for non-contiguous node
 IDs
Message-ID: <20141201052448.GC11234@drongo>
References: <20141201042844.GB11234@drongo>
 <1417410134.16178.2.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417410134.16178.2.camel@concordia>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:02:14PM +1100, Michael Ellerman wrote:
> On Mon, 2014-12-01 at 15:28 +1100, Paul Mackerras wrote:
> > The bounds check for nodeid in ____cache_alloc_node gives false
> > positives on machines where the node IDs are not contiguous, leading
> > to a panic at boot time.  For example, on a POWER8 machine the node
> > IDs are typically 0, 1, 16 and 17.  This means that num_online_nodes()
> > returns 4, so when ____cache_alloc_node is called with nodeid = 16 the
> > VM_BUG_ON triggers, like this:
> ...
> > 
> > To fix this, we instead compare the nodeid with MAX_NUMNODES, and
> > additionally make sure it isn't negative (since nodeid is an int).
> > The check is there mainly to protect the array dereference in the
> > get_node() call in the next line, and the array being dereferenced is
> > of size MAX_NUMNODES.  If the nodeid is in range but invalid (for
> > example if the node is off-line), the BUG_ON in the next line will
> > catch that.
> 
> When did this break? How come we only just noticed?

Commit 14e50c6a9bc2, which went into 3.10-rc1.

You'll only notice if you have CONFIG_SLAB=y and CONFIG_DEBUG_VM=y
and you're running on a machine with discontiguous node IDs.

> Also needs:
> 
> Cc: stable@vger.kernel.org

It does.  I remembered that a minute after I sent the patch.

Paul.
