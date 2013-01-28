Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3A1XSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:18:06 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53911 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3A1XSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:18:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130118114222.6698.7103.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114222.6698.7103.stgit@zurg>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 16:17:42 -0700
Message-ID: <CAErSpo4sEv-Qw1iztGn-SsPKZ=Y+st-tPAFOvsp17MUo6X=xrA@mail.gmail.com>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch effectively reverts commit 42eca2302146fed51335b95128e949ee6f54478f
> ("PCI: Don't touch card regs after runtime suspend D3")
>
> | This patch checks whether the pci state is saved and doesn't attempt to hit
> | any registers after that point if it is.
>
> This seems completely wrong. Yes, PCI configuration space has been saved by
> driver, but this doesn't means that all job is done and device has been
> suspended and ready for waking up in the future.
>
> For example driver e1000e for ethernet in my thinkpad x220 saves pci-state
> but device cannot wakeup after that, because it needs some ACPI callbacks
> which usually called from pci_finish_runtime_suspend().
>
> | Optimus (dual-gpu) laptops seem to have their own form of D3cold, but
> | unfortunately enter it on normal D3 transitions via the ACPI callback.
>
> Hardware which disappears from the bus unexpectedly is exception, so let's
> handle it as an exception. Its driver should set device state to D3cold and
> the rest code will handle it properly.

Functions in D3cold don't have power, so it's completely expected that
they would disappear from the bus and not respond to config accesses.
Maybe Dave was referring to D3hot, where functions *should* respond to
config accesses.  I dunno.

Just to be clear, it sounds like 42eca230 caused a regression on your
e1000e device?  If so, I guess we should revert it unless you and Dave
can figure out a better patch that fixes both your e1000e device and
the Optimus issue.

> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: linux-pci@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/pci/pci-driver.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index f79cbcd..030dbf0 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1005,10 +1005,11 @@ static int pci_pm_runtime_suspend(struct device *dev)
>                 return 0;
>         }
>
> -       if (!pci_dev->state_saved) {
> +       if (!pci_dev->state_saved)
>                 pci_save_state(pci_dev);
> +
> +       if (pci_dev->current_state != PCI_D3cold)
>                 pci_finish_runtime_suspend(pci_dev);
> -       }
>
>         return 0;
>  }
>
