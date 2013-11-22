Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3KVTQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:16:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab3KVTP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:15:59 -0500
Date: Fri, 22 Nov 2013 17:14:29 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131122191429.GA13308@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:25PM +0800, Xiao Guangrong wrote:
> It likes nulls list and we use the pte-list as the nulls which can help us to
> detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
> if that happened
> 
> kvm->slots_lock is held when we do lockless walking that prevents rmap
> is reused (free rmap need to hold that lock) so that we can not see the same
> nulls used on different rmaps
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

How about simplified lockless walk on the slot while rmapp entry
contains a single spte? (which should be the case with two-dimensional
paging).

That is, grab the lock when finding a rmap with more than one spte in
it (and then keep it locked until the end).

For example, nothing prevents lockless walker to move into some
parent_ptes chain, right?

Also, there is no guarantee of termination (as long as sptes are
deleted with the correct timing). BTW, can't see any guarantee of
termination for rculist nulls either (a writer can race with a lockless
reader indefinately, restarting the lockless walk every time).

