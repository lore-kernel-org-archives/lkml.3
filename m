Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3APThg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:37:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab3APThf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:37:35 -0500
Date: Wed, 16 Jan 2013 14:37:24 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
Message-ID: <20130116193724.GF6964@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
 <87bod14x44.fsf@rustcorp.com.au>
 <20130107145832.GA12363@hansolo.jdub.homelinux.org>
 <20130115190911.GA6964@hansolo.jdub.homelinux.org>
 <87y5ftyf51.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5ftyf51.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 02:04:50PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > With module signing enabled but not in enforcing mode, we don't consider
> > unsigned modules to be an error.  However, if we encounter an unsigned
> > module we currently taint the module and kernel with TAINT_FORCED_MODULE.
> > That also disables lockdep within the kernel.
> 
> How about this, instead?  Ingo?

<snip> 

> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 86e2f4a..7acca64 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -230,7 +230,7 @@ dmar_parse_one_rhsa(struct acpi_dmar_header *header)
>  		}
>  	}
>  	WARN_TAINT(
> -		1, TAINT_FIRMWARE_WORKAROUND,
> +		1, TAINT_FIRMWARE_WORKAROUND, true,
>  		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
>  		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
>  		drhd->reg_base_addr,

This bit causes a build failure here:

drivers/iommu/dmar.c: In function 'dmar_parse_one_rhsa':
drivers/iommu/dmar.c:232:2: warning: passing argument 4 of 'warn_slowpath_fmt_taint' makes pointer from integer without a cast [enabled by default]
In file included from /home/jwboyer/kernel/kernel-3.7.fc19/linux-3.8.0-0.rc3.git2.2.2.fc19.x86_64/arch/x86/include/asm/bug.h:38:0,
                 from include/linux/bug.h:4,
                 from include/linux/cpumask.h:12,
                 from /home/jwboyer/kernel/kernel-3.7.fc19/linux-3.8.0-0.rc3.git2.2.2.fc19.x86_64/arch/x86/include/asm/cpumask.h:4,
                 from /home/jwboyer/kernel/kernel-3.7.fc19/linux-3.8.0-0.rc3.git2.2.2.fc19.x86_64/arch/x86/include/asm/msr.h:10,
                 from /home/jwboyer/kernel/kernel-3.7.fc19/linux-3.8.0-0.rc3.git2.2.2.fc19.x86_64/arch/x86/include/asm/processor.h:20,
                 from /home/jwboyer/kernel/kernel-3.7.fc19/linux-3.8.0-0.rc3.git2.2.2.fc19.x86_64/arch/x86/include/asm/atomic.h:6,
                 from include/linux/atomic.h:4,
                 from include/linux/debug_locks.h:5,
                 from include/linux/lockdep.h:23,
                 from include/linux/sysfs.h:18,
                 from include/linux/kobject.h:21,
                 from include/linux/pci.h:28,
                 from drivers/iommu/dmar.c:31:
include/asm-generic/bug.h:69:6: note: expected 'const char *' but argument is of type 'int'
drivers/iommu/intel-iommu.c:4287:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'quirk_ricoh_multifunction'
drivers/iommu/intel-iommu.c:4291:1: error: 'quirk_ricoh_multifunction' undeclared here (not in a function)
make[2]: *** [drivers/iommu/intel-iommu.o] Error 1

Looking at it, but the WARN_ macros are currently making my head hurt.

josh
