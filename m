Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3K2Inu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3K2Ins (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:43:48 -0500
Date: Fri, 29 Nov 2013 16:42:57 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 10/12] x86: export x86 boot_params to sysfs
Message-ID: <20131129084257.GC4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-11-git-send-email-dyoung@redhat.com>
 <20131127145634.GG32267@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127145634.GG32267@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 03:56pm, Borislav Petkov wrote:
> On Tue, Nov 26, 2013 at 01:57:55PM +0800, Dave Young wrote:
> > kexec-tools use boot_params for getting the 1st kernel hardware_subarch,
> > the kexec kernel efi runtime support also need read the old efi_info from
> > boot_params. Currently it exists in debugfs which is not a good place for
> > such infomation. Per HPA, we should avoid of "sploit debugfs".
> > 
> > In this patch /sys/kernel/boot_params are exported, also the setup_data
> > is exported as a subdirectory. For original debugfs since it's already
> > there for long time and kexec-tools is using it for hardware_subarch so
> > let's do not remove them for now.
> 
> "kexec-tools is using debugfs for hardware_subarch for a long time now
> so we're not removing it yet."

Will take above log, thanks.

> 
> > Structure are like below:
> 
> 	    is

Will fix

> 
> > 
> > /sys/kernel/boot_params
> > ├── data		/* binary data for boot_params */
> 
> You mean "boot_params in binary"?

Yes, "boot_params in binary" is better, will use

> 
> > ├── setup_data  	/* subdirectory for setup_data if there's any */
> 
> no need for that comment

Ok

> 
> > │   ├── 0		/* the first setup_data node */
> > │   │   ├── data	/* binary data for setup_data node 0 */
> 
> "setup_data node 0 in binary"

Will do.

> 
> > │   │   └── type	/* setup_data type of setup_data node 0, hex string */
> > |   [snip]		/* other setup_data nodes ... */
> > └── version		/* hex string for boot protocal version */
> 
> "boot protocol version (in hex, "0x" prefixed)"

Will fix.

> 
> > 
> > Changelog:
> > Greg: use __ATTR_RO() and group attr.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-boot_params |  40 +++
> >  arch/x86/kernel/Makefile                           |   2 +-
> >  arch/x86/kernel/ksysfs.c                           | 339 +++++++++++++++++++++
> >  3 files changed, 380 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-kernel-boot_params
> >  create mode 100644 arch/x86/kernel/ksysfs.c
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-boot_params b/Documentation/ABI/testing/sysfs-kernel-boot_params
> > new file mode 100644
> > index 0000000..8014a93
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-kernel-boot_params
> > @@ -0,0 +1,40 @@
> > +What:		/sys/kernel/boot_params
> > +Date:		November 2013
> > +Contact:	Dave Young <dyoung@redhat.com>
> > +Description:
> > +		The /sys/kernel/boot_params directory contains two
> > +		files: "data" and "version" and one subdirectory "setup_data".
> > +		It is used to export the kernel boot parameters of x86
> 
> "... of an x86 platform to userspace for kexec and debugging purposes."

Will update

> 
> > +		platform to user space for kexec and debugging purpose.
> > +
> > +		If there's no setup_data in boot_params the subdirectory will
> > +		not be created.
> > +
> > +		"data" file is the binary representation of struct boot_params.
> > +
> > +		"version" file is the string representation of boot
> > +		protocol version.
> > +
> > +		"setup_data" subdirectory contains the setup_data data
> > +		structure in boot_params. setup_data is maintained in kernel
> > +		as a link list. In "setup_data" subdirectory there's one
> > +		subdirectory for each link list node named with the number
> > +		of the list nodes. The list node subdirectory contains two
> > +		files "type" and "data". "type" file is the string
> > +		representation of setup_data type.
> 
> string or int?

It's printed as a string. Kernel data type is int, here means string from sysfs
point of view. On the other hand, "data" is a binary..

> > +		"data" file is the binary
> > +		representation of setup_data payload.
> > +
> > +		The whole boot_params directory structure is like below:
> > +		/sys/kernel/boot_params
> > +		├── data
> > +		├── setup_data
> > +		│   ├── 0
> > +		│   │   ├── data
> > +		│   │   └── type
> > +		│   └── 1
> > +		│       ├── data
> > +		│       └── type
> > +		└── version
> > +
> > +Users:
> > +		Kexec Mailing List <kexec@lists.infradead.org>
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index a5408b9..473a4bb 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -35,7 +35,7 @@ obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
> >  obj-y			+= tsc.o io_delay.o rtc.o
> >  obj-y			+= pci-iommu_table.o
> >  obj-y			+= resource.o
> > -
> > +obj-$(CONFIG_SYSFS)	+= ksysfs.o
> >  obj-y				+= process.o
> >  obj-y				+= i387.o xsave.o
> >  obj-y				+= ptrace.o
> 
> Conflict with upstream, it should be:

Will update

> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 9b0a34e2cd79..851dcd1218fc 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -35,6 +35,7 @@ obj-y                 += alternative.o i8253.o pci-nommu.o hw_breakpoint.o
>  obj-y                  += tsc.o io_delay.o rtc.o
>  obj-y                  += pci-iommu_table.o
>  obj-y                  += resource.o
> +obj-$(CONFIG_SYSFS)    += ksysfs.o
>  
>  obj-$(CONFIG_PREEMPT)  += preempt.o
>  
> 
> > diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
> > new file mode 100644
> > index 0000000..3f91207
> > --- /dev/null
> > +++ b/arch/x86/kernel/ksysfs.c
> > @@ -0,0 +1,339 @@
> > +/*
> > + * Architecture specific sysfs attributes in /sys/kernel
> 
> Architecture-specific

Ok.

Thanks a lot for the review
Dave
