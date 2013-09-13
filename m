Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3IMHNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3IMHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:13:34 -0400
Date: Fri, 13 Sep 2013 15:12:40 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Message-ID: <20130913071240.GF13561@dhcp-16-126.nay.redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
 <522FA2A8.8080703@zytor.com>
 <20130911114419.GB31551@x1.alien8.de>
 <20130911134534.GB15364@redhat.com>
 <20130911143216.GA933@x1.alien8.de>
 <20130912064930.GA5288@dhcp-16-126.nay.redhat.com>
 <20130912125350.GB9280@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912125350.GB9280@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/13 at 02:53pm, Borislav Petkov wrote:
> On Thu, Sep 12, 2013 at 03:34:15PM +0800, Dave Young wrote:
> > I'm playing with skipping SetVirtualAddressMap in kexec kernel, for
> > same kernel the test result is ok for me both for kexec and kdump.
> > Takao Indoh sent a patch with this approatch, but his V2 switched to
> > use physical mapping. During my test, additional data of config table
> 
> Physical mapping won't work because of some very brilliant Apple UEFI
> implementations, as I came to realize. My previous version did that :)
> 
> > elems need to be saved besides of fw_vendor, runtime and tables or
> > dereference taglep->guid will panic.
> >
> > Also kexec userspace need to fill efi_info in bootparams and pass the
> > previous saved efi data to 2nd kernel.
> 
> Hmm, yes, we need to tell the kexec kernel the EFI regions.
> 
> > I'm worrying just skiping enter virt mode have risk though it's an
> > easy solution. Your 1:1 mapping approatch looks better. I look forward
> > to test your new patchset.
> 
> Yeah, we had a discussion at the SUSE Labs conf about whether we could
> really skip SetVirtualAddressMap in the first kernel and do it in the
> kexec kernel but the first kernel might want to call runtime services
> for whatever reason and for that we need the runtime services. So we
> opted for the stable VA mappings.

I means only skipping SetVirtualAddressMap in kexec kernel, ioremap result 
should be same with 1st kernel, but I'm not sure, it's what I worried about.
With 1:1 mapping, even we do not call SetVirtualAddressMap in kexec kernel
the mapping will be same in theory.

> 
> > Are you also working on kexec userspace part? Already have a patch?
> 
> Why userspace part - I'm thinking the kexec'ed kernel would simply add
> the mappings made by SetVirtualAddressMap without calling it. And it
> will know which mappings go to which virtual addresses because we start
> at the -4G virtual address and go downwards and the mappings will have
> the same addresses per UEFI implementation.
> 
> It'll make more sense when you see the code, I hope :)

For user space part, we need at least fill efi_info in kexec boot loader.
I have a test patch for this.

Also the fw_vendor, runtime, tables elements will be fixed up to use
virtual address after 1st kernel call SetVirtualAddress, so even with
1:1 mapping we still need save them and use in kexec kernel.
Such as below code assume fw_vendor is physical address:
c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);

So as what Takao has done we need to save them and use the saved value
in kexeced kernel. Previously he used is_kdump_kernel() to check if it's
a kdump kernel. But this is not enough because we'd better to also
consider kexec. I'm thinking below two approatches:

1. use bootloader_type as below
#define LOADER_TYPE_KEXEC	0x0D
int is_kexec_boot()
{
	if (bootloader_type == LOADER_TYPE_KEXEC)
		return 1;
	return 0;
}

2. 1) is specific to X86, if consider other futuer arch, maybe add a
kernel cmdline like kexecboot=X [X=0|1|2], 0:not kexec 1:kexec 2:kdump

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
