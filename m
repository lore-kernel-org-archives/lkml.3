Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbbAFHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:03:34 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:14076 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbbAFHDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:03:33 -0500
Message-ID: <54AB88C2.7040901@c-s.fr>
Date: Tue, 06 Jan 2015 08:03:30 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v3 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
References: <20141222101450.D7DD11A5E15@localhost.localdomain> <1420481520.25047.15.camel@transmode.se>
In-Reply-To: <1420481520.25047.15.camel@transmode.se>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 05/01/2015 19:12, Joakim Tjernlund a écrit :
> On Mon, 2014-12-22 at 11:14 +0100, Christophe Leroy wrote:
>> On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
>> and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Hi Christophe, been meaning to look over all you recent 8xx MMU/TLB patches
> but got so little time :(
>
> This is very cool (not sure if there will be a performance gain)  but ..
I think every saved cycle is worth it.
Before I did any modification:
* ITLBMiss was 28 instructions.
* DTLBMiss was 32 instructions.
Now, (No MODULES, no CPU6, no CPU15):
* ITLBMiss is 15 instructions
* DTLBMiss is 24 instructions
>>
>>
>> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
>> index caf094a..b4e0c3b 100644
>> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
>> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
>> @@ -178,9 +178,10 @@ static inline unsigned long pte_update(pte_t *p,
>>          andc    %1,%0,%5\n\
>>          or      %1,%1,%6\n\
>>          /* 0x200 == Extended encoding, bit 22 */ \
>> -       /* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
>> +       /* Bit 22 has to be 1 when _PAGE_USER is unset and _PAGE_RO is set */ \
>>          rlwimi  %1,%1,32-2,0x200\n /* get _PAGE_USER */ \
>> -       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RW */ \
>> +       rlwinm  %3,%1,32-1,0x200\n /* get _PAGE_RO */ \
>> +       xori    %3,%3,0x200\n \
>>          or      %1,%3,%1\n\
>>          xori    %1,%1,0x200\n"
>>   "      stwcx.  %1,0,%4\n\
> ... here I expected to loose the existing xori insn instead of adding one?
>
>
Well, I could have xored the PAGE_USER bit instead, but in that case, it 
is not anymore an 'or' but an 'and' that has to be performed between the 
bits, and then all other bits must be set to 1, or the result of the 
'and' shall be inserted using 'rlwimi'. So it would be more 
modifications than just adding an xori, and not less instructions.

Christophe
