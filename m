Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3JULAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:00:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13642 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3JULAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:00:48 -0400
Message-ID: <526507F4.4090706@huawei.com>
Date: Mon, 21 Oct 2013 18:54:44 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v4 20/28] x86, irq: More strict checking about registering
 ioapic
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org> <1376189294-32022-21-git-send-email-yinghai@kernel.org>
In-Reply-To: <1376189294-32022-21-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int mp_find_ioapic_pin(int ioapic, u32 gsi)
>  {
>  	struct mp_ioapic_gsi *gsi_cfg;
> @@ -3888,6 +3894,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
>  	if (bad_ioapic(address))
>  		return;
>  
> +	/* already registered ? */
> +	idx = __mp_find_ioapic(gsi_base);
> +	if (idx >= 0)
> +		return;

Hi Yinghai,
   If you add whether ioapic was already registered check here, so we will fail to add ioapic into global ioapic_list.
Then we also can not hot remove this ioapic.


1. We will call mp_register_ioapic during analyze MADT first.
2. We will try to add hotplug ioapic(which contain _GSB) to ioapic_list in acpi_pci_ioapic_add(), but will found this
ioapic has been registered.

Thanks!
Yijing.


> +
>  	idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
>  	if (idx >= MAX_IO_APICS) {
>  		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded, skipping\n",
> @@ -3914,6 +3925,13 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
>  	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
>  	 */
>  	entries = io_apic_get_redir_entries(idx);
> +
> +	if (!entries || entries > MP_MAX_IOAPIC_PIN) {
> +		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
> +		memset(&ioapics[idx], 0, sizeof(struct ioapic));
> +		return;
> +	}
> +
>  	gsi_cfg = mp_ioapic_gsi_routing(idx);
>  	gsi_cfg->gsi_base = gsi_base;
>  	gsi_cfg->gsi_end = gsi_base + entries - 1;
> 


-- 
Thanks!
Yijing

