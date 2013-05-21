Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3EUKHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:07:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1210 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3EUKHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:07:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,713,1363132800"; 
   d="scan'208";a="25178482"
Message-ID: <519B474E.4000202@citrix.com>
Date: Tue, 21 May 2013 11:07:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Feng Jin <joe.jin@oracle.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chien Yen <chien.yen@oracle.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated when driver
 load first time
References: <alpine.DEB.2.02.1305131540020.4799@kaball.uk.xensource.com>	<20130513161714.GC10401@phenom.dumpdata.com>	<alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com>	<20130513182055.GC14177@phenom.dumpdata.com>	<alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com>	<20130514142013.GA10173@konrad-lan.dumpdata.com>	<alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>	<5195944A.3050608@oracle.com>	<alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>	<20130520175706.GA27973@phenom.dumpdata.com> <20130520203855.GA30616@phenom.dumpdata.com>
In-Reply-To: <20130520203855.GA30616@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/13 21:38, Konrad Rzeszutek Wilk wrote:
>> At this point I think that upstream option is to save the PIRQ value and re-use it.
>> Will post a patch for it.
> 
> Here is the patch. It works for me when passing in a NIC driver.
> 
>>From 509499568d1cdf1f2a3fb53773c991f4b063eb56 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Mon, 20 May 2013 16:08:16 -0400
> Subject: [PATCH] xen/pci: Track PVHVM PIRQs.
> 
> The PIRQs that the hypervisor provides for the guest are a limited
> resource. They are acquired via PHYSDEVOP_get_free_pirq and in
> theory should be returned back to the hypervisor via PHYSDEVOP_unmap_pirq
> hypercall. Unfortunatly that is not the case.
> 
> This means that if there is a PCI device that has been passed in
> the guest and does a loop of 'rmmod <driver>;modprobe <driver>"
> we end up exhausting all of the PIRQs that are available.
> 
> For example (with kernel built as debug), we get this:
> 00:05.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
> [  152.659396] e1000e 0000:00:05.0: xen: msi bound to pirq=53
> [  152.665856] e1000e 0000:00:05.0: xen: msi --> pirq=53 --> irq=73
> .. snip
> [  188.276835] e1000e 0000:00:05.0: xen: msi bound to pirq=51
> [  188.283194] e1000e 0000:00:05.0: xen: msi --> pirq=51 --> irq=73
> 
> .. and so on, until the pirq value is zero. This is an acute problem
> when many PCI devices with many MSI-X entries are passed in the guest.
> 
> There is an alternative solution where we assume that on PCI
> initialization (so when user passes in the PCI device) QEMU will init
> the MSI and MSI-X entries to zero. Based on that assumptions and
> that the Linux MSI API will write the PIRQ value to the MSI/MSI-X
> (and used by QEMU through the life-cycle of the PCI device), we can
> also depend on that. That means if MSI (or MSI-X entries) are read back
> and are not 0, we can re-use that PIRQ value. However this patch
> guards against future changes in QEMU in case that assumption
> is incorrect.
> 
> Reported-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/events.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 122 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 6a6bbe4..8aae21a 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -112,6 +112,27 @@ struct irq_info {
>  #define PIRQ_NEEDS_EOI	(1 << 0)
>  #define PIRQ_SHAREABLE	(1 << 1)
>  
> +/*
> + * The PHYSDEVOP_get_free_pirq allocates a set of PIRQs for the guest and
> + * the PHYSDEVOP_unmap_pirq is suppose to return them to the hypervisor.
> + * Unfortunatly that is not the case and we exhaust all of the PIRQs that are
> + * allocated for the domain if a driver is loaded/unloaded in a loop.
> + * The pirq_info serves a cache of the allocated PIRQs so that we can reuse
> + * for drivers. Note, it is only used by the MSI, MSI-X routines.
> + */

Ick.  Let's fix the bug in the hypervisor instead of hacking up the
kernel like this.

Looking at the hypervisor code I couldn't see anything obviously wrong.
 I do note that Xen doesn't free the pirq until it has been unbound by
the guest.  Xen will warn if the guest unmaps a pirq that is still bound
("domD: forcing unbind of pirq P").  Is this what is happening?  If so,
that would suggest a bug in the guest rather than the hypervisor.

David
