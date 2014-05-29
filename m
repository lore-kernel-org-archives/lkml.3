Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaE2Pfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:35:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52385 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbaE2Pf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:35:29 -0400
Message-ID: <53875399.2020700@ti.com>
Date: Thu, 29 May 2014 11:34:49 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-6-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel>
In-Reply-To: <6048322.x3M3sdDEWO@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2014 12:23 PM, Arnd Bergmann wrote:
> On Thursday 15 May 2014 12:01:32 Murali Karicheri wrote:
>
>> +static int
>> +keystone_pcie_fault(unsigned long addr, unsigned int fsr,
>> +		struct pt_regs *regs)
>> +{
>> +	unsigned long instr = *(unsigned long *) instruction_pointer(regs);
>> +
>> +	if ((instr & 0x0e100090) == 0x00100090) {
>> +		int reg = (instr >> 12) & 15;
>> +
>> +		regs->uregs[reg] = -1;
>> +		regs->ARM_pc += 4;
>> +	}
>> +
>> +	return 0;
>> +}
> This needs to check in the PCI host registers what happened and do
> some appropriate action. If the fault was not caused by PCIe, it
> should not be ignored here but get passed on to the next handler.
>
>
Arnd,

The PCI controller is not able to detect the abort error from the EP and 
this gets
reported to ARM as an Asynchronous external abort. PCI fault handler 
needs to
consume this fault, otherwise it can't work on the Keystone h/w.

For example pci-imx6.c has

/*  Added for PCI abort handling */
static int imx6q_pcie_abort_handler(unsigned long addr,
                 unsigned int fsr, struct pt_regs *regs)
{
         return 0;
}

Other examples are

1) arch/arm/mach-cns3xxx/pci.c
static int cns3xxx_pcie_abort_handler(unsigned long addr, unsigned int fsr,
                                       struct pt_regs *regs)
{
         if (fsr & (1 << 10))
                 regs->ARM_pc += 4;
         return 0;
}
2) arch/.arm/plat-iop/pci.c
/*
  * When a PCI device does not exist during config cycles, the 80200 gets a
  * bus error instead of returning 0xffffffff. This handler simply returns.
  */
static int
iop3xx_pci_abort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
{
         DBG("PCI abort: address = 0x%08lx fsr = 0x%03x PC = 0x%08lx LR 
= 0x%08lx\n",
                 addr, fsr, regs->ARM_pc, regs->ARM_lr);

         /*
          * If it was an imprecise abort, then we need to correct the
          * return address to be _after_ the instruction.
          */
         if (fsr & (1 << 10))
                 regs->ARM_pc += 4;

         return 0;
}

I suggest we document this as done in plat-iop. Let me know as I need to 
post my
v2 of the patch this week that incorporates all the comments so far on v1.

Murali
