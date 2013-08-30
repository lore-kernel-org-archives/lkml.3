Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3H3Loc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab3H3Lob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:44:31 -0400
Date: Fri, 30 Aug 2013 14:44:26 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130830114426.GB1844@redhat.com>
References: <521DC3FD.1020507@linux.vnet.ibm.com>
 <20130828094630.GR22899@redhat.com>
 <521DCD57.7000401@linux.vnet.ibm.com>
 <20130828104938.GT22899@redhat.com>
 <521DE9E8.2040908@linux.vnet.ibm.com>
 <20130828133635.GU22899@redhat.com>
 <521EEF4B.4040107@linux.vnet.ibm.com>
 <20130829093141.GC22899@redhat.com>
 <521F319B.9000006@linux.vnet.ibm.com>
 <521F3856.70305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F3856.70305@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 08:02:30PM +0800, Xiao Guangrong wrote:
> On 08/29/2013 07:33 PM, Xiao Guangrong wrote:
> > On 08/29/2013 05:31 PM, Gleb Natapov wrote:
> >> On Thu, Aug 29, 2013 at 02:50:51PM +0800, Xiao Guangrong wrote:
> >>> After more thinking, I still think rcu_assign_pointer() is unneeded when a entry
> >>> is removed. The remove-API does not care the order between unlink the entry and
> >>> the changes to its fields. It is the caller's responsibility:
> >>> - in the case of rcuhlist, the caller uses call_rcu()/synchronize_rcu(), etc to
> >>>   enforce all lookups exit and the later change on that entry is invisible to the
> >>>   lookups.
> >>>
> >>> - In the case of rculist_nulls, it seems refcounter is used to guarantee the order
> >>>   (see the example from Documentation/RCU/rculist_nulls.txt).
> >>>
> >>> - In our case, we allow the lookup to see the deleted desc even if it is in slab cache
> >>>   or its is initialized or it is re-added.
> >>>
> >> BTW is it a good idea? We can access deleted desc while it is allocated
> >> and initialized to zero by kmem_cache_zalloc(), are we sure we cannot
> >> see partially initialized desc->sptes[] entry? On related note what about
> >> 32 bit systems, they do not have atomic access to desc->sptes[].
> 
> Ah... wait. desc is a array of pointers:
> 
> struct pte_list_desc {
> 	u64 *sptes[PTE_LIST_EXT];
> 	struct pte_list_desc *more;
> };
> 
Yep, I misread it to be u64 bits and wondered why do we use u64 to store
pointers.

> assigning a pointer is aways aotomic, but we should carefully initialize it
> as you said. I will introduce a constructor for desc slab cache which initialize
> the struct like this:
> 
> for (i = 0; i < PTE_LIST_EXT; i++)
> 	desc->sptes[i] = NULL;
> 
> It is okay.
> 
I hope slab does not write anything into allocated memory internally if
constructor is present. BTW do you know what happens when SLAB debug is enabled
and SLAB_DESTROY_BY_RCU is set? Does poison value is written into freed
object (freed to slab, but not yet to page allocator)?

--
			Gleb.
