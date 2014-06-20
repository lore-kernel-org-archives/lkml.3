Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaFTRqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:46:11 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:56686 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaFTRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:46:08 -0400
MIME-Version: 1.0
In-Reply-To: <1401345500-20188-5-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-5-git-send-email-kishon@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 20 Jun 2014 12:45:46 -0500
Message-ID: <CAL_JsqJxppWOOWoX1MYF26OWXW7BdMZP1BQpq8cSgJ3n1QF5PA@mail.gmail.com>
Subject: Re: [PATCH v2 04/18] PCI: designware: use untranslated address while
 programming ATU
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 1:38 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> address. So whenever the cpu issues a read/write request, the 4 most
> significant bits are used by L3 to determine the target controller.
> For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> the outbound translation window the *base* should be programmed as 0x000_0000.
> Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> we have programmed in the translation window with base as 0x000_0000.
>
> This is needed when the dt node is modelled something like below
> axi {
>         compatible = "simple-bus";
>         #size-cells = <1>;
>         #address-cells = <1>;
>         ranges = <0x0        0x20000000 0x10000000 // 28-bit bus
>                   0x51000000 0x51000000 0x3000>;
>         pcie@51000000 {
>                 reg = <0x1000 0x2000>, <0x51002000 0x14c>, <0x51000000 0x2000>;
>                 reg-names = "config", "ti_conf", "rc_dbics";
>                 #address-cells = <3>;
>                 #size-cells = <2>;
>                 ranges = <0x81000000 0 0          0x03000 0 0x00010000
>                           0x82000000 0 0x20013000 0x13000 0 0xffed000>;
>         };
> };
>
> Here the CPU address for configuration space is 0x20013000 and the controller
> address for configuration space is 0x13000. The controller address should be
> used while programming the ATU (in order for translation to happen properly in
> DRA7xx).

This talks about config space, but the ranges field is PCI memory
space. Also, does this actually work because I though Linux expects
memory BARs to be 1MB aligned.

Getting the controller offset should work whether you specify the
address as 0x13000 with translation or the absolute address
0x20013000. In other words, the driver should know how many bits to
mask off to get the offset.

Rob
