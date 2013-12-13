Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LMPz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:55:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab3LMPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:55:27 -0500
Date: Fri, 13 Dec 2013 15:54:31 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131213155431.GH19177@mudshark.cambridge.arm.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
 <1386691433-6827-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386691433-6827-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:03:48PM +0000, Jiang Liu wrote:
> Introduce three interfaces to patch kernel and module code:
> aarch64_insn_patch_text_nosync():
> 	patch code without synchronization, it's caller's responsibility
> 	to synchronize all CPUs if needed.
> aarch64_insn_patch_text_sync():
> 	patch code and always synchronize with stop_machine()
> aarch64_insn_patch_text():
> 	patch code and synchronize with stop_machine() if needed
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h |  10 +++-
>  arch/arm64/kernel/insn.c      | 117 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 126 insertions(+), 1 deletion(-)

Two comments on the patching callback...

> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
> +{
> +	int i, ret = 0;
> +	struct aarch64_insn_patch *pp = arg;
> +
> +	/* The first CPU becomes master */
> +	if (atomic_inc_return(&pp->cpu_count) == 1) {
> +		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
> +			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
> +							     pp->new_insns[i]);
> +		/* Make sure changes are visible to other CPUs and let them continue */
> +		smp_wmb();

As I mentioned last time, you can rely on aarch64_insn_patch_text_nosync to
enforce ordering (flush_icache_range ends with dsb; isb). Just add a comment
saying that.

> +		atomic_set(&pp->cpu_count, -1);
> +	} else {
> +		while (atomic_read(&pp->cpu_count) != -1)
> +			cpu_relax();
> +		smp_rmb();

You don't need the smp_rmb here.

Will
