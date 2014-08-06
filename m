Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaHFOXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:23:37 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:48422 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaHFOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:23:36 -0400
X-Greylist: delayed 2794 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 10:23:36 EDT
Message-ID: <1407335003.3006.38.camel@linaro1.home>
Subject: Re: [RFC PATCH] kprobes: arm: enable OPTPROBES for arm 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, peifeiyue@huawei.com
Date: Wed, 06 Aug 2014 15:23:23 +0100
In-Reply-To: <1407223697-74911-1-git-send-email-wangnan0@huawei.com>
References: <1407223697-74911-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 15:28 +0800, Wang Nan wrote:
> This patch introduce kprobeopt for ARM 32.
> 
> Limitations:
>  - Currently only kernel compiled with ARM ISA is supported.
>
>  - offset between probe point and kprobe pre_handler must not larger
>     than 64MiB. Masami Hiramatsu suggests replacing 2 words, it will
>     make things complex. Futher patch can make such optimization.
> 
> I have tested this patch on qemu vexpress a9 platform.
> 
> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
> ARM instruction is always 4 bytes aligned. This patch replace probed
> instruction by a 'b', branch to trampoline code and then calls
> optimized_callback(). optimized_callback() calls kprobe_handler() to
> execute kprobe handler. It also emulate/simulate replaced instruction.
> 
> When unregistering kprobe, the deferred manner of unoptimizer may leave
> branch instruction before optimizer is called. Different from x86_64,
> which only copy the probed insn after optprobe_template_end and
> reexecute them, this patch call singlestep to emulate/simulate the insn
> directly. Futher patch can optimize this behavior.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

I've not reviewed this patch properly as I don't have time at the moment
to study the details of how optprobes work, but I did give it quick look
over to check that it was using the helper functions like patch_text()
which it does :-). I also spotted one duplication of an existing
function, see inline comment below...

[...]

> +static inline int
> +arm_branch_to_addr(unsigned int *pinst, void *src, void *dest)
> +{
> +	unsigned int inst = 0xea000000;
> +	long offset = (unsigned long)(dest) -
> +			((unsigned long)(src) + 8);
> +	if ((offset > 0x3fffffc) || (offset < -0x3fffffc)) {
> +		printk(KERN_WARNING "Failed to instrument %pS to %pS\n", src, dest);
> +		return -EINVAL;
> +	}
> +
> +	inst |= (((unsigned long)offset) >> 2) & (0x00ffffffUL);
> +	*pinst = inst;
> +	return 0;
> +}
> +

This looks remarkably similar to the code in arch/arm/kernel/insn.c so I
think you can probably just use the existing arm_gen_branch() function.

[...]

-- 
Tixy 

