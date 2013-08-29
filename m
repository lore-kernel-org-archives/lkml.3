Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3H2Jv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3H2Jv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:51:28 -0400
Date: Thu, 29 Aug 2013 12:51:20 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130829095120.GD22899@redhat.com>
References: <20130828092001.GQ22899@redhat.com>
 <521DC3FD.1020507@linux.vnet.ibm.com>
 <20130828094630.GR22899@redhat.com>
 <521DCD57.7000401@linux.vnet.ibm.com>
 <20130828104938.GT22899@redhat.com>
 <521DE9E8.2040908@linux.vnet.ibm.com>
 <20130828133635.GU22899@redhat.com>
 <521EEF4B.4040107@linux.vnet.ibm.com>
 <20130829090833.GA22899@redhat.com>
 <521F14FE.3070900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F14FE.3070900@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 05:31:42PM +0800, Xiao Guangrong wrote:
> > As Documentation/RCU/whatisRCU.txt says:
> > 
> >         As with rcu_assign_pointer(), an important function of
> >         rcu_dereference() is to document which pointers are protected by
> >         RCU, in particular, flagging a pointer that is subject to changing
> >         at any time, including immediately after the rcu_dereference().
> >         And, again like rcu_assign_pointer(), rcu_dereference() is
> >         typically used indirectly, via the _rcu list-manipulation
> >         primitives, such as list_for_each_entry_rcu().
> > 
> > The documentation aspect of rcu_assign_pointer()/rcu_dereference() is
> > important. The code is complicated, so self documentation will not hurt.
> > I want to see what is actually protected by rcu here. Freeing shadow
> > pages with call_rcu() further complicates matters: does it mean that
> > shadow pages are also protected by rcu? 
> 
> Yes, it stops shadow page to be freed when we do write-protection on
> it.
> 
Yeah, I got the trick, what I am saying that we have a data structure
here protected by RCU, but we do not use RCU functions to access it...
BTW why not allocate sp->spt from SLAB_DESTROY_BY_RCU cache too? We may
switch write protection on a random spt occasionally if page is deleted
and reused for another spt though. For last level spt it should not be a
problem and for non last level we have is_last_spte() check in
__rmap_write_protect_lockless(). Can it work?

--
			Gleb.
