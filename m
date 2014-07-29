Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaG2OJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:09:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49440 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaG2OJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:09:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Paul.Mundt@huawei.com, Marc Zyngier <marc.zyngier@arm.com>,
        linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        virtualization@lists.linux-foundation.org,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Tue, 29 Jul 2014 16:08:27 +0200
Message-ID: <1748052.OMBQJiOLYT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5bs8qn1gAkHEHtZ1SJcvsX7pX4STk3VFDe0Wp3AC0VR
 GNSVHGyrUt0o7Qv0dM+QW5cwKP/fZORM+pTX2N8TwYFZW0aM5q
 N3AsAQU38IuG7sh8L1otQcfpIJfwn5biDEcY/EGMttW9j8M6VH
 yJSu2w4Zepy0JWGQyFu6VJ+Gy+9Km9YkB2LlT1Ox7x9/OiwQS8
 QWy3Pe84JVSA+HCtnCxDUIsBR1hEsit3SIBtWfdOiJ4TDEcCid
 At6rTX6VtQg59wfrNt6oSLn1vBAcJaGwGN3bWOkPX5V6VaIr5e
 cLG6YU77x639Z+Si4G61qPJ3R5f0hQ4+HsUmtnUkjL2bkzg3IQ
 A6NgxPwr0hgxN+joJ6iY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2014 11:08:37 Yijing Wang wrote:
>         The series is a draft of generic MSI driver that supports PCI
> and Non-PCI device which have MSI capability. If you're not interested
> it, sorry for the noise.

I've finally managed to take some time to look at the series. Overall,
the concept looks good to me, and the patches look very well implemented.

The part I'm not sure about is the interface we want to end up with
at the end of the series. More on that below

> The series is based on Linux-3.16-rc1.
> 
> MSI was introduced in PCI Spec 2.2. Currently, kernel MSI 
> driver codes are bonding with PCI device. Because MSI has a lot
> advantages in design. More and more non-PCI devices want to
> use MSI as their default interrupt. The existing MSI device
> include HPET. HPET driver provide its own MSI code to initialize
> and process MSI interrupts. In the latest GIC v3 spec, legacy device
> can deliver MSI by the help of a relay device named consolidator.
> Consolidator can translate the legacy interrupts connected to it
> to MSI/MSI-X. And new non-PCI device will be designed to 
> support MSI in future. So make the MSI driver code be generic will 
> help the non-PCI device use MSI more simply.
> 
> The new data struct for generic MSI driver.
> struct msi_irqs {
>         u8 msi_enabled:1; /* Enable flag */
>         u8 msix_enabled:1;
>         struct list_head msi_list; /* MSI desc list */
>         void *data;     /* help to find the MSI device */
>         struct msi_ops *ops; /* MSI device specific hook */
> };
> struct msi_irqs is used to manage MSI related informations. Every device supports
> MSI should contain this data struct and allocate it.

I think you should have a stronger association with the 'struct
device' here. Can you replace the 'void *data' with 'struct device *dev'?

The other part I'm not completely sure about is how you want to
have MSIs map into normal IRQ descriptors. At the moment, all
MSI users are based on IRQ numbers, but this has known scalability
problems. I wonder if we can do the interface in a way that
hides the interrupt number from generic device drivers and just
passes a 'struct irq_desc'. Note that there are long-term plans to
get rid of IRQ numbers entirely, but those plans have existed for
a long time already without anybody seriously addressing the device
driver interfaces so far, so it might never really happen.

> struct msi_ops {
>         struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi, struct msi_desc *entry);
>         int msix_setup_entries(struct msi_irqs *msi, struct msix_entry *entries);
>         u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
>         u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
>         void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
>         void (*msi_write_message)(struct msi_desc *desc, struct msi_msg *msg);
>         void (*msi_set_intx)(struct msi_irqs *msi, int enable);
> };
> struct msi_ops provides several hook functions, generic MSI driver will call
> the hook functions to access device specific registers. PCI devices will share
> the same msi_ops, because they have the same way to access MSI hardware registers.
> 
> Generic MSI layer export msi_capability_init() and msix_capability_init() functions
> to drivers. msi/x_capability_init() will initialize MSI capability data struct msi_desc
> and alloc the irq, then write the msi address/data value to hardware registers.
> 
> This series only did compile test, we will test it in x86 and arm platform later.

For the generic drivers, I don't see much point in differentiating between
MSI and MSI-X, as I believe the difference is something internal to the PCI
implementation.

With the other operations, I think they should all take a 'struct device *'
as the first argument for convenience and consistency. I don't think you actually
need msi_read_message(), and we could avoid msi_write_message() by doing it
the other way round.

What I'd envision as the API from the device driver perspective is something
as simple like this:

struct msi_desc *msi_request(struct msi_chip *chip, irq_handler_t handler,
			unsigned long flags, const char *name, struct device *dev);

which would get an msi descriptor that is valid for this device (dev)
connected to a particular msi_chip, and associate a handler function
with it. The device driver can call that function and retrieve the
address/message pair from the msi_desc in order to store it in its own
device specific registers. The request_irq() can be handled internally
to msi_request().

Would that work for you?

	Arnd
