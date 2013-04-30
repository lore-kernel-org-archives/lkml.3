Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240Ab3D3Rc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:32:28 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52755 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192Ab3D3RcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 30 Apr 2013 11:32:03 -0600
Message-ID: <CAErSpo6sY_BejDqgO1Qsko7qH+oKn+wAbu5MnhE8zQeQCc7Qng@mail.gmail.com>
Subject: Re: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0
 to type 1
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 1:21 AM, Bin Gao <bin.gao@linux.intel.com> wrote:
> x86/pci/mrst: force all pci config access toward 0:0:0, 0:2:0 and 0:3:0 to type 1
>
> For real pci devices 0:0:0, 0:2:0 and 0:3:0, there is either no pci shim, or
> no guarantee of data correctness of offset 256-4k. So for whatever reason,
> Linux kernel should not do MMCFG pci config access to those devices. Instead,
> always use type 1 for those devices.
>
> Signed-off-by: Bin Gao <bin.gao@linux.intel.com>

I applied this to my for-linus branch and will try to put this in v3.10.

> ---
>  arch/x86/pci/mrst.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index 6eb18c4..0e0fabf 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -141,6 +141,11 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
>   */
>  static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
>  {
> +       if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
> +                               || devfn == PCI_DEVFN(0, 0)
> +                               || devfn == PCI_DEVFN(3, 0)))
> +               return 1;
> +
>         /* This is a workaround for A0 LNC bug where PCI status register does
>          * not have new CAP bit set. can not be written by SW either.
>          *
> @@ -150,10 +155,7 @@ static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
>          */
>         if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
>                 return 0;
> -       if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
> -                               || devfn == PCI_DEVFN(0, 0)
> -                               || devfn == PCI_DEVFN(3, 0)))
> -               return 1;
> +
>         return 0; /* langwell on others */
>  }
>
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
