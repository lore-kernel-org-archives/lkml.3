Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab3EWMUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:20:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844Ab3EWMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:20:07 -0400
Message-ID: <519E095A.4000105@redhat.com>
Date: Thu, 23 May 2013 08:19:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org>
In-Reply-To: <519DCE2A.4010801@meduna.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 04:07 AM, Stanislav Meduna wrote:
> On 22.05.2013 20:43, Rik van Riel wrote:
>
>>> Some CPUs have had errata when it comes to flushing large pages that
>>> have been split into small pages by hardware, e.g. due to MTRR
>>> conflicts.  In that case, fragments of the large page may have been left
>>> in the TLB.
>
> Can I somehow find if this is the case? The memory mapping
> for the failing process has two regions slightly larger than
> 4 MB - code and heap.
>
> The process also does not access any funny memory regions
> from userspace - it is basically networking (both TCP/IP
> and raw sockets) and crunching of the data received.
> No mmapped devices or something like that.
>
>> static inline void __native_flush_tlb_single(unsigned long addr)
>> {
>>          __flush_tlb();
>> }
>>
>> This on top of the other two patches.
>
> It did not crash overnight, but it also does not show any
> minor fault counted for the threads, so I'm afraid the situation
> just did not happen - there should be at least one visible in
> the ps -o min_flt output, right?

If all the page faults are done by he main thread,
and the TLB gets properly flushed now, the other
threads might not see minor faults.

> I will give it some more testing time.

That is a good idea.

Now to figure out how we properly fix this
issue in the kernel...

We can add a bit in the architecture bits that
we use to check against other CPU and system
errata, and conditionally flush the whole TLB
from __native_flush_tlb_single().

The question is, how do we identify what CPUs
need the extra flushing?

And in what circumstances do they require it?
