Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3GQT1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:27:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39446 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3GQT1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:27:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes) causes hang
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130717184226.GA358@x4>
Date: Thu, 18 Jul 2013 03:22:32 +0800
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3B49A7E5-F5ED-462B-969B-B8481D881340@gmail.com>
References: <20130717163215.GA359@x4> <20130717164232.GI13732@redhat.com> <20130717165743.GA357@x4> <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com> <20130717184226.GA358@x4>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you please try this:

index 460b9c6..16d1578 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2952,6 +2952,9 @@ static bool page_fault_can_be_fast(u32 error_code)
              !(error_code & PFERR_WRITE_MASK))
                return false;
 
+       if (error_code & PFERR_RSVD_MASK)
+               return false;
+
        return true;
 }


On Jul 18, 2013, at 2:42 AM, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2013.07.18 at 01:25 +0800, Xiao Guangrong wrote:
>> Hi Markus,
>> 
>> Thanks for your report! I am downloading the ubuntu iso and will try to reproducible it.
>> 
>> Could you please enable these tracepoints:
>> kvmmmu/check_mmio_spte
>> kvmmmu/handle_mmio_page_fault
>> kvmmmu/kvm_mmu_invalidate_zap_all_pages
>> kvmmmu/mark_mmio_spte
>> kvm/kvm_mmio
>> kvm/vcpu_match_mmio
>> 
>> and post the output?
>> 
> First line repeated ad nauseam.
> ...
> 10346367  qemu-system-x86-1403  [001]  1451.422225: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346368  qemu-system-x86-1403  [001]  1451.422226: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346369  qemu-system-x86-1403  [001]  1451.422227: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346370  qemu-system-x86-1403  [001]  1451.422228: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346371  qemu-system-x86-1403  [001]  1451.422229: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0index 460b9c6..16d1578 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2952,6 +2952,9 @@ static bool page_fault_can_be_fast(u32 error_code)
>               !(error_code & PFERR_WRITE_MASK))
>                 return false;
>  
> +       if (error_code & PFERR_RSVD_MASK)
> +               return false;
> +
>         return true;
>  }10346372  qemu-system-x86-1404  [002]  1451.422229: kvm_mmio:             mmio write len 4 gpa 0xfee000b0 val 0x0
> 10346373  qemu-system-x86-1403  [001]  1451.422230: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346374  qemu-system-x86-1403  [001]  1451.422231: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346375  qemu-system-x86-1403  [001]  1451.422232: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346376  qemu-system-x86-1403  [001]  1451.422233: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346377  qemu-system-x86-1403  [001]  1451.422234: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346378  qemu-system-x86-1403  [001]  1451.422235: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346379  qemu-system-x86-1404  [002]  1451.422236: kvm_mmio:             mmio write len 4 gpa 0xfee00380 val 0x3c7b0
> 10346380  qemu-system-x86-1403  [001]  1451.422237: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346381  qemu-system-x86-1403  [001]  1451.422238: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346382  qemu-system-x86-1403  [001]  1451.422239: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346383  qemu-system-x86-1403  [001]  1451.422240: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346384  qemu-system-x86-1403  [001]  1451.422241: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346385  qemu-system-x86-1403  [001]  1451.422242: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346386  qemu-system-x86-1403  [001]  1451.422243: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346387  qemu-system-x86-1403  [001]  1451.422244: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346403  qemu-system-x86-1403  [001]  1451.422260: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0  
> ...
> Last line repeated ad nauseam.
> 
> Whole output is over 1.3G of size.
> 
> --
> Markus

