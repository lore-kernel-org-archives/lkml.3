Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LFAQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:16:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3LFAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:16:39 -0500
Date: Thu, 5 Dec 2013 22:15:54 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131206001554.GA28698@amt.cnet>
References: <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
 <5292EE2F.5090305@linux.vnet.ibm.com>
 <20131125181254.GB21858@amt.cnet>
 <529413C1.60302@linux.vnet.ibm.com>
 <20131126193148.GA18071@amt.cnet>
 <5297049E.3020800@linux.vnet.ibm.com>
 <529D83F8.7050605@linux.vnet.ibm.com>
 <20131205135021.GA12996@amt.cnet>
 <F8A4D0B5-9900-48F3-9CA3-23A5A8CC0B4B@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F8A4D0B5-9900-48F3-9CA3-23A5A8CC0B4B@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:30:27PM +0800, Xiao Guangrong wrote:
> > Is it not the case that simply moving to the slow path once a maximum of
> > rewalks has been reached enough? (looks a like a good solution).
> 
> In some cases, the lockless walker will do endless-walking on desc and
> without rewalk, consider this case:
> 
> there are two descs: desc1 and desc2 who is pointed by desc1->next：
> desc1->next = desc2.
> 
> CPU 0                                                                            CPU 1
> 
> lockless walk on desc1
>                                                                  deleting desc1 from the rmap
> lockless walk on desc2 (desc1->next)
>                                                                 delete desc2 from the rmap
>                                                                 add desc1
>                                                                 add desc2, then desc2->next = desc1
> 
> lockless walk on desc1
>                                                                delete desc2
>                                                                delete desc1
>                                                                add desc2
>                                                                add desc1; the desc1->next = desc2
> lockless walk on desc2
> 
> ……
> 
> Then, the walker is endlessly walking on desc1 and desc2 without any rewalk.

Ouch, this is the sort of thing that is worrysome. Do you still think
that having the benefit for shadow is important enough to justify this
complexity?

Also, another separate possibility is to use the dirty bit (which recent
Intel processors support). Then there are no faults at all to handle.


