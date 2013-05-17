Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3EQSty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:49:54 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:22470 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3EQStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:49:53 -0400
Date: Fri, 17 May 2013 20:49:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Will Deacon <will.deacon@arm.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, david.daney@cavium.com
Subject: Re: [PATCH] arm64: extable: sort the exception table at build time
Message-ID: <20130517184950.GA22304@merkur.ravnborg.org>
References: <1368809021-25130-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368809021-25130-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:43:41PM +0100, Will Deacon wrote:
> As is done for other architectures, sort the exception table at
> build-time rather than during boot.
> 
> Since sortextable appears to be a standalone C program relying on the
> host elf.h to provide EM_AARCH64, I've had to add a conditional check in
> order to allow cross-compilation on machines that aren't running a
> bleeding-edge libc-dev.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/Kconfig              |  1 +
>  arch/arm64/kernel/vmlinux.lds.S | 15 +++++++--------
>  scripts/sortextable.c           |  5 +++++
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 48347dc..fb8fd90 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -7,6 +7,7 @@ config ARM64
>  	select ARM_AMBA
>  	select ARM_ARCH_TIMER
>  	select ARM_GIC
> +	select BUILDTIME_EXTABLE_SORT
>  	select CLONE_BACKWARDS
>  	select COMMON_CLK
>  	select GENERIC_CLOCKEVENTS
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 3fae2be..3d527726 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -57,6 +57,13 @@ SECTIONS
>  
>  	RO_DATA(PAGE_SIZE)
>  
> +	. = ALIGN(8);
> +	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> +		__start___ex_table = .;
> +		*(__ex_table)
> +		__stop___ex_table = .;
> +	}

Here you could use:
     EXCEPTION_TABLE(align)

(From include/asm-generic/vmlinux.lds.h)

	Sam
