Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbaCTWHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:07:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45549 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012AbaCTWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <1394710981-3596-1-git-send-email-daniel@numascale.com>
References: <1394710981-3596-1-git-send-email-daniel@numascale.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Mar 2014 16:07:25 -0600
Message-ID: <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kim.naru@amd.com,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, Myron, Suravee, Kim, Aravind]

On Thu, Mar 13, 2014 at 5:43 AM, Daniel J Blueman <daniel@numascale.com> wrote:
> For systems with multiple servers and routed fabric, all northbridges get
> assigned to the first server. Fix this by also using the node reported from
> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
> by definition, which are on NUMA node 0 by definition, so this is invarient
> on most systems.
>
> Tested on fam10h and fam15h single and multi-fabric systems and candidate
> for stable.

I wish this had been cc'd to linux-pci.  We're talking about a related
change by Suravee there.  In fact, we were hoping this quirk could be
removed altogether.

I don't understand what this quirk is doing.  Normally we discover the
NUMA node for a PCI host bridge via the ACPI _PXM method.  The way
_PXM works is that every PCI device in the hierarchy below the bridge
inherits the same node number as the host bridge.  I first thought
this might be a workaround for a system that lacks _PXM, but I don't
think that can be right, because you're only changing the node for a
few devices, not the whole hierarchy.

So I suspect the problem is more complicated, and maybe _PXM is
insufficient to describe the topology?  Are there subtrees that should
have nodes different from the host bridge?

I know this patch is already in v3.14-rc7, but I'd still like to
understand it so we can do the right thing with Suravee's patch.

Bjorn

> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
> Acked-by: Steffen Persvold <sp@numascale.com>
> ---
>  arch/x86/kernel/quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index 04ee1e2..52dbf1e 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
>                 return;
>
>         pci_read_config_dword(nb_ht, 0x60, &val);
> -       node = val & 7;
> +       node = pcibus_to_node(dev->bus) | (val & 7);
>         /*
>          * Some hardware may return an invalid node ID,
>          * so check it first:
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
