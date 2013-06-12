Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3FLVy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:54:59 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35352 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLVy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130612172132.GG27284@hpx.cz>
References: <20130612172132.GG27284@hpx.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Jun 2013 15:54:36 -0600
Message-ID: <CAErSpo5XvTHFf+ZO0GAxKm0xk+fo9Hm_G6Ebz1UmMkLUi8CPyw@mail.gmail.com>
Subject: Re: pcie aspm link setup, grandparent instead of parent?
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, Myron, Joe]

On Wed, Jun 12, 2013 at 11:21 AM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> Hello,
>
> as a consequence of hitting a NULL dereference bug[1] while downstream
> aspm is setting up link_state, I started to wonder why is the code
> skipping its parent bus in favour of grandparent's link_state.[2]
>
> Is this right? (I have no device to test on ...)
>
> Thanks.
>
> ---
> 1: https://bugzilla.redhat.com/show_bug.cgi?id=972381
>    The bug is hit because "pdev->bus->parent" has NULL "->parent" and thus
>    NULL "->self".
> 2: "pdev = bus->self", so "pdev->bus->parent == bus->parent->parent"
>
>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 403a443..d58e282 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -527,7 +527,7 @@ static struct pcie_link_state *alloc_pcie_link_state(struct pci_dev *pdev)
>         link->pdev = pdev;
>         if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM) {
>                 struct pcie_link_state *parent;
> -               parent = pdev->bus->parent->self->link_state;
> +               parent = pdev->bus->self->link_state;
>                 if (!parent) {
>                         kfree(link);
>                         return NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
