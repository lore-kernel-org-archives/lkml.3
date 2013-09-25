Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3IYOfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:35:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50028 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755867Ab3IYOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:35:39 -0400
Date: Wed, 25 Sep 2013 10:35:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20130925103535.2249f617@gandalf.local.home>
In-Reply-To: <1380105868-31985-3-git-send-email-liuj97@gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 18:44:22 +0800
Jiang Liu <liuj97@gmail.com> wrote:
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 8541c3a..50facfc 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -15,6 +15,8 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  #include <linux/kernel.h>
> +#include <linux/stop_machine.h>
> +#include <asm/cacheflush.h>
>  #include <asm/insn.h>
>  
>  static int aarch64_insn_cls[] = {
> @@ -69,3 +71,65 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>  	return __aarch64_insn_hotpatch_safe(old_insn) &&
>  	       __aarch64_insn_hotpatch_safe(new_insn);
>  }
> +
> +struct aarch64_insn_patch {
> +	void	*text_addr;
> +	u32	*new_insns;
> +	int	insn_cnt;
> +};
> +
> +int __kprobes __aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
> +{
> +	int i;
> +	u32 *tp = addr;
> +
> +	/* instructions must be word aligned */
> +	if (cnt <= 0 || ((uintptr_t)addr & 0x3))
> +		return -EINVAL;

On aarch64, are instructions always word aligned? If not, it should be
safe for stop machine to modify non word aligned instructions, but this
patch looks like it doesn't allow stop_machine() to do so.

-- Steve

> +
> +	for (i = 0; i < cnt; i++)
> +		tp[i] = insns[i];
> +
> +	flush_icache_range((uintptr_t)tp, (uintptr_t)tp + cnt * sizeof(u32));
> +
> +	return 0;
> +}
> +
> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
> +{
> +	struct aarch64_insn_patch *pp = arg;
> +
> +	return __aarch64_insn_patch_text(pp->text_addr, pp->new_insns,
> +					 pp->insn_cnt);
> +}
> +
> +int __kprobes aarch64_insn_patch_text(void *addr, u32 *insns, int cnt)
> +{
> +	int ret;
> +	bool safe = false;
> +
> +	/* instructions must be word aligned */
> +	if (cnt <= 0 || ((uintptr_t)addr & 0x3))
> +		return -EINVAL;
> +
> +	if (cnt == 1)
> +		safe = aarch64_insn_hotpatch_safe(*(u32 *)addr, insns[0]);
> +
> +	if (safe) {
> +		ret = __aarch64_insn_patch_text(addr, insns, cnt);
> +	} else {
> +		struct aarch64_insn_patch patch = {
> +			.text_addr = addr,
> +			.new_insns = insns,
> +			.insn_cnt = cnt,
> +		};
> +
> +		/*
> +		 * Execute __aarch64_insn_patch_text() on every online CPU,
> +		 * which ensure serialization among all online CPUs.
> +		 */
> +		ret = stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> +	}
> +
> +	return ret;
> +}

