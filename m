Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbaKNKTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:19:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58045 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386AbaKNKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:19:09 -0500
Date: Fri, 14 Nov 2014 10:19:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikey@neuling.org" <mikey@neuling.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "mathieu.desnoyers@polymtl.ca" <mathieu.desnoyers@polymtl.ca>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "matthew.vick@intel.com" <matthew.vick@intel.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH 1/3] arch: Introduce load_acquire() and store_release()
Message-ID: <20141114101902.GA27963@arm.com>
References: <20141113191250.12579.19694.stgit@ahduyck-server>
 <20141113192723.12579.25343.stgit@ahduyck-server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113192723.12579.25343.stgit@ahduyck-server>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu, Nov 13, 2014 at 07:27:23PM +0000, Alexander Duyck wrote:
> It is common for device drivers to make use of acquire/release semantics
> when dealing with descriptors stored in device memory.  On reviewing the
> documentation and code for smp_load_acquire() and smp_store_release() as
> well as reviewing an IBM website that goes over the use of PowerPC barriers
> at http://www.ibm.com/developerworks/systems/articles/powerpc.html it
> occurred to me that the same code could likely be applied to device drivers.
> 
> As a result this patch introduces load_acquire() and store_release().  The
> load_acquire() function can be used in the place of situations where a test
> for ownership must be followed by a memory barrier.  The below example is
> from ixgbe:
> 
>         if (!rx_desc->wb.upper.status_error)
>                 break;
> 
>         /* This memory barrier is needed to keep us from reading
>          * any other fields out of the rx_desc until we know the
>          * descriptor has been written back
>          */
>         rmb();
> 
> With load_acquire() this can be changed to:
> 
>         if (!load_acquire(&rx_desc->wb.upper.status_error))
>                 break;

I still don't think this is a good idea for the specific use-case you're
highlighting.

On ARM, an mb() can be *significantly* more expensive than an rmb() (since
we may have to drain store buffers on an outer L2 cache) and on arm64 it's
not at all clear that an LDAR is more efficient than an LDR; DMB LD
sequence. I can certainly imagine implementations where the latter would
be preferred.

So, whilst I'm perfectly fine to go along with mandatory acquire/release
macros (we should probably add a check to barf on __iomem pointers), I
don't agree with using them in preference to finer-grained read/write
barriers. Doing so will have a real impact on I/O performance.

Finally, do you know of any architectures where load_acquire/store_release
aren't implemented the same way as the smp_* variants on SMP kernels?

Will
