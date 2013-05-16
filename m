Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3EPT5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3EPT5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:57:39 -0400
Date: Thu, 16 May 2013 22:57:35 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/8] KVM: MMU: fast invalidate all pages
Message-ID: <20130516195735.GJ14597@redhat.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1368706673-8530-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130516124349.GC14597@redhat.com>
 <5194DE48.3050208@linux.vnet.ibm.com>
 <20130516134321.GE14597@redhat.com>
 <20130516155728.GF14597@redhat.com>
 <519527CB.6080608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519527CB.6080608@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:39:07AM +0800, Xiao Guangrong wrote:
> On 05/16/2013 11:57 PM, Gleb Natapov wrote:
> 
> > One more thought. With current patch if zap_invalid_page() will be
> > called second time while another zap_invalid_page() is still running
> > (can that happen?) they will both run concurrently fighting for the
> 
> Currently, it can not happen since zap_invalid_page is needed when slot
> is being deleted which protected by slot-lock.
> 
> But we allow it to be concurrent as you commented: we can use it in
> ->release() instead of calling kvm_mmu_zap_all(), in that case, multiple
> call zap_invalid_page() can happen.
> 
That's only during VM destruction, no need to optimize for. 

> > mmu_lock. Is this a problem?
> 
> Are you worry about that it can not progress due to lock contention when
> walking active_list? Zapping at least 10 pages before releasing the lock
> should ensure that it can progress.
Yes, it will progress, but will bounce between two threads after each 10
pages. This is less efficient that letting one thread to finish zapping.
Theoretically we can make one thread wait for the other.

> 
> Do you see any potential issue?
> 
Just thinking out loud :). If this cannot happen during normal
operation, no reason to optimize for it.

--
			Gleb.
