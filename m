Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaDYLIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:08:35 -0400
Received: from mtaout20.012.net.il ([80.179.55.166]:50710 "EHLO
	mtaout20.012.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaDYLI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:08:29 -0400
Date: Fri, 25 Apr 2014 14:08:15 +0300
From: Oren Twaig <oren@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when interrupt routing are set to ignore
In-reply-to: <20140425080137.GC19588@gmail.com>
X-012-Sender: ira_oren@012.net.il
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Message-id: <535A421F.4010108@scalemp.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Antivirus: avast! (VPS 140425-0, 04/25/2014), Outbound message
X-Antivirus-Status: Clean
References: <1398376326-3055-1-git-send-email-oren@scalemp.com> <20140425080137.GC19588@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2014 11:01 AM, Ingo Molnar wrote:
>
 > * Oren Twaig <oren@scalemp.com> wrote:
 >
 >> vSMP Foundation provides locality based interrupt routing which needed
 >> vector_allocation_domain to allow all online cpus can handle all 
possible
 >> vectors.
 >>
 >> Enforcing Interrupt Routing Comply (IRC) mode requires us to unplug 
this hook as
 >> otherwise the IOAPIC, MSI and MSIX destination selectors to always 
select the
 >> lowest online cpu as the destination. I.e affinity of HW interrupts 
cannot be
 >> controled by kernel and/or userspace code.
 >>
 >> The purpose of the patch is to fix the code to set override vector 
allocation
 >> domain only when IRC is set to ignore to allow the kernel and 
userspace to
 >> effectively control the destination of the HW interrupts.
 >>
 >> Signed-off-by: Oren Twaig <oren@scalemp.com>
 >> Acked-by: Shai Fultheim <shai@scalemp.com>
 >
 > So what was the behavior before the change - certain IRQs did not get
 > routed, they just ended up on CPU0 or on some other undesirable CPU?
 > Or was IRQ distribution random? It's not clear from the changelog.

It all depends on the IRC flag. When set to "ignore" by the linux
kernel, vSMP Foundation knew that it can deliver the IRQ to the CPU
which would result in less virtualization overhead. For example, we
could deliver the HW interrupt to the CPU which got it or any other CPU
in the system. We couldn't have done it without the kernel making sure
that each vector can be passed to all CPUs. This is why we override the
verctor allocation domain to signal all CPUs.

But, when the IRC is set to "comply" we, before this patch, still
efected the allocation domains alltough it wasn't needed. It wasn't
needed because when in "comply" mode, we always pass the HW interrupt to
the CPU the kernel requested (by setting the IOAPIC entry, MSI/X entry
or IR entry)

Thanks,
   Oren

>
 > Thanks,
 >
 >     Ingo
 > --
 > To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 >



---
This email is free from viruses and malware because avast! Antivirus protection is active.
http://www.avast.com

