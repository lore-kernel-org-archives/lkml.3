Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaLSNoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:44:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:41276 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaLSNoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:44:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,606,1413270000"; 
   d="scan'208";a="657097477"
Message-ID: <54942B9A.6090608@linux.intel.com>
Date: Fri, 19 Dec 2014 21:43:54 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>, konrad.wilk@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: Bisected Linux regression: ACPI powerbutton events don't work
 under Xen since commit b81975eade8c6495f3c4d6746d22bdc95f617777
References: <1824124380.20141219141645@eikelenboom.it>
In-Reply-To: <1824124380.20141219141645@eikelenboom.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sander,
	Found the root cause now, but still need some time to find
a solution for this issue.
xen_smp_prepare_cpus() doesn't call:
	smpboot_setup_io_apic()->setup_IO_APIC()
So no irqdomain structure for IOAPIC created,  then mp_map_pin_to_irq()
fails at the very beginning.

The most simple solution is to revert following change, but it doesn't
seem the best solution. I will try to find a hook point to create
irqdomain for IOAPIC from xen_smp_prepare_cpus().
Regards!
Gerry

@@ -1034,13 +1035,8 @@ static int mp_map_pin_to_irq(u32 gsi, int idx,
int ioapic, int pin,
        struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
        struct mp_pin_info *info = mp_pin_info(ioapic, pin);

-       if (!domain) {
-               /*
-                * Provide an identity mapping of gsi == irq except on truly
-                * weird platforms that have non isa irqs in the first
16 gsis.
-                */
-               return gsi >= nr_legacy_irqs() ? gsi : gsi_top + gsi;
-       }
+       if (!domain)
+               return -1;

        mutex_lock(&ioapic_mutex);



On 2014/12/19 21:16, Sander Eikelenboom wrote:
> Hi,
> 
> When running under Xen, ACPI powerbutton events don't work anymore, 
> there is no reaction when pressing the powerbutton.
> 
> On baremetal everything works fine, acpid gets the event and the 
> machine powers down perfectly. The machine is an Intel NUC.
>  
> Bisection has lead to:
> 
> b81975eade8c6495f3c4d6746d22bdc95f617777 is the first bad commit
> commit b81975eade8c6495f3c4d6746d22bdc95f617777
> Author: Jiang Liu <jiang.liu@linux.intel.com>
> Date:   Mon Jun 9 16:20:11 2014 +0800
> 
>     x86, irq: Clean up irqdomain transition code
> 
>     Now we have completely switched to irqdomain, so clean up transition code
>     in IOAPIC drivers.
> 
>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>     Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     Cc: Tony Luck <tony.luck@intel.com>
>     Cc: Joerg Roedel <joro@8bytes.org>
>     Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: Grant Likely <grant.likely@linaro.org>
>     Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>     Cc: Bjorn Helgaas <bhelgaas@google.com>
>     Cc: Randy Dunlap <rdunlap@infradead.org>
>     Cc: Yinghai Lu <yinghai@kernel.org>
>     Link: http://lkml.kernel.org/r/1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Reverting this specific commit on linux-tip (3.19-mw) gets things working again under Xen.
> Kernel .config is attached.
> 
> --
> Sander
> 
