Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3JJTRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab3JJTRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:17:06 -0400
Date: Thu, 10 Oct 2013 22:16:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/15] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-ID: <20131010191646.GE15954@redhat.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131008012355.GA3588@amt.cnet>
 <CAD6C3B4-DD55-47EB-9BC0-17867937AE2D@gmail.com>
 <20131009015627.GA4816@amt.cnet>
 <525533DB.1060104@gmail.com>
 <20131010014710.GA2198@amt.cnet>
 <20131010120845.GT3574@redhat.com>
 <20131010164222.GB3211@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010164222.GB3211@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 01:42:22PM -0300, Marcelo Tosatti wrote:
> On Thu, Oct 10, 2013 at 03:08:45PM +0300, Gleb Natapov wrote:
> > On Wed, Oct 09, 2013 at 10:47:10PM -0300, Marcelo Tosatti wrote:
> > > > >> Gleb has a idea that uses RCU_DESTORY to protect the shadow page table
> > > > >> and encodes the page-level into the spte (since we need to check if the spte
> > > > >> is the last-spte. ).  How about this?
> > > > > 
> > > > > Pointer please? Why is DESTROY_SLAB_RCU any safer than call_rcu with
> > > > > regards to limitation? (maybe it is).
> > > > 
> > > > For my experience, freeing shadow page and allocing shadow page are balanced,
> > > > we can check it by (make -j12 on a guest with 4 vcpus and):
> > > > 
> > > > # echo > trace
> > > > [root@eric-desktop tracing]# cat trace > ~/log | sleep 3
> > > > [root@eric-desktop tracing]# cat ~/log | grep new | wc -l
> > > > 10816
> > > > [root@eric-desktop tracing]# cat ~/log | grep prepare | wc -l
> > > > 10656
> > > > [root@eric-desktop tracing]# cat set_event
> > > > kvmmmu:kvm_mmu_get_page
> > > > kvmmmu:kvm_mmu_prepare_zap_page
> > > > 
> > > > alloc VS. free = 10816 : 10656
> > > > 
> > > > So that, mostly all allocing and freeing are done in the slab's
> > > > cache and the slab frees shdadow pages very slowly, there is no rcu issue.
> > > 
> > > A more detailed test case would be:
> > > 
> > > - cpu0-vcpu0 releasing pages as fast as possible
> > > - cpu1 executing get_dirty_log
> > > 
> > > Think of a very large guest.
> > > 
> > The number of shadow pages allocated from slab will be bounded by
> > n_max_mmu_pages, 
> 
> Correct, but that limit is not suitable (maximum number of mmu pages
> should be larger than number of mmu pages freeable in a rcu grace
> period).
> 
I am not sure I understand what you mean here. What I was sating is that if
we change code to allocate sp->spt from slab, this slab will never have
more then n_max_mmu_pages objects in it.

> > and, in addition, page released to slab is immediately
> > available for allocation, no need to wait for grace period. 
> 
> See SLAB_DESTROY_BY_RCU comment at include/linux/slab.h.
> 
This comment is exactly what I was referring to in the code you quoted. Do
you see anything problematic in what comment describes?

--
			Gleb.
