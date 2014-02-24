Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaBXMli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:41:38 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:39633 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBXMlh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 24 Feb 2014 07:41:37 -0500
Message-Id: <530B4C0C020000780011EC0D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 24 Feb 2014 12:41:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Borkmann" <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <davem@davemloft.net>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <ffusco@redhat.com>, <tgraf@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com>
 <5308938A.8070506@redhat.com>
 <530B0AF2020000780011E97B@nat28.tlf.novell.com>
 <530B1D60.8010602@redhat.com>
 <530B32A4020000780011EACB@nat28.tlf.novell.com>
 <530B3102.4050102@redhat.com> <530B3BDB.3010908@zytor.com>
In-Reply-To: <530B3BDB.3010908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.02.14 at 13:32, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 02/24/2014 03:46 AM, Daniel Borkmann wrote:
>>>>>>>
>>>>>>> --- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
>>>>>>> +++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
>>>>>>> @@ -37,7 +37,7 @@
>>>>>>>     #include <asm/cpufeature.h>
>>>>>>>     #include <asm/hash.h>
>>>>>>>
>>>>>>> -static inline u32 crc32_u32(u32 crc, u32 val)
>>>>>>> +static inline u32 crc32_u32(u32 val, u32 crc)
>>>>>>>     {
>>>>>>>     #ifdef CONFIG_AS_CRC32
>>>>>>>         asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
>>>>>>
> 
> OK, this whole tread is really confusing, but the change proposed seems 
> actively wrong.
> 
> First of all:
> 
> static inline uint32_t
> rte_hash_crc_4byte(uint32_t data, uint32_t init_val)
> {
> 	return _mm_crc32_u32(data, init_val);
> }
> 
> ... from the DPDK code is confusing all by itself, because the 
> definition of the _mm_crc32_u32() intrinsic per the Intel SDM is:
> 
> unsigned int _mm_crc32_u32(unsigned int crc, unsigned int data);
> 
> ... where "crc" is the destination operand, i.e. the accumulator if you 
> actually would be computing a CRC32C.
> 
> So I'm guessing this hash is deliberately using the CRC32 instruction 
> "backwards", which would actually make sense: an actual CRC is actually 
> a pretty poor hash due to linearity.
> 
> This has confused people elsewhere, too:
> 
> http://permalink.gmane.org/gmane.comp.networking.dpdk.devel/954 
> 
> So if this is a bug it is a bug in the upstream code, but I'm guessing 
> the operand reversal is intentional.

Ah, right. So the issue really is that this should have been stated
somewhere explicitly, avoiding the confusion.

> Therefore, this patch should be actively NAKed.
> 
> Nacked-by: H. Peter Anvin <hpa@zytor.com>

Agreed based on the above.

Jan

