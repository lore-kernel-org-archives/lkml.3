Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3H2Jbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab3H2Jbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:31:46 -0400
Date: Thu, 29 Aug 2013 12:31:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130829093141.GC22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130828092001.GQ22899@redhat.com>
 <521DC3FD.1020507@linux.vnet.ibm.com>
 <20130828094630.GR22899@redhat.com>
 <521DCD57.7000401@linux.vnet.ibm.com>
 <20130828104938.GT22899@redhat.com>
 <521DE9E8.2040908@linux.vnet.ibm.com>
 <20130828133635.GU22899@redhat.com>
 <521EEF4B.4040107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521EEF4B.4040107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 02:50:51PM +0800, Xiao Guangrong wrote:
> After more thinking, I still think rcu_assign_pointer() is unneeded when a entry
> is removed. The remove-API does not care the order between unlink the entry and
> the changes to its fields. It is the caller's responsibility:
> - in the case of rcuhlist, the caller uses call_rcu()/synchronize_rcu(), etc to
>   enforce all lookups exit and the later change on that entry is invisible to the
>   lookups.
> 
> - In the case of rculist_nulls, it seems refcounter is used to guarantee the order
>   (see the example from Documentation/RCU/rculist_nulls.txt).
> 
> - In our case, we allow the lookup to see the deleted desc even if it is in slab cache
>   or its is initialized or it is re-added.
> 
BTW is it a good idea? We can access deleted desc while it is allocated
and initialized to zero by kmem_cache_zalloc(), are we sure we cannot
see partially initialized desc->sptes[] entry? On related note what about
32 bit systems, they do not have atomic access to desc->sptes[].

--
			Gleb.
