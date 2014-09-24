Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaIXQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:07:18 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:35948 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbaIXQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:07:15 -0400
Message-ID: <5422EC30.10206@nexus-software.ie>
Date: Wed, 24 Sep 2014 17:07:12 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org> <5422E8D0.5080705@zytor.com> <5422EA13.1080706@nexus-software.ie>
In-Reply-To: <5422EA13.1080706@nexus-software.ie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/14 16:58, Bryan O'Donoghue wrote:
>
>>
>> I believe there is one more change needed: there is a __flush_tlb_all()
>> in the early code which gets executed before the above code runs; the
>> easiest fix is to just add a __flush_tlb() immediately after it.
>>
>> This should have been pushed upstream, and not stayed in the BSP kernel.
>
> Peter.
>
> You're talking about void __init setup_arch() right ?
>
> The code looks like this
>
> load_cr3(swapper_pg_dir);
> __flush_tlb_all();
>
> Note that on Quark the method to invalidate the TLB is by reloading CR3
> - which is immediately prior to __flush_tlb_all();
>
> So __flush_tlb_all(); will do nothing but that's OK since load_cr3()
> already flushed the TLB - including any PTE with PGE set

I take your point though.

It's probably better to be explicit and do the whole

if (quark)
	__flush_tlb();
else
	__flush_tlb_all();

So that we aren't relying on the side effects of the previous statement.

