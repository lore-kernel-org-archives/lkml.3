Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaKLIOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:14:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaKLIOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:14:38 -0500
Date: Wed, 12 Nov 2014 09:14:34 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, anderson@redhat.com
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
Message-ID: <20141112091434.0427bcc6@hananiah.suse.cz>
In-Reply-To: <20141112.154042.59640143160036130.d.hatayama@jp.fujitsu.com>
References: <20141112.154042.59640143160036130.d.hatayama@jp.fujitsu.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014 15:40:42 +0900 (JST)
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> Currently, VMCOREINFO note information reports the virtual address of
> phys_base that is assigned to symbol phys_base. But this doesn't make
> sense because to refer to value of the phys_base, it's necessary to
> get the value of phys_base itself we are now about to refer to.
> 
> Userland tools related to kdump such as makedumpfile and crash utility
> so far have made some efforts to calculate phys_base from memory
> mapping information on a variety of crash dump formats. But there's no
> guarantee to keep maintaining it in the future.
> 
> This is also useful for crash dump mechanism running outside Linux
> kernel such as virtual machine hypervisor such as qemu dump, which
> ordinary users use via virsh dump, or ones implemented on vendor
> specific firmware. They cannot get phys_base without special mechanism
> because phys_base is kernel information.
> 
> To get VMCOREINFO in vmcore, it's easy to use strings and grep
> commands like this; VMCOREINFO consists of simple string:
> 
> $ strings vmcore-3.10.0-121.el7.x86_64 | grep -E ".*VMCOREINFO.*" -A 100
> VMCOREINFO
> OSRELEASE=3.10.0-121.el7.x86_64
> PAGESIZE=4096
> ...
> 
> Similarly, this is also useful to get value of phys_base in kdump 2nd
> kernel contained in vmcore using the above-mentioned external crash
> dump mechanism; kdump 2nd kernel is an inherently relocated kernel.
> 
> This commit doesn't remove VMCOREINFO_SYMBOL(phys_base) line because
> makedumpfile refers to it and if removing it, old versions
> makedumpfile doesn't work well.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/kernel/machine_kexec_64.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 4859810..e6d00a4 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -334,6 +334,7 @@ void arch_crash_save_vmcoreinfo(void)
>  #endif
>  	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
>  			      (unsigned long)&_text - __START_KERNEL);
> +	VMCOREINFO_LENGTH(phys_base, phys_base);

While I fully agree with the concept, I don't like the use of
VMCOREINFO_LENGTH. LENGTH(symbol) has been used to store array length
in VMCOREINFO.

OTOH there is currently no good syntax for storing a value (short of
VMCOREINFO_NUMBER, but that one is signed). I think it would be best to
extend the VMCOREINFO syntax for storing variables, preferably in
hexadecimal, e.g.:

#define VMCOREINFO_VALUE(name, value) \
	vmcoreinfo_append_str("VALUE(%s)=%lx\n", #name, (unsigned long) value)

This interface is somewhat suboptimal, because it can only store a
single long value. So, maybe we should dump the complete variable in
hex, or something similar...

Anyone has a better idea?

Petr T
