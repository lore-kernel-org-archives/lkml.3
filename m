Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaHRN5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHRN5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:57:51 -0400
Message-ID: <53F20653.2030204@redhat.com>
Date: Mon, 18 Aug 2014 15:57:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@kernel.org
CC: avi.kivity@gmail.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/08/2014 09:01, Xiao Guangrong ha scritto:
> -	update_memslots(slots, new, kvm->memslots->generation);
> +	/* ensure generation number is always increased. */
> +	slots->generation = old_memslots->generation;
> +	update_memslots(slots, new);
>  	rcu_assign_pointer(kvm->memslots, slots);
>  	synchronize_srcu_expedited(&kvm->srcu);
> +	slots->generation++;

I don't trust my brain enough to review this patch.

kvm_current_mmio_generation seems like a very bad (race-prone) API.  One
patch I trust myself reviewing would change a bunch of functions in
kvm_main.c to take a memslots struct.  This would make it easy to
respect the hard and fast rule of not dereferencing the same pointer
twice.  But it would be a tedious change.

Another alternative could be to use the low bit to mark an in-progress
change, and skip the caching if the low bit is set.  Similar to a
seqcount (except if read_seqcount_retry fails, we just punt and not
retry anything), you could use it even though the memory barriers
provided by write_seqcount_begin/end are not too useful in this case.

Paolo
