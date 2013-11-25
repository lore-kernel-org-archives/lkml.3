Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3KYK7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:59:36 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35742 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3KYK7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:59:33 -0500
Message-ID: <52932D8C.2080308@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 18:59:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet> <20131125093157.GU10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131125093157.GU10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112510-4790-0000-0000-00000B80DCF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

On 11/25/2013 05:31 PM, Peter Zijlstra wrote:
> On Fri, Nov 22, 2013 at 05:14:29PM -0200, Marcelo Tosatti wrote:
>> Also, there is no guarantee of termination (as long as sptes are
>> deleted with the correct timing). BTW, can't see any guarantee of
>> termination for rculist nulls either (a writer can race with a lockless
>> reader indefinately, restarting the lockless walk every time).
> 
> What's an rculist null? 

I guess Marcelo was talking about rculist_nulls.h
(Documentation/RCU/rculist_nulls.txt).

> rculists have regular termination conditions,
> they'll reach the end (also head, due to circular etc..) in N steps,
> where N is the number of elements.
> 
> Of course you can keep adding elements to protract this situation, but
> you'll run out of memory eventually -- you also have to make sure to
> insert them after the element being read, otherwise the iteration will
> simply miss them.
> 
> Deleting an element preserves the element itself -- it has to be
> RCU-freed to be part of an rculist, and the element also preserves its
> fwd link, so any iterator will either not see the element, or if they're
> at the element, they'll continue their iteration as normal (rculist
> doesn't have backward iterators).
> 
> A deleted element may not be re-used before an RCU grace period has
> lapsed. Same as for freeing such an element. So if you want to move an
> rculist element you need to:
> 
>   list_del_rcu()
>   synchronize_rcu();
>   list_add_rcu();
> 
> Or use the list_splice_init_rcu() primitive which also explicitly takes
> a @sync argument.

Thanks for your detailed explanation, Peter!

What about if the element is allocated from SLAB_DESTROY_BY_RCU slab? That
means the element may be reused while do iteration.


