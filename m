Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3EAUfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:35:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab3EAUfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:35:13 -0400
Date: Wed, 1 May 2013 22:35:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501203500.GC4466@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
 <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 12:53:03PM -0700, David Rientjes wrote:
> since KVM_GUEST_COMMON_OPTIONS selects PCI_MSI without selecting PCI.
> 
> If we select PCI in KVM_GUEST_COMMON_OPTIONS, we get:
> 
> arch/x86/Kconfig:651:error: recursive dependency detected!
> arch/x86/Kconfig:651:	symbol KVM_GUEST_COMMON_OPTIONS depends on HYPERVISOR_GUEST
> arch/x86/Kconfig:597:	symbol HYPERVISOR_GUEST is selected by X86_VSMP
> arch/x86/Kconfig:388:	symbol X86_VSMP depends on PCI
> arch/x86/Kconfig:2042:	symbol PCI is selected by KVM_GUEST_COMMON_OPTIONS

Well, this was the reason why I dropped CONFIG_PCI from
KVM_GUEST_COMMON_OPTIONS in the first place - to not have the circular
dependency splat above and assuming that people simply have CONFIG_PCI
enabled already.

Well, off the top of my head, we could do the following; I'd need to
hammer on it for a while though before it feels ok with all that Kconfig
jumble. Unless someone has a better idea, of course...

---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e8fff2f4ecb7..4f8ef85b0633 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -389,7 +389,8 @@ config X86_VSMP
 	bool "ScaleMP vSMP"
 	select HYPERVISOR_GUEST
 	select PARAVIRT
-	depends on X86_64 && PCI
+	select PCI
+	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
 	depends on SMP
 	---help---
@@ -664,6 +665,7 @@ config KVM_GUEST_COMMON_OPTIONS
 	select IP_PNP
 	select IP_PNP_DHCP
 	select BINFMT_ELF
+	select PCI
 	select PCI_MSI
 	select HAVE_ARCH_KGDB
 	select DEBUG_KERNEL
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
