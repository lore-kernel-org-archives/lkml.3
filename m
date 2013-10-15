Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3JOQ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:27:05 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:53393 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab3JOQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:27:03 -0400
Message-ID: <525D6CD4.5090403@c-s.fr>
Date: Tue, 15 Oct 2013 18:27:00 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc 8xx: Fixing memory init issue with CONFIG_PIN_TLB
References: <201310111256.r9BCuepM006243@localhost.localdomain> <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se>
In-Reply-To: <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 11/10/2013 17:13, Joakim Tjernlund a écrit :
> "Linuxppc-dev"
> <linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org>
> wrote on 2013/10/11 14:56:40:
>> Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of memory
> at
>> bootup instead of 8. It is needed for "big" kernels for instance when
> activating
>> CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in init_32
> too,
>> otherwise memory allocation soon fails after startup.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S
> linux-3.11/arch/powerpc/kernel/head_8xx.S
>> --- linux-3.11.org/arch/powerpc/mm/init_32.c   2013-09-02
> 22:46:10.000000000 +0200
>> +++ linux-3.11/arch/powerpc/mm/init_32.c   2013-09-09 11:28:54.000000000
> +0200
>> @@ -213,7 +213,12 @@
>>       */
>>      BUG_ON(first_memblock_base != 0);
>>
>> +#ifdef CONFIG_PIN_TLB
>> +   /* 8xx can only access 24MB at the moment */
>> +   memblock_set_current_limit(min_t(u64, first_memblock_size,
> 0x01800000));
>> +#else
>>      /* 8xx can only access 8MB at the moment */
>>      memblock_set_current_limit(min_t(u64, first_memblock_size,
> 0x00800000));
>> +#endif
>>   }
>>   #endif /* CONFIG_8xx */
> hmm, I think you should always map 24 MB (or less if RAM < 24 MB) and do
> the same
> in head_8xx.S.
>
> Or to keep it simple, just always map at least 16 MB here and in
> head_8xx.S, assuming
> that 16 MB is min RAM for any 8xx system running 3.x kernels.
Yes we could do a more elaborated modification in the future. However it 
also has an impact on the boot loader, so I'm not sure we should make it 
the default without thinking twice.

In the meantime, my patch does take into account the existing situation 
where you have 8Mb by default and 24Mb when you activate CONFIG_PIN_TLB.
I see it as a bug fix and I believe we should include it at least in 
order to allow including in the stable releases.

Do you see any issue with this approach ?

>
> Much of the need for pinning would go away if you adopted my 8MB pages
> from 2.4 to 3.x
>
>     Jocke
>
Christophe
