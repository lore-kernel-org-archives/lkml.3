Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbbA1UYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:24:48 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42510 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbbA1UYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:45 -0500
MIME-Version: 1.0
In-Reply-To: <54C8EE04.6060809@linaro.org>
References: <1422422306-27473-1-git-send-email-behanw@converseincode.com>
	<CAKv+Gu_NCgMmX_LQqi7vtjtP4ofrW+kx8FPgRd4-LWwK=73-xg@mail.gmail.com>
	<54C8EE04.6060809@linaro.org>
Date: Wed, 28 Jan 2015 16:17:15 +0000
Message-ID: <CAKv+Gu8CrMqwqBOF8rYa3RP1=gfCthwP=1k9kQ73v6+Sxwah4A@mail.gmail.com>
Subject: Re: [PATCH] bcm: address clang inline asm incompatibility
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: Behan Webster <behanw@converseincode.com>, bcm@fixthebug.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Porter <mporter@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 14:11, Alex Elder <elder@linaro.org> wrote:
> On 01/28/2015 05:15 AM, Ard Biesheuvel wrote:
>> On 28 January 2015 at 05:18, Behan Webster <behanw@converseincode.com> wrote:
>>> From: Alex Elder <elder@linaro.org>
>>>
>>> My GCC-based build environment likes to call register r12 by the
>>> name "ip" in inline asm.  Behan Webster informed me that his Clang-
>>> based build environment likes "r12" instead.
>>>
>>> Try to make them both happy.
>>>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>> ---
>>>  arch/arm/mach-bcm/bcm_kona_smc.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
>>> index a55a7ec..3937bd5 100644
>>> --- a/arch/arm/mach-bcm/bcm_kona_smc.c
>>> +++ b/arch/arm/mach-bcm/bcm_kona_smc.c
>>> @@ -106,9 +106,14 @@ int __init bcm_kona_smc_init(void)
>>>   * request result appropriately.  This result value is found in r0
>>>   * when the "smc" request completes.
>>>   */
>>> +#ifdef __clang__
>>> +#define R12    "r12"
>>> +#else  /* !__clang__ */
>>> +#define R12    "ip"    /* gcc calls r12 "ip" */
>>> +#endif /* !__clang__ */
>>
>> Why not just use r12 for both?
>
> Yes, that would have been an obvious fix.  But the
> assembler (in the GCC environment) doesn't accept that.
>

Mine has no problems with it at all

$ echo 'mov r12, #0' | arm-linux-gnueabihf-gcc -c -x assembler-with-cpp -

and grepping for r12 under arch/arm suggests the same

-- 
Ard.



>>>  static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
>>>  {
>>> -       register u32 ip asm("ip");      /* Also called r12 */
>>> +       register u32 ip asm(R12);       /* Also called r12 */
>>>         register u32 r0 asm("r0");
>>>         register u32 r4 asm("r4");
>>>         register u32 r5 asm("r5");
>>> @@ -120,7 +125,7 @@ static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
>>>
>>>         asm volatile (
>>>                 /* Make sure we got the registers we want */
>>> -               __asmeq("%0", "ip")
>>> +               __asmeq("%0", R12)
>>>                 __asmeq("%1", "r0")
>>>                 __asmeq("%2", "r4")
>>>                 __asmeq("%3", "r5")
>>> --
>>> 1.9.1
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
