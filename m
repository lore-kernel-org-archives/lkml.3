Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3J3At2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:49:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57187 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381Ab3J3At0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:49:26 -0400
Date: Wed, 30 Oct 2013 00:48:40 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] arm64: introduce
 aarch64_insn_gen_{nop|branch_imm}() helper functions
Message-ID: <20131030004840.GC25346@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-5-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382109602-27432-5-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:19:58PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Introduce aarch64_insn_gen_{nop|branch_imm}() helper functions, which
> will be used to implement jump label on ARM64.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h | 13 +++++++++++++
>  arch/arm64/kernel/insn.c      | 28 ++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index 8f94e48..ee4a60d 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -96,9 +96,22 @@ static __always_inline void aarch64_insn_write(void *addr, u32 insn)
>  	*(u32 *)addr = cpu_to_le32(insn);
>  }
>  
> +static __always_inline u32 aarch64_insn_gen_hint(enum aarch64_insn_hint_op op)
> +{
> +	return aarch64_insn_get_hint_value() | op;

What's the point in that helper function? Does it just return an immediate
value (and are there are other users of it?).

> +}
> +
> +static __always_inline u32 aarch64_insn_gen_nop(void)
> +{
> +	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
> +}

Either use plain old `inline' or write these as preprocessor macros.

> +
>  enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
>  u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>  				  u32 insn, u64 imm);
> +u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
> +				bool link);
> +
>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>  
>  int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 886821f..f7498cc 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -14,6 +14,7 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +#include <linux/bitops.h>
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
>  #include <linux/smp.h>
> @@ -233,3 +234,30 @@ u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
>  
>  	return insn;
>  }
> +
> +u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr, bool link)
> +{
> +	u32 insn;
> +	long offset;
> +
> +	/*
> +	 * PC: A 64-bit Program Counter holding the address of the current
> +	 * instruction. A64 instructions may be word-aligned.
> +	 */
> +	BUG_ON((pc & 0x3) || (addr & 0x3));
> +
> +	/*
> +	 * B/BL support [-128M, 128M) offset
> +	 * ARM64 virtual address arrangement garantees all kernel and module

Typo: `guarantees'.

> +	 * texts are within +/-128M.
> +	 */
> +	offset = ((long)addr - (long)pc) >> 2;
> +	BUG_ON(abs(offset) > BIT(25) || offset == BIT(25));

I really struggle to follow this range checking. Why don't you just compare
the absolute difference between addr and pc with SZ_128M?

Will
