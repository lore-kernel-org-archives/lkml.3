Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab3JPQeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:34:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46840 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3JPQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:34:05 -0400
Message-ID: <525EBFE1.2060103@gmail.com>
Date: Thu, 17 Oct 2013 00:33:37 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] arm64: move encode_insn_immediate() from module.c
 to insn.c
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com> <1381893492-7135-4-git-send-email-liuj97@gmail.com> <20131016112222.GG5403@mudshark.cambridge.arm.com>
In-Reply-To: <20131016112222.GG5403@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 07:22 PM, Will Deacon wrote:
> On Wed, Oct 16, 2013 at 04:18:08AM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Function encode_insn_immediate() will be used by other instruction
>> manipulate related functions, so move it into insn.c and rename it
>> as aarch64_insn_encode_immediate().
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/arm64/include/asm/insn.h |  14 ++++
>>  arch/arm64/kernel/insn.c      |  77 +++++++++++++++++++++
>>  arch/arm64/kernel/module.c    | 151 +++++++++---------------------------------
>>  3 files changed, 123 insertions(+), 119 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
>> index 2dfcdb4..8dc0a91 100644
>> --- a/arch/arm64/include/asm/insn.h
>> +++ b/arch/arm64/include/asm/insn.h
>> @@ -28,6 +28,18 @@ enum aarch64_insn_class {
>>                                          * system instructions */
>>  };
>>
>> +enum aarch64_insn_imm_type {
>> +       AARCH64_INSN_IMM_MOVNZ,
>> +       AARCH64_INSN_IMM_MOVK,
>> +       AARCH64_INSN_IMM_ADR,
>> +       AARCH64_INSN_IMM_26,
>> +       AARCH64_INSN_IMM_19,
>> +       AARCH64_INSN_IMM_16,
>> +       AARCH64_INSN_IMM_14,
>> +       AARCH64_INSN_IMM_12,
>> +       AARCH64_INSN_IMM_9,
>> +};
>> +
>>  #define        __AARCH64_INSN_FUNCS(abbr, mask, val)   \
>>  static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
>>  { return (code & (mask)) == (val); }   \
>> @@ -47,6 +59,8 @@ __AARCH64_INSN_FUNCS(nop,     0xFFFFFFFF, 0xD503201F)
>>  #undef __AARCH64_INSN_FUNCS
>>
>>  enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
>> +u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>> +                                 u32 insn, u64 imm);
>>  u32 aarch64_insn_read(void *addr);
>>  void aarch64_insn_write(void *addr, u32 insn);
>>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>> index ad4185f..90cc312 100644
>> --- a/arch/arm64/kernel/insn.c
>> +++ b/arch/arm64/kernel/insn.c
>> @@ -179,3 +179,80 @@ int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
>>         else
>>                 return aarch64_insn_patch_text_sync(addrs, insns, cnt);
>>  }
>> +
>> +u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>> +                                 u32 insn, u64 imm)
>> +{
>> +       u32 immlo, immhi, lomask, himask, mask;
>> +       int shift;
>> +
>> +       switch (type) {
>> +       case AARCH64_INSN_IMM_MOVNZ:
>> +               /*
>> +                * For signed MOVW relocations, we have to manipulate the
>> +                * instruction encoding depending on whether or not the
>> +                * immediate is less than zero.
>> +                */
>> +               insn &= ~(3 << 29);
>> +               if ((s64)imm >= 0) {
>> +                       /* >=0: Set the instruction to MOVZ (opcode 10b). */
>> +                       insn |= 2 << 29;
>> +               } else {
>> +                       /*
>> +                        * <0: Set the instruction to MOVN (opcode 00b).
>> +                        *     Since we've masked the opcode already, we
>> +                        *     don't need to do anything other than
>> +                        *     inverting the new immediate field.
>> +                        */
>> +                       imm = ~imm;
>> +               }
> 
> I'm really not comfortable with this. This code is performing static
> relocations and re-encoding instructions as required by the AArch64 ELF
> spec. That's not really what you'd expect from a generic instruction
> encoder!
Thanks for reminder, will move above code back into module.c.
Thanks!
Gerry

> 
> Will
> 

