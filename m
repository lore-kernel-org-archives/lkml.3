Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbbA1Ugf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:36:35 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46850 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbbA1Ufd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:33 -0500
MIME-Version: 1.0
In-Reply-To: <54C9383D.10901@linaro.org>
References: <1422422306-27473-1-git-send-email-behanw@converseincode.com>
	<CAKv+Gu_NCgMmX_LQqi7vtjtP4ofrW+kx8FPgRd4-LWwK=73-xg@mail.gmail.com>
	<54C8EE04.6060809@linaro.org>
	<CAKv+Gu8CrMqwqBOF8rYa3RP1=gfCthwP=1k9kQ73v6+Sxwah4A@mail.gmail.com>
	<54C91791.9030508@linaro.org>
	<CAKv+Gu8P8eC+bmerCpbSX=USODqE=U7WnLeiCfhHJ8SSVAzPDw@mail.gmail.com>
	<CAKv+Gu9fc_F1iC5NAwaG_ed3RRhYnxEBLbuLgW0Oa_qJ96j-gA@mail.gmail.com>
	<54C9383D.10901@linaro.org>
Date: Wed, 28 Jan 2015 19:38:17 +0000
Message-ID: <CAKv+Gu88G2QqAupD9j4_-t2=0VJGNbWkUViLBM2nUuyuN-PHWA@mail.gmail.com>
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

On 28 January 2015 at 19:27, Alex Elder <elder@linaro.org> wrote:
> On 01/28/2015 01:17 PM, Ard Biesheuvel wrote:
>> On 28 January 2015 at 17:20, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>> On 28 January 2015 at 17:08, Alex Elder <elder@linaro.org> wrote:
>>>> On 01/28/2015 10:17 AM, Ard Biesheuvel wrote:
>>>>> On 28 January 2015 at 14:11, Alex Elder <elder@linaro.org> wrote:
>>>>>> On 01/28/2015 05:15 AM, Ard Biesheuvel wrote:
>>>>>>> On 28 January 2015 at 05:18, Behan Webster <behanw@converseincode.com> wrote:
>>>>>>>> From: Alex Elder <elder@linaro.org>
>>>>>>>>
>>>>>>>> My GCC-based build environment likes to call register r12 by the
>>>>>>>> name "ip" in inline asm.  Behan Webster informed me that his Clang-
>>>>>>>> based build environment likes "r12" instead.
>>>>>>>>
>>>>>>>> Try to make them both happy.
>>>>>>>>
>>>>>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>>>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>>>>>>> ---
>>>>>>>>  arch/arm/mach-bcm/bcm_kona_smc.c | 9 +++++++--
>>>>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
>>>>>>>> index a55a7ec..3937bd5 100644
>>>>>>>> --- a/arch/arm/mach-bcm/bcm_kona_smc.c
>>>>>>>> +++ b/arch/arm/mach-bcm/bcm_kona_smc.c
>>>>>>>> @@ -106,9 +106,14 @@ int __init bcm_kona_smc_init(void)
>>>>>>>>   * request result appropriately.  This result value is found in r0
>>>>>>>>   * when the "smc" request completes.
>>>>>>>>   */
>>>>>>>> +#ifdef __clang__
>>>>>>>> +#define R12    "r12"
>>>>>>>> +#else  /* !__clang__ */
>>>>>>>> +#define R12    "ip"    /* gcc calls r12 "ip" */
>>>>>>>> +#endif /* !__clang__ */
>>>>>>>
>>>>>>> Why not just use r12 for both?
>>>>>>
>>>>>> Yes, that would have been an obvious fix.  But the
>>>>>> assembler (in the GCC environment) doesn't accept that.
>>>>>>
>>>>>
>>>>> Mine has no problems with it at all
>>>>>
>>>>> $ echo 'mov r12, #0' | arm-linux-gnueabihf-gcc -c -x assembler-with-cpp -
>>>>>
>>>>> and grepping for r12 under arch/arm suggests the same
>>>>
>>>> The use of "r12" is fine.  But it's not just the assembler,
>>>> I believe it also involves gcc.
>>>>
>>>> The problem is with the use of the __asmeq(x, y) macro.
>>>>
>>>
>>> Ah right. Apologies for assuming that you had missed something obvious here.
>>> But __asmeq is not the toolchain, it is a local construct #define'd in
>>> compiler.h
>>>
>>>> If I assign the "ip" variable with "r12":
>>>>         register u32 ip asm("r12");     /* Also called ip */
>>>>
>>>> Then that's fine.  However, this line then causes an error:
>>>>                 __asmeq("%0", "r12")
>>>>
>>>> Apparently gcc uses register "ip" when it sees asm("r12").  So
>>>> attempting to verify the desired register got used with __asmeq()
>>>> causes a string mismatch--"ip" is not equal to "r12".
>>>>
>>>> So I could use:
>>>>
>>>>         register u32 ip asm("r12");     /* Also called ip */
>>>>                 ...
>>>>                 __asmeq("%0", "ip")
>>>>
>>>> And that will build.  But it's a little non-intuitive, and
>>>> I suspect that clang might (rightfully) have a failure in
>>>> this __asmeq() call.
>>>>
>>>
>>> In that case, I would strongly suggest fixing the __asmeq () macro
>>> instead, and teach it that ("r12","ip") and ("ip","r12") are fine too.
>>>
>>> The thing is, inline asm is a dodgy area to begin with in terms of
>>> clang-to-gcc compatibility. On arm64, we have been seeing issues where
>>> the width of the register -which is fixed on gcc- is selected based on
>>> the size of that variable, i.e., an int32 gets a w# register and int64
>>> gets a x# register. Imagine debugging that, e.g., a str %0, [xx] that
>>> writes 8 bytes on GCC suddenly only writing 4 bytes when built with
>>> clang.
>>>
>>> If we also start using the preprocessor to conditionalise what is
>>> emitted by inline asm, the waters get even murkier and it becomes even
>>> harder to claim parity between the two.
>>>
>>
>> Something like this perhaps?
>
> So __asmeq() yields true if the register names (strings) are
> equal, or if one is "ip" and the other is "r12" (in either order).
>
> I can't comment on whether it's right in all build environments but
> this looks OK to me, to handle this special case.
>
> I would much rather you generate that patch.  Is that OK?
>

Sure, I can cook up a patch if you guys can confirm that it fixes your
use case. (I tested GCC myself but I don't have clang installed)

-- 
Ard.
