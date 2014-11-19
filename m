Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaKSQU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:20:58 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:52968 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaKSQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:20:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, bhelgaas@google.com, lorenzo.pieralisi@arm.com,
        wangyijing@huawei.com, hanjun.guo@linaro.org, Liviu.Dudau@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net,
        linaro-acpi@lists.linaro.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
Date: Wed, 19 Nov 2014 17:19:20 +0100
Message-ID: <2360791.Aj7tQ0nCJ3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416413091-13452-7-git-send-email-tomasz.nowicki@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org> <1416413091-13452-7-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3ZtH2AlUrutKSQX6J/+T5thaMOefccbBBJxWF1y3hGe
 rVy4OzPfaasHDIlBd5xJ/PpSxJDiFahuZ2sLE2uqK4r8RIZh93
 rX6QT+DDy/QmPtDn9cE9NEvn7e+FcgH2ZDMqYdpPpGubif5VKK
 vRBCw28bXLEPBzv5wAaRuA9deXpP5wfk+e11vT4vumCr8nyB9y
 y7KaGTc0ZbZ9WW/5tPwI4VQkkeS+RggyekBgLTnK4+hg6wo4HO
 m+sq+647la9/Ig8DOWJ+PWwiRYxrpggTxalY7MRCCggboYyZlX
 LmideIju208MSPKZ3Y0CcGiV1vLaNzPdcxvi7EnqtLyIEr4X4y
 xuzvK7QkhXUKBRU+ujHg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 17:04:51 Tomasz Nowicki wrote:
> +/*
> + * raw_pci_read/write - ACPI PCI config space accessors.
> + *
> + * ACPI spec defines MMCFG as the way we can access PCI config space,
> + * so let MMCFG be default (__weak).
> + *
> + * If platform needs more fancy stuff, should provides its own implementation.
> + */
> +int __weak raw_pci_read(unsigned int domain, unsigned int bus,
> +                       unsigned int devfn, int reg, int len, u32 *val)
> +{
> +       return pci_mmcfg_read(domain, bus, devfn, reg, len, val);
> +}
> +
> +int __weak raw_pci_write(unsigned int domain, unsigned int bus,
> +                        unsigned int devfn, int reg, int len, u32 val)
> +{
> +       return pci_mmcfg_write(domain, bus, devfn, reg, len, val);
> +}
> +
> 

I think it would be better to avoid __weak functions here, as they tend
to be hard to follow when trying to understand the code.

How about using a Kconfig symbol like this:

#ifdef CONFIG_ARCH_RAW_PCI_READWRITE
int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
                 int reg, int len, u32 *val);
int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
                  int reg, int len, u32 val);
#else
static inline int raw_pci_read(unsigned int domain, unsigned int bus,
	                       unsigned int devfn, int reg, int len, u32 *val)
{
	return pci_mmcfg_read(domain, bus, devfn, reg, len, val);
}

static inline int raw_pci_write(unsigned int domain, unsigned int bus,
             		                unsigned int devfn, int reg, int len, u32 val)
{
       return pci_mmcfg_write(domain, bus, devfn, reg, len, val);
}
#endif

Same thing for the weak symbols in patch 5.

	Arnd
