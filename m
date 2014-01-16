Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaAPRxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:53:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaAPRxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:53:46 -0500
Date: Thu, 16 Jan 2014 12:53:18 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aarch64: always map VDSO at worst case alignment
Message-ID: <20140116175318.GK18705@redacted.bos.redhat.com>
References: <20140115214144.GF18705@redacted.bos.redhat.com>
 <20140116174344.GJ30257@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116174344.GJ30257@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 05:43:44PM +0000, Will Deacon wrote:
> > +		struct vm_unmapped_area_info info =
> > +			{
> > +				.flags = 0,
> > +				.length = vdso_mapping_len,
> > +				.low_limit = mm->mmap_base,
> > +				.high_limit = TASK_SIZE,
> > +				.align_mask = (1 << 16) - 1,
> > +			};
> > +		vdso_base = vm_unmapped_area(&info);
> > +	}
> 
> I don't like this fix. The kernel is perfectly alright mapping the vdso at
> the actual page size, as opposed to the maximum. Since the vdso isn't
> demand-paged, we can actually just tell the linker not to bother forcing 64k
> (worst case) alignment for PT_LOAD segments. Please can you try the patch
> below?
> 

Me either, tbh. ;-)

I was testing out using -Wl,-z,max-page-size for the
!CONFIG_ARM64_64K_PAGES case, and that seemed to work. A quick compile
check shows the segment alignment being 0x10 with -Wl,-n:

kmcmarti ~/linux $ eu-readelf -l
arch/arm64/kernel/vdso/vdso.so
Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz
MemSiz   Flg Align
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x000700
0x000700 R E 0x10

so I think that should work nicely!

I'll reboot a machine with this fix to test it as soon as possible.

Acked-by: Kyle McMartin <kyle@redhat.com>

> --- a/arch/arm64/kernel/vdso/Makefile
> +++ b/arch/arm64/kernel/vdso/Makefile
> @@ -48,7 +48,7 @@ $(obj-vdso): %.o: %.S
>  
>  # Actual build commands
>  quiet_cmd_vdsold = VDSOL $@
> -      cmd_vdsold = $(CC) $(c_flags) -Wl,-T $^ -o $@
> +      cmd_vdsold = $(CC) $(c_flags) -Wl,-n -Wl,-T $^ -o $@
>  quiet_cmd_vdsoas = VDSOA $@
>        cmd_vdsoas = $(CC) $(a_flags) -c -o $@ $<
>  
