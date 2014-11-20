Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaKTNPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:15:50 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:52165 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKTNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:15:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Liviu Dudau <liviu@dudau.co.uk>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
Date: Thu, 20 Nov 2014 14:15:19 +0100
Message-ID: <2756150.eOnxg6jMdK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546DD804.4010105@linaro.org>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1534030.bkpIToWlHq@wuerfel> <546DD804.4010105@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:c6bvIrZ/R25L5kghM3Mpar19JnDALHT9QyLksswTuWF
 LZb5g0GLfC19D991o50C26frWTu+6prsyyNGuZz9XGuzXi/cUh
 2Svn8aV6VhWWvlI9jlryquJVPYRa8ib85npwlCIuf1l/9CEnvC
 taUn9at1K4RVA0+9UVMz7XyO6uHB0NaXwlW/KwwaMFU6mcSQfl
 Y1jJsL99hrD+8FTC3it2VZ/3BT4dSKmsQ7D06wgZ1vKUkAVASc
 E0N672pF0TuzsOkO8ct+HAT+0VDq6OGrFjkG8vKP+7UdeBy+Ei
 sdAGlOmhYMpkIlAdCNP5kPXoVCqw0L1+d5tVrtGKFXAamdR3B3
 FKERL7V8nHPoEYufSLNI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 13:01:08 Tomasz Nowicki wrote:
> On 18.11.2014 13:27, Arnd Bergmann wrote:
> > On Tuesday 18 November 2014 20:17:57 Yijing Wang wrote:
> >>
> >>>>
> >>>> I hope platforms with ACPI or DT could both use pci_create_host_bridge().
> >>>> Why we need to use two different ways to process it ?
> >>>
> >>> These are completely different use cases:
> >>>
> >>> a) For DT, we want loadable device drivers that start by probing a host
> >>>     bridge device which was added through the DT platform code. The
> >>>     driver is self-contained, and eventually we want to be able to unload
> >>>     it. We have lots of different per-soc drivers that require different
> >>>     quirks
> >>>
> >>> b) For ACPI, the interface is defined in the ACPI spec across architectures
> >>>     and SoCs, we don't have host bridge drivers and the code that initializes
> >>>     the PCI is required early during boot and called from architecture
> >>>     code. There is no parent device, as ACPI sees PCI as a fundamental building
> >>>     block by itself, and there are no drivers because the firmware does
> >>>     the initial hardware setup, so we only have to access the config space.
> >>
> >> Hmmm, I'm a little confused, so why you think ACPI host driver should not use
> >> pci_create_host_bridge(), because ACPI PCI driver has no parent device ?
> >
> > It's one of the difference. Having a parent device can certainly make your
> > life simpler, since you have devm_kzalloc(), dev_info(), etc. Coming from
> > the other end, I think ACPI needs PCI to be available during early boot,
> > at a time where we might not want pci_create_host_bridge() to do the
> > right thing.
> 
> Device pointer is not required for ACPI, struct acpi_device is all we 
> need to get all that info. If pci_create_host_bridge() would be DT 
> specific, it would be nice to have sth similar for ACPI but that is out 
> of this patch set scope.

My point was more that we don't need to have something like it for ACPI,
since we don't get random drivers that need to be probed that way,
just one common implementation that calls into the PCI core. We should
of course share the common bits with pci_create_host_bridge() in some
form, but that can be done by moving the x86 pci_acpi_scan_root
function and/or acpi_pci_root_add() to a common place in drivers/pci
and then refactoring the internals.

	Arnd
