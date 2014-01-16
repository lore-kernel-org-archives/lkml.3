Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaAPRoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:44:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41950 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbaAPRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:44:17 -0500
Date: Thu, 16 Jan 2014 17:43:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aarch64: always map VDSO at worst case alignment
Message-ID: <20140116174344.GJ30257@mudshark.cambridge.arm.com>
References: <20140115214144.GF18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115214144.GF18705@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

On Wed, Jan 15, 2014 at 09:41:44PM +0000, Kyle McMartin wrote:
> Currently on ARM64 with 4K pages set, GDB fails to load the VDSO with
> the error "Failed to read a valid object file image from memory" as it
> is applying the phdr alignment to the vma, and attempting to read below
> where the VDSO is mapped. This is because our segment alignment is 64K
> in the ELF headers, but the VDSO only has PAGE_SIZE alignment from
> get_unmapped_area.
> 
> Work around this by calling vm_unmapped_area directly, and specifying
> the worst case alignment (64K) directly.
> 
> With this patch applied, I no longer have issues loading the VDSO in
> gdb (and no more error message every time I run a program inside it.)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -163,7 +163,18 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
>  	vdso_mapping_len = (vdso_pages + 1) << PAGE_SHIFT;
>  
>  	down_write(&mm->mmap_sem);
> -	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
> +	{
> +		/* the VDSO must be worst-case aligned to 64K */
> +		struct vm_unmapped_area_info info =
> +			{
> +				.flags = 0,
> +				.length = vdso_mapping_len,
> +				.low_limit = mm->mmap_base,
> +				.high_limit = TASK_SIZE,
> +				.align_mask = (1 << 16) - 1,
> +			};
> +		vdso_base = vm_unmapped_area(&info);
> +	}

I don't like this fix. The kernel is perfectly alright mapping the vdso at
the actual page size, as opposed to the maximum. Since the vdso isn't
demand-paged, we can actually just tell the linker not to bother forcing 64k
(worst case) alignment for PT_LOAD segments. Please can you try the patch
below?

Will

--->8

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index d8064af42e62..6d20b7d162d8 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -48,7 +48,7 @@ $(obj-vdso): %.o: %.S
 
 # Actual build commands
 quiet_cmd_vdsold = VDSOL $@
-      cmd_vdsold = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdsold = $(CC) $(c_flags) -Wl,-n -Wl,-T $^ -o $@
 quiet_cmd_vdsoas = VDSOA $@
       cmd_vdsoas = $(CC) $(a_flags) -c -o $@ $<
 
