Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaFEHi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:38:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:51966 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaFEHiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:38:55 -0400
Message-ID: <1401953908.3247.121.camel@pasglop>
Subject: Re: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 05 Jun 2014 17:38:28 +1000
In-Reply-To: <1401953144-19186-4-git-send-email-aik@ozlabs.ru>
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
	 <1401953144-19186-4-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 17:25 +1000, Alexey Kardashevskiy wrote:
> +This creates a virtual TCE (translation control entry) table, which
> +is an IOMMU for PAPR-style virtual I/O.  It is used to translate
> +logical addresses used in virtual I/O into guest physical addresses,
> +and provides a scatter/gather capability for PAPR virtual I/O.
> +
> +/* for KVM_CAP_SPAPR_TCE_64 */
> +struct kvm_create_spapr_tce_64 {
> +       __u64 liobn;
> +       __u64 window_size;
> +       __u64 bus_offset;
> +       __u32 page_shift;
> +       __u32 flags;
> +};
> +
> +The liobn field gives the logical IO bus number for which to create a
> +TCE table. The window_size field specifies the size of the DMA window
> +which this TCE table will translate - the table will contain one 64
> +bit TCE entry for every IOMMU page. The bus_offset field tells where
> +this window is mapped on the IO bus. 

Hrm, the bus_offset cannot be set arbitrarily, it has some pretty strong
HW limits depending on the type of bridge & architecture version...

Do you plan to have that knowledge in qemu ? Or do you have some other
mechanism to query it ? (I might be missing a piece of the puzzle here).

Also one thing I've been pondering ...

We'll end up wasting a ton of memory with those TCE tables. If you have
3 PEs mapped into a guest, it will try to create 3 DDW's mapping the
entire guest memory and so 3 TCE tables large enough for that ... and
which will contain exactly the same entries !

We really want to look into extending PAPR to allow the creation of
table "aliases" so that the guest can essentially create one table and
associate it with multiple PEs. We might still decide to do multiple
copies for NUMA reasons but no more than one per node for example... at
least we can have the policy in qemu/kvm.

Also, do you currently require allocating a single physically contiguous
table or do you support TCE trees in your implementation ?

Cheers,
Ben.

