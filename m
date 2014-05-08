Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaEHPWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:22:04 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55334 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaEHPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:22:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Magnus Damm <damm@opensource.se>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] pci: rcar host needs OF
Date: Thu, 08 May 2014 17:21:54 +0200
Message-ID: <9614403.Lyniq7F3TJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdWBzBneDqyDxK5HU3Bt_5CyRfTM_f_6YGJHokG_v17_sw@mail.gmail.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <536B9D78.5000602@codethink.co.uk> <CAMuHMdWBzBneDqyDxK5HU3Bt_5CyRfTM_f_6YGJHokG_v17_sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nxeyC4PrJvlEbcISfyWIg+emUt2iUYwgkJC1Une297i
 pn29Xmp1tp+nB6Y2edberLfWhNL29TQ5RRIiXjiqGLzTPS7KdY
 gKYGydt2JVACgoF78TWMAjddRAo1ZLm5MNhZDFM99iv2zc/x70
 ubAheA9uohIk4fO+0GoE4O2w4PhzH3YCWEuggMJrBot+NiRt2f
 XSUJVQujZ9giLEnO4K4BWWBfkIRauLPJiXfwteEJyxtbxN2Oli
 KQlLZNYherbCwkweNgprVoaLvDmIDecLT7Qu0CY0XeYH2JEvr0
 jCnDZ1bhqw0/Gc+d4kbz7A65fE3VZXURuOYJ7eATHARMjXqeZz
 6IKD2RNOFOo/ctbxdNGQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 17:16:32 Geert Uytterhoeven wrote:
> On Thu, May 8, 2014 at 5:06 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> > On 08/05/14 15:56, Arnd Bergmann wrote:
> >>
> >> The pci-rcar driver is enabled for compile tests, and this has
> >> now shown that the driver cannot build without CONFIG_OF,
> >> following the inclusion of f8f2fe7355fb "PCI: rcar: Use new OF
> >> interrupt mapping when possible":
> >>
> >> drivers/built-in.o: In function `rcar_pci_map_irq':
> >> :(.text+0x1cc7c): undefined reference to `of_irq_parse_and_map_pci'
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Magnus Damm <damm@opensource.se>
> >> Cc: linux-pci@vger.kernel.org
> >> Cc: linux-sh@vger.kernel.org
> >> ---
> >>   drivers/pci/host/Kconfig | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> >> index fbbef0b..4675f47 100644
> >> --- a/drivers/pci/host/Kconfig
> >> +++ b/drivers/pci/host/Kconfig
> >> @@ -27,7 +27,7 @@ config PCI_TEGRA
> >>
> >>   config PCI_RCAR_GEN2
> >>         bool "Renesas R-Car Gen2 Internal PCI controller"
> >> -       depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
> >> +       depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
> >>         help
> >>           Say Y here if you want internal PCI support on R-Car Gen2 SoC.
> >>           There are 3 internal PCI controllers available with a single
> >>
> >
> > This driver /should/ be able to be built for just the platform case
> > so it sounds like f8f2fe7355fb stopped this but no-one has yet to
> > notice.
> 
> You mean include/linux/of_pci.h should provide a dummy version of
> of_irq_parse_and_map_pci() returning 0 in case OF=n?

Good idea, I'll give this patch some testing in the randconfig builder,
replacing the one above.

	Arnd

diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 1a1f5ff..b6f2621 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -7,7 +7,6 @@
 struct pci_dev;
 struct of_phandle_args;
 int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq);
-int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
@@ -19,11 +18,14 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 int of_pci_msi_chip_add(struct msi_chip *chip);
 void of_pci_msi_chip_remove(struct msi_chip *chip);
 struct msi_chip *of_pci_find_msi_chip_by_node(struct device_node *of_node);
+int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 #else
 static inline int of_pci_msi_chip_add(struct msi_chip *chip) { return -EINVAL; }
 static inline void of_pci_msi_chip_remove(struct msi_chip *chip) { }
 static inline struct msi_chip *
 of_pci_find_msi_chip_by_node(struct device_node *of_node) { return NULL; }
+static inline int
+of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin) { return 0; }
 #endif
 
 #endif

