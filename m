Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3KYGLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 01:11:45 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59873 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3KYGLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 01:11:44 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <20131122191429.GA13308@amt.cnet>
Date: Mon, 25 Nov 2013 14:11:31 +0800
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1822)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112506-5816-0000-0000-00000B0C4134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23, 2013, at 3:14 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Wed, Oct 23, 2013 at 09:29:25PM +0800, Xiao Guangrong wrote:
>> It likes nulls list and we use the pte-list as the nulls which can help us to
>> detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
>> if that happened
>> 
>> kvm->slots_lock is held when we do lockless walking that prevents rmap
>> is reused (free rmap need to hold that lock) so that we can not see the same
>> nulls used on different rmaps
>> 
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> How about simplified lockless walk on the slot while rmapp entry
> contains a single spte? (which should be the case with two-dimensional
> paging).
> 
> That is, grab the lock when finding a rmap with more than one spte in
> it (and then keep it locked until the end).

Hmm… that isn't straightforward and more complex than the approach
in this patchset. Also it can drop the improvement for shadow mmu that
gets great improvement by this patchset.

> 
> For example, nothing prevents lockless walker to move into some
> parent_ptes chain, right?

No.

The nulls can help us to detect this case, for parent_ptes, the nulls points
to "shadow page" but for rmaps, the nulls points to slot.arch.rmap. There
is no chance that the “rmap" is used as shadow page when slot-lock is held.

> 
> Also, there is no guarantee of termination (as long as sptes are
> deleted with the correct timing). BTW, can't see any guarantee of
> termination for rculist nulls either (a writer can race with a lockless
> reader indefinately, restarting the lockless walk every time).

Hmm, that can be avoided by checking dirty-bitmap before rewalk,
that means, if the dirty-bitmap has been set during lockless write-protection,
it’s unnecessary to write-protect its sptes. Your idea?

But… do we really need to care it. :(






