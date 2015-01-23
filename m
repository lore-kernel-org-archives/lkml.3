Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbbAWLaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:30:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8606 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbbAWLaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:30:20 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418083200"; 
   d="scan'208";a="220833783"
Message-ID: <54C230C8.4000207@citrix.com>
Date: Fri, 23 Jan 2015 11:30:16 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
CC: Borislav Petkov <bp@suse.de>, <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v4 1/2] x86/xen: add xen_is_preemptible_hypercall()
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 00:29, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> On kernels with voluntary or no preemption we can run
> into situations where a hypercall issued through userspace
> will linger around as it addresses sub-operatiosn in kernel
> context (multicalls). Such operations can trigger soft lockup
> detection.
> 
> We want to address a way to let the kernel voluntarily preempt
> such calls even on non preempt kernels, to address this we first
> need to distinguish which hypercalls fall under this category.
> This implements xen_is_preemptible_hypercall() which lets us do
> just that by adding a secondary hypercall page, calls made via
> the new page may be preempted.
[...]
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -84,6 +84,22 @@
>  
>  extern struct { char _entry[32]; } hypercall_page[];
>  
> +#ifndef CONFIG_PREEMPT
> +extern struct { char _entry[32]; } preemptible_hypercall_page[];
> +
> +static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
> +{
> +	return !user_mode_vm(regs) &&
> +		regs->ip >= (unsigned long)preemptible_hypercall_page &&
> +		regs->ip < (unsigned long)preemptible_hypercall_page + PAGE_SIZE;

I think you can optimize this to:

    return (regs->ip >> PAGE_SHIFT) == preemptible_hypercall_pfn
	&& !user_mode_vm(regs);

David

