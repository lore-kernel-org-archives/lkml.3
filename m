Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbbAVLuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:50:17 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61774 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:50:15 -0500
X-IronPort-AV: E=Sophos;i="5.09,448,1418083200"; 
   d="scan'208";a="220482828"
Message-ID: <54C0E3F2.9050201@citrix.com>
Date: Thu, 22 Jan 2015 11:50:10 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
CC: <kvm@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 02:17, Luis R. Rodriguez wrote:
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -32,6 +32,8 @@
>  #include <linux/slab.h>
>  #include <linux/irqnr.h>
>  #include <linux/pci.h>
> +#include <linux/sched.h>
> +#include <linux/kprobes.h>
>  
>  #ifdef CONFIG_X86
>  #include <asm/desc.h>
> @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>  	set_irq_regs(old_regs);
>  }
>  
> +notrace void xen_end_upcall(struct pt_regs *regs)
> +{
> +	if (!xen_is_preemptible_hypercall(regs) ||
> +	    __this_cpu_read(xed_nesting_count))
> +		return;
> +
> +	if (_cond_resched())
> +		printk(KERN_DEBUG "xen hypercall preempted\n");

I wouldn't even put this at debug level.  On a large server with plenty
of domains being created/migrated/destroyed, it is quite likely that a
toolstack task might get preempted in this way.

I don't believe the message is of any practical use.

~Andrew
