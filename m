Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaJTU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:29:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37469 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJTU3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:29:12 -0400
Date: Mon, 20 Oct 2014 16:28:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/8] x86: Add documentation for rd/wr fs/gs base
Message-ID: <20141020202853.GA9393@laptop.dumpdata.com>
References: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
 <1413349911-3620-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413349911-3620-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 10:11:50PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/x86/fsgs.txt | 73 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
>  create mode 100644 Documentation/x86/fsgs.txt
> 
> diff --git a/Documentation/x86/fsgs.txt b/Documentation/x86/fsgs.txt
> new file mode 100644
> index 0000000..d895b25
> --- /dev/null
> +++ b/Documentation/x86/fsgs.txt
> @@ -0,0 +1,73 @@
> +
> +Using FS and GS prefixes on x86_64-linux
> +
> +The x86 architecture supports segment prefixes per instruction to add an
> +offset to an address.  On 64bit x86, these are mostly nops, except for FS
> +and GS.
> +
> +This offers an efficient way to reference a global pointer.
> +
> +The compiler has to generate special code to use these base registers,
> +or they can be accessed with inline assembler.
> +
> +	mov %gs:offset,%reg
> +	mov %fs:offset,%reg
> +
> +FS is used to address the thread local segment (TLS), declared using
> +__thread.  The compiler the automatically generates the correct prefixes and

s/the/then

> +relocations to access these values.
> +
> +FS is normally managed by the runtime code or the threading library.
> +
> +GS is freely available, but may need special (compiler or inline assembler)
> +code to use.
> +
> +Traditionally 64bit FS and GS could be set by the arch_prctl system call
> +
> +	arch_prctl(ARCH_SET_GS, value)
> +	arch_prctl(ARCH_SET_FS, value)
> +
> +[There was also an older method using modify_ldt(), inherited from 32bit,
> +but this is not discussed here.]
> +
> +However using a syscall is problematic for user space threading libraries
> +that want to context switch in user space.

Could you explain that a bit more?
> +
> +Newer Intel CPUs (Ivy Bridge and later) added new instructions to directly
> +access these registers quickly from user context
> +
> +	RDFSBASE %reg	read the FS base	(or _readfsbase_u64)
> +	RDGSBASE %reg	read the GS base	(or _readgsbase_u64)
> +
> +	WRFSBASE %reg	write the FS base	(or _writefsbase_u64)
> +	WRGSBASE %reg	write the GS base	(or _writegsbase_u64)
> +
> +The instructions are supported by the CPU when the "fsgsbase" string is shown in
> +/proc/cpuinfo (or directly retrieved through the CPUID instruction).
> +The instructions are only available to 64bit binaries.
> +
> +However the kernel needs to explicitly enable these instructions, as it
> +may otherwise not correctly context switch the state. Newer Linux
> +kernels enable this. When the kernel did not enable the instruction
> +they will fault.

#GP? or #UD? 

> +
> +An FSGSBASE enabled kernel can be detected by checking the AT_HWCAP2
> +bitmask in the aux vector. When the HWCAP2_FSGSBASE bit is set the
> +kernel supports RDFSGSBASE.
> +
> +	#include <sys/auxv.h>
> +	#include <elf.h>
> +
> +	/* Will be eventually in asm/hwcap.h */
> +	#define HWCAP2_FSGSBASE        (1 << 0)
> +
> +        unsigned val = getauxval(AT_HWCAP2);
> +        if (val & HWCAP2_FSGSBASE) {
> +                asm("wrgsbase %0" :: "r" (ptr));
> +        }
> +
> +Another requirement is that the FS or GS selector has to be zero
> +(is normally true unless changed explicitly)
> +
> +
> +Andi Kleen
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
