Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaKRWsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:48:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbaKRWsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:48:37 -0500
Message-ID: <546BCC73.3050903@redhat.com>
Date: Tue, 18 Nov 2014 14:47:15 -0800
From: Alexander Duyck <alexander.h.duyck@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        donald.c.skidmore@intel.com, matthew.vick@intel.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, nic_swsd@realtek.com,
        Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Tony Luck <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 0/4] Add lightweight memory barriers for coherent memory
 access
References: <20141118172644.26303.37688.stgit@ahduyck-server> <CA+55aFw3ygP8UEF1vidWdjBUEkqXOELCPkpjLMD-X=vXXQEGOQ@mail.gmail.com>
In-Reply-To: <CA+55aFw3ygP8UEF1vidWdjBUEkqXOELCPkpjLMD-X=vXXQEGOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 12:53 PM, Linus Torvalds wrote:
> On Tue, Nov 18, 2014 at 9:28 AM, Alexander Duyck
> <alexander.h.duyck@redhat.com> wrote:
>> These patches introduce two new primitives for synchronizing cache coherent
>> memory writes and reads.  These two new primitives are:
>>
>>          coherent_rmb()
>>          coherent_wmb()
>
> So I'm still not convinced about the name. I don't hate it, but if you
> ever want to do "read_acquire", then that whole "coherent_" thing does
> make for a big mouthful. I don't see why "dma" isn't simpler and more
> to the point, and has the advantage of lining up (in documentation
> etc) with "smp".

The problem is DMA is a broad brush.  There are multiple cases I can 
think of where DMA does not represent coherent memory.

> Why would you ever use "coherent_xyz()" on something that isn't about
> dma? If it's cache-coherent memory without DMA, you'd use "smp_xyz()",
> so I really do prefer that whole "dma-vs-smp" issue, because it talks
> about what is actually the important issue. All sane memory is
> coherent, after all (and if it isn't, you have other issues than
> memory ordering).
>
>                    Linus

This barrier only applies to a subset of DMA memory types.  So yes, 
"coherent_xyz()" only applies to DMA, but not all DMA memory is coherent 
as it could be a non-coherent or streaming DMA mapping.

One spot where the name makes sense is in the headers themselves.  To 
avoid duplication of definitions in several spots if CONFIG_SMP was 
defined I simply defined smp_xyz() as coherent_xyz().  Defining it as 
dma_xyz() might have made that more difficult to read in terms of what 
was going on.

- Alex
