Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995Ab3DKRby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:31:54 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:39464 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935364Ab3DKRbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:31:52 -0400
Message-ID: <5166F39C.1050907@openwrt.org>
Date: Thu, 11 Apr 2013 19:32:12 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/2] MIPS: implement pcibios_get_phb_of_node
References: <1365098483-26821-1-git-send-email-juhosg@openwrt.org> <1365098483-26821-2-git-send-email-juhosg@openwrt.org> <CAErSpo4ih-Kgp4LxX1MDodac-eoPo=Mu1d6ex8oNnaEEc_GQnw@mail.gmail.com>
In-Reply-To: <CAErSpo4ih-Kgp4LxX1MDodac-eoPo=Mu1d6ex8oNnaEEc_GQnw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013.04.10. 18:31 keltezéssel, Bjorn Helgaas írta:
> On Thu, Apr 4, 2013 at 12:01 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> The of_node field of the device assigned to a
>> PCI bus is used during scanning of the PCI bus.
>> However on MIPS, the of_node field is assigned
>> only after the bus has been scanned.
>>
>> Implement the architecture specific version of
>> 'pcibios_get_phb_of_node'. Which ensures that the
>> PCI driver core will initialize the of_node field
>> before starting the scan.
>>
>> Also remove the local assignment of bus->dev.of_node,
>> it is not needed after the patch.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> I removed the __weak annotation from include/linux/pci.h and applied
> this patch to my pci/gabor-get-of-node.

Thank you!

> Give it a try and make sure
> it solves your problem.  If so, and Ralph approves, I can push both
> for v3.10.  It should appear at
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/gabor-get-of-node
> soon.

I have tried your patch on top of 3.9-rc6. The resulting kernel uses the
architecture specific implementation, and it runs fine.

  $ mipsel-openwrt-linux-readelf -s arch/mips/pci/built-in.o \
    drivers/pci/built-in.o vmlinux.o | grep pcibios_get_phb_of_node
      93: 0000046c    12 FUNC    GLOBAL DEFAULT    2 pcibios_get_phb_of_node
    1433: 00012a2c   104 FUNC    WEAK   DEFAULT    2 pcibios_get_phb_of_node
   31863: 001d4dbc    12 FUNC    GLOBAL DEFAULT    2 pcibios_get_phb_of_node
  $

For completeness, I have compiled it for X64 and for powerpc as well. I did not
try to run these kernels, but the output of readelf seems to be ok:

  $ readelf -s arch/x86/kernel/built-in.o drivers/pci/built-in.o vmlinux.o | \
    grep pcibios_get_phb_of_node
    2761: 000273a0    86 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
    1705: 00018770    77 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
   60364: 000278a0    86 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
  $

  $ powerpc-openwrt-linux-readelf -s arch/powerpc/kernel/built-in.o \
    drivers/pci/built-in.o  vmlinux.o | grep pcibios_get_phb_of_node
    1002: 0000ca28    12 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
    1485: 0001453c    88 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
   28959: 0000d598    12 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
  $

> Or if you prefer, you can take them through the MIPS tree.

Either is fine.

-Gabor
