Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3JIKOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:14:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61143 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757114Ab3JIKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:14:53 -0400
Date: Wed, 9 Oct 2013 11:14:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: add PAGE_ALIGNED_DATA to linker script
Message-ID: <20131009101447.GC5985@mudshark.cambridge.arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381264659-11132-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:37:39PM +0100, Mark Salter wrote:
> The arm64 linker script doesn't use the PAGE_ALIGNED_DATA macro which
> leads to a ".data..page_aligned" section being placed between the end
> of .data and start of .bss:
> 
>  % readelf -e vmlinux
>    ...
>  Section to Segment mapping:
>   Segment Sections...
>    00     .head.text .text .text.init .rodata __ksymtab __ksymtab_gpl \
>           __ksymtab_strings __param __modver __ex_table .notes \
>           .init.text .init.data .data..percpu .data .data..page_aligned .bss
> 
> This causes problems for the EFI stub which may have to relocate the
> kernel image based on stext and _edata symbols.
> 
> This patch adds PAGE_ALIGNED_DATA() to the linker script inside the
> the .data section.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/kernel/vmlinux.lds.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index f8ab9d8..e441556 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -110,6 +110,7 @@ SECTIONS
>  		 */
>  		INIT_TASK_DATA(THREAD_SIZE)
>  		NOSAVE_DATA
> +		PAGE_ALIGNED_DATA(PAGE_SIZE)
>  		CACHELINE_ALIGNED_DATA(64)
>  		READ_MOSTLY_DATA(64)

Can we just replace this chunk with RW_DATA_SECTION(64, PAGE_SIZE,
THREAD_SIZE) instead?

Will
