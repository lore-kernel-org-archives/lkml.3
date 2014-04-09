Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbaDIXDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:53546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbaDIXDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:03:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,829,1389772800"; 
   d="scan'208";a="518017502"
Date: Thu, 10 Apr 2014 07:01:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jet Chen <jet.chen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>
Cc: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Message-ID: <20140409230114.GB8370@localhost>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
 <53444220.50009@intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com>
 <53458A3A.1050608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53458A3A.1050608@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC the KVM people: it looks like a KVM problem that can be triggered by

        qemu-system-x86_64 -cpu Haswell,+smep,+smap

On Thu, Apr 10, 2014 at 01:58:18AM +0800, Jet Chen wrote:
> On 04/09/2014 10:44 PM, Romer, Benjamin M wrote:
> > On Wed, 2014-04-09 at 02:38 +0800, Jet Chen wrote:
> > 
> >> Hi Ben,
> >>
> >> I checked my <Intel 64 and IA-32 Architectures Software Developer's Manual> which published in Feb 2014.
> >> Volume 2: Instruction Set Reference, A-Z: CPUID--CPU Identification
> >>
> > 
> > I agree completely, which is why I'm confused about KVM's behavior. If
> > bit 31 was off, the code in our drivers that uses the vmcall instruction
> > would not have been run, the kernel would not have tried to perform a
> > vmcall, and not crashed with invalid op.
> > 
> > If you look in the definition for the VMCALL instruction (Intel 64 and
> > IA32 Architectures Software Developer's Manual, volume 3C pg.30-9)
> > You'll see that a processor in VMX non-root operation should perform a
> > vmexit.
> > 
> >> Why this document not match what you said ? I am not experienced with VM, please correct me if I went for wrong document
> >>
> > 
> > According to VMWare's documentation (there is a page at
> > http://kb.vmware.com./selfservice/microsites/search.do?cmd=displayKC&externalId=1009458 ) , as well as Microsoft's hypervisor spec (at http://www.microsoft.com/en-us/download/details.aspx?id=39289 ), this bit is used to indicate the CPU is running under virtualization. KVM is also setting this bit to indicate virtualization. I believe Xen uses it as well.
> > 
> > 
> > My contention is, if KVM is going to set the ISVM bit, it needs to do a
> > vmexit, and if it's not going to set the bit, then doing an invalid op
> > is okay, but the current behavior is inconsistent.
> > 
> > -- Ben
> > 
> 
> Ben,
> 
> Really thanks for your explanation.
> Let me summary it up, please correct me where i am wrong. If it is really a KVM bug, we report it to KVM guys.
> On a real CPU, ECX 31bit always be 0 as Intel documentation filed.
> However, KVM, as a hypervisor, should emulate this bit of the virtual ECX register to 1 for guest OS to indicate it is running in a virtualization environment.
> Problem is, KVM does set this bit to 1, but does an invalid op instead of emit a VMCALL. As a result, we get this dmesg error messages.
> 
> Thanks,
> -Jet
