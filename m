Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaBEG5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:57:12 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:51950 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaBEG5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <1391091027-31783-9-git-send-email-mathias.nyman@linux.intel.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<1391091027-31783-9-git-send-email-mathias.nyman@linux.intel.com>
Date: Tue, 4 Feb 2014 22:57:09 -0800
Message-ID: <CAPcyv4gFtrDVTE6JCLFqG4SP2SQNALNwstaULcM67Zi5RrpJ5Q@mail.gmail.com>
Subject: Re: [RFCv2 08/10] xhci: Add a global command queue
From: Dan Williams <dan.j.williams@intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 6:10 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> Create a list to store command structures, add a strucure to it every time
> a command is submitted, and remove it from the list once we get a
> command completion event matching the command.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-mem.c  |  8 ++++++++
>  drivers/usb/host/xhci-ring.c | 13 ++++++++++++-
>  drivers/usb/host/xhci.h      |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 49b8bd0..7f8e4c3 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -1694,6 +1694,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
>  {
>         struct pci_dev  *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
>         struct xhci_cd  *cur_cd, *next_cd;
> +       struct xhci_command *cur_cmd, *next_cmd;
>         int size;
>         int i, j, num_ports;
>
> @@ -1722,6 +1723,12 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
>                 kfree(cur_cd);
>         }
>
> +       list_for_each_entry_safe(cur_cmd, next_cmd,
> +                       &xhci->cmd_list, cmd_list) {
> +               list_del(&cur_cmd->cmd_list);
> +               kfree(cur_cmd);
> +       }
> +

Aren't commands on the cmd_list currently being executed, or are there
other guarantees that make sure all commands have terminated?
