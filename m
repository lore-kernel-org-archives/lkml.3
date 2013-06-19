Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715Ab3FSM0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:26:00 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54125 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSMZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:25:58 -0400
Message-ID: <51C1A34A.7080201@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 20:25:46 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: MMU: document clear_spte_count
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C196E9.2080508@redhat.com> <51C19BA6.2060501@linux.vnet.ibm.com> <51C19C4C.3000800@redhat.com>
In-Reply-To: <51C19C4C.3000800@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061912-3864-0000-0000-000008B3A395
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 07:55 PM, Paolo Bonzini wrote:
> Il 19/06/2013 13:53, Xiao Guangrong ha scritto:
>> On 06/19/2013 07:32 PM, Paolo Bonzini wrote:
>>> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>>>> Document it to Documentation/virtual/kvm/mmu.txt
>>>
>>> While reviewing the docs, I looked at the code.
>>>
>>> Why can't this happen?
>>>
>>>     CPU 1: __get_spte_lockless          CPU 2: __update_clear_spte_slow
>>> ------------------------------------------------------------------------------
>>>                                         write low
>>>     read count
>>>     read low
>>>     read high
>>>                                         write high
>>>     check low and count
>>>                                         update count
>>>
>>> The check passes, but CPU 1 read a "torn" SPTE.
>>
>> In this case, CPU 1 will read the "new low bits" and the "old high bits", right?
>> the P bit in the low bits is cleared when do __update_clear_spte_slow, i.e, it is
>> not present, so the whole value is ignored.
> 
> Indeed that's what the comment says, too.  But then why do we need the
> count at all?  The spte that is read is exactly the same before and
> after the count is updated.

In order to detect repeatedly marking spte present to stop the lockless side
to see present to present change, otherwise, we can get this:

Say spte = 0xa11110001 (high 32bits = 0xa, low 32bit = 0x11110001)

CPU 1: __get_spte_lockless          CPU 2: __update_clear_spte_slow
----------------------------------------------------------------------
read low: low= 0x11110001
                                    clear the spte, then spte = 0x0ull
read high: high = 0x0
                                    set spte to 0xb11110001 (high 32bits = 0xb,
                                    low 32bit = 0x11110001)

read low: 0x11110001 and see
it is not changed.

In this case, CPU 1 see the low bits are not changed, then it tries to access the memory at:
0x11110000.

BTW, we are using tlb to protect lockless walking, the count can be drop after
improving kvm_set_pte_rmapp where is the only place change spte from present to present
without TLB flush.

