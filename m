Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaGBMjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:39:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59921 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGBMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:39:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Wed, 02 Jul 2014 14:38:04 +0200
Message-ID: <4751391.BGkeOrZGt8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mn6yeNRjLIV6kUVgN6jHW2vjna6xTm8ho+EA+HE8/Cs
 fy+fkzSb2qnwupz08txbt9wWMLZD+FjfTA6i1GqhHLMiMRdDQ2
 mD0g9H+nyMMNw+YBkosarBO6O03yDKfQ6zxn8UD1DY9FCN5N80
 rOCHEPa+YFdcksmO+uvGPUzztrB3egCrBDfQZkeg4BCuRkKHof
 jZaiyYHavGD4DbvTBIOj4gChuSsJfvhhSiMX9LJeTTkDKwxV8T
 wzkOVm+RM61wG6jhvSMmEqlDV5c4oXGycOZD5DL4sbQgncfQXb
 tQGPQpyZZQONTcNd361mjjt7iZShFEuLIZTfXAAaW9MvTTwhzm
 a0LVp76hmZI0rUCFtvcY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more detailed comments now

On Tuesday 01 July 2014 19:43:28 Liviu Dudau wrote:
> +/*
> + * Record the PCI IO range (expressed as CPU physical address + size).
> + * Return a negative value if an error has occured, zero otherwise
> + */
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +#ifdef PCI_IOBASE
> +       struct io_range *res;

I was confused by the variable naming here: A variable named 'res' is
normally a 'struct resource'. Maybe better call this 'range'.

> +       resource_size_t allocated_size = 0;
> +
> +       /* check if the range hasn't been previously recorded */
> +       list_for_each_entry(res, &io_range_list, list) {
> +               if (addr >= res->start && addr + size <= res->start + size)
> +                       return 0;
> +               allocated_size += res->size;
> +       }

A spin_lock around the list lookup should be sufficient to get around
the race that Will mentioned.

> +       /* range not registed yet, check for available space */
> +       if (allocated_size + size - 1 > IO_SPACE_LIMIT)
> +               return -E2BIG;

It might be better to limit the size to 64K if it doesn't fit at first.


	Arnd
