Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3A1XKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:10:01 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:58583 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3A1XJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:09:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130118114218.6698.42484.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114218.6698.42484.stgit@zurg>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 16:09:38 -0700
Message-ID: <CAErSpo5Cfi0KbOqDr4TfnzjWFy7V-oi0bOY-vf8Y16_RPtEGdQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] e1000e: fix pci device enable counter balance
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> __e1000_shutdown() calls pci_disable_device() at the end, thus __e1000_resume()
> should call pci_enable_device_mem() to keep enable counter in balance.
>
> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 2853c11..6bce796 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5598,6 +5598,13 @@ static int __e1000_resume(struct pci_dev *pdev)
>         pci_restore_state(pdev);
>         pci_save_state(pdev);
>
> +       err = pci_enable_device_mem(pdev);
> +       if (err) {
> +               dev_err(&pdev->dev,
> +                       "Cannot re-enable PCI device after suspend.\n");
> +               return err;
> +       }

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

Seems right to me, and the other users I looked at (igb, azx,
virtio_pci) call pci_disable_device() in .suspend() and call
pci_enable_device() in .resume() as you propose to do here.

I assume the e1000 folks will handle this patch (and the previous one).

> +
>         e1000e_set_interrupt_capability(adapter);
>         if (netif_running(netdev)) {
>                 err = e1000_request_irq(adapter);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
