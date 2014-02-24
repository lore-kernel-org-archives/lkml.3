Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBXNBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:01:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaBXNBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:01:39 -0500
Message-ID: <530B429C.2090507@zytor.com>
Date: Mon, 24 Feb 2014 05:01:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Daniel Borkmann <dborkman@redhat.com>
CC: davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <5308938A.8070506@redhat.com> <530B0AF2020000780011E97B@nat28.tlf.novell.com> <530B1D60.8010602@redhat.com> <530B32A4020000780011EACB@nat28.tlf.novell.com> <530B3102.4050102@redhat.com> <530B3BDB.3010908@zytor.com> <530B4C0C020000780011EC0D@nat28.tlf.novell.com> <530B4058.80705@zytor.com>
In-Reply-To: <530B4058.80705@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 04:51 AM, H. Peter Anvin wrote:
> On 02/24/2014 04:41 AM, Jan Beulich wrote:
>>>
>>> So I'm guessing this hash is deliberately using the CRC32 instruction
>>> "backwards", which would actually make sense: an actual CRC is actually
>>> a pretty poor hash due to linearity.
>>>
>
> OK, it really is even more confusing than that.
>
> It does seem like the crc32 instruction really *is* commutative, which
> isn't something I would personally have expected at all.
>
> Given that fact, I suspect the ordering in the DPDK is actually a bug,
> and that we should correct the ordering (which I would do at the call
> sites because it seems to make the code clearer) because it reduces the
> size of the loop by two instructions.
>
> I guess I should find out how to file a bug report against DPDK too...
>

Looking through the DPDK project git history, it seems that this was a 
bug introduced when changing from using inline assembly to using intrinsics:

  static inline uint32_t
  rte_hash_crc_4byte(uint32_t data, uint32_t init_val)
  {
-	asm volatile("crc32 %[data], %[init_val]"
-	             : [init_val]"=r" (init_val)
-	             : [data]"r" (data), "[init_val]" (init_val));
-	return init_val;
+	return _mm_crc32_u32(data, init_val);
  }

The operand order, of course, of the intrinsic being the opposite of 
AT&T-style assembly.

I never expected that the CRC32 operation would be commutative.  Very 
fascinating.

	-hpa

