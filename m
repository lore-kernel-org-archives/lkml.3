Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab3DJNOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:14:07 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48863 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:14:04 -0400
Message-ID: <51656592.7070806@gmail.com>
Date: Wed, 10 Apr 2013 08:13:54 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Murray <Andrew.Murray@arm.com>
CC: rob.herring@calxeda.com, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, Liviu.Dudau@arm.com, paulus@samba.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        jg1.han@samsung.com, jgunthorpe@obsidianresearch.com,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, suren.reddy@samsung.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v5 1/3] of/pci: Unify pci_process_bridge_OF_ranges from
 Microblaze and PowerPC
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com> <1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
In-Reply-To: <1365578969-30966-2-git-send-email-Andrew.Murray@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Ben H and Michal...

On 04/10/2013 02:29 AM, Andrew Murray wrote:
> The pci_process_bridge_OF_ranges function, used to parse the "ranges"
> property of a PCI host device, is found in both Microblaze and PowerPC
> architectures. These implementations are nearly identical. This patch
> moves this common code to a common place.
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

One comment below. Otherwise,

Reviewed-by: Rob Herring <rob.herring@calxeda.com>

You need also need acks from Ben and Michal.

[...]

> +		/* Act based on address space type */
> +		res = NULL;
> +		switch ((pci_space >> 24) & 0x3) {
> +		case 1:		/* PCI IO space */
> +			pr_info("  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
> +			       cpu_addr, cpu_addr + size - 1, pci_addr);
> +
> +			/* We support only one IO range */
> +			if (hose->pci_io_size) {
> +				pr_info(" \\--> Skipped (too many) !\n");
> +				continue;
> +			}
> +#if defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE)

How about "if (!IS_ENABLED(CONFIG_64BIT))" instead.

> +			/* On 32 bits, limit I/O space to 16MB */
> +			if (size > 0x01000000)
> +				size = 0x01000000;
> +
> +			/* 32 bits needs to map IOs here */
> +			hose->io_base_virt = ioremap(cpu_addr, size);
> +
> +			/* Expect trouble if pci_addr is not 0 */
> +			if (primary)
> +				isa_io_base =
> +					(unsigned long)hose->io_base_virt;
> +#endif /* CONFIG_PPC32 || CONFIG_MICROBLAZE */
> +			/* pci_io_size and io_base_phys always represent IO
> +			 * space starting at 0 so we factor in pci_addr
> +			 */
> +			hose->pci_io_size = pci_addr + size;
> +			hose->io_base_phys = cpu_addr - pci_addr;

