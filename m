Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3KFQcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:32:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59803 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KFQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:32:04 -0500
Message-ID: <527A6EFB.4080000@gmail.com>
Date: Thu, 07 Nov 2013 00:31:55 +0800
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
Subject: Re: [PATCH v5 4/7] arm64: introduce aarch64_insn_gen_{nop|branch_imm}()
 helper functions
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com> <1382109602-27432-5-git-send-email-liuj97@gmail.com> <20131030004840.GC25346@mudshark.cambridge.arm.com>
In-Reply-To: <20131030004840.GC25346@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 08:48 AM, Will Deacon wrote:
> On Fri, Oct 18, 2013 at 04:19:58PM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Introduce aarch64_insn_gen_{nop|branch_imm}() helper functions, which
>> will be used to implement jump label on ARM64.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/arm64/include/asm/insn.h | 13 +++++++++++++
>>  arch/arm64/kernel/insn.c      | 28 ++++++++++++++++++++++++++++
>>  2 files changed, 41 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
>> index 8f94e48..ee4a60d 100644
>> --- a/arch/arm64/include/asm/insn.h
>> +++ b/arch/arm64/include/asm/insn.h
>> @@ -96,9 +96,22 @@ static __always_inline void aarch64_insn_write(void *addr, u32 insn)
>>  	*(u32 *)addr = cpu_to_le32(insn);
>>  }
>>  
>> +static __always_inline u32 aarch64_insn_gen_hint(enum aarch64_insn_hint_op op)
>> +{
>> +	return aarch64_insn_get_hint_value() | op;
> 
> What's the point in that helper function? Does it just return an immediate
> value (and are there are other users of it?).
It just returns a const value. The helper function is just for ease
maintainence.

> 
>> +}
>> +
>> +static __always_inline u32 aarch64_insn_gen_nop(void)
>> +{
>> +	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
>> +}
> 
> Either use plain old `inline' or write these as preprocessor macros.
Will change to normal (non-inline) and add __kprobe property.

> 
>> +
>>  enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
>>  u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>>  				  u32 insn, u64 imm);
>> +u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
>> +				bool link);
>> +
>>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>>  
>>  int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
>> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
>> index 886821f..f7498cc 100644
>> --- a/arch/arm64/kernel/insn.c
>> +++ b/arch/arm64/kernel/insn.c
>> @@ -14,6 +14,7 @@
>>   * You should have received a copy of the GNU General Public License
>>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>   */
>> +#include <linux/bitops.h>
>>  #include <linux/compiler.h>
>>  #include <linux/kernel.h>
>>  #include <linux/smp.h>
>> @@ -233,3 +234,30 @@ u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>>  
>>  	return insn;
>>  }
>> +
>> +u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr, bool link)
>> +{
>> +	u32 insn;
>> +	long offset;
>> +
>> +	/*
>> +	 * PC: A 64-bit Program Counter holding the address of the current
>> +	 * instruction. A64 instructions may be word-aligned.
>> +	 */
>> +	BUG_ON((pc & 0x3) || (addr & 0x3));
>> +
>> +	/*
>> +	 * B/BL support [-128M, 128M) offset
>> +	 * ARM64 virtual address arrangement garantees all kernel and module
> 
> Typo: `guarantees'.
Thanks, will fix it.

> 
>> +	 * texts are within +/-128M.
>> +	 */
>> +	offset = ((long)addr - (long)pc) >> 2;
>> +	BUG_ON(abs(offset) > BIT(25) || offset == BIT(25));
> 
> I really struggle to follow this range checking. Why don't you just compare
> the absolute difference between addr and pc with SZ_128M?
Will change code to follow your suggestion.

> 
> Will
> 

