Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3DMFul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 01:50:41 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:39076 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3DMFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 01:50:39 -0400
MIME-Version: 1.0
In-Reply-To: <48795235.crcTAaJqPb@vostro.rjw.lan>
References: <48795235.crcTAaJqPb@vostro.rjw.lan>
Date: Fri, 12 Apr 2013 22:50:38 -0700
X-Google-Sender-Auth: XTFbdHaeY4Su1LPQt5Ev9571S_U
Message-ID: <CAE9FiQVEWy2MVfVmv4oL9D24OcF83dQv+OcFd5K6v8ZHeGumJA@mail.gmail.com>
Subject: Re: [PATCH] PCI / PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Benenati, Chris J" <chris.j.benenati@intel.com>,
        Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 4:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Commit b51306c (PCI: Set device power state to PCI_D0 for device
> without native PM support) modified pci_platform_power_transition()
> by adding code causing dev->current_state for devices that don't
> support native PCI PM but are power-manageable by the platform to be
> changed to PCI_D0 regardless of the value returned by the preceding
> platform_pci_set_power_state().  In particular, that also is done
> if the platform_pci_set_power_state() has been successful, which
> causes the correct power state of the device set by
> pci_update_current_state() in that case to be overwritten by PCI_D0.
>
> Fix that mistake by making the fallback to PCI_D0 only happen if
> the platform_pci_set_power_state() has returned an error.
>
> Reported-by: Chris J. Benenati <chris.j.benenati@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/pci/pci.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux-pm/drivers/pci/pci.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci.c
> +++ linux-pm/drivers/pci/pci.c
> @@ -646,8 +646,7 @@ static int pci_platform_power_transition
>                 error = platform_pci_set_power_state(dev, state);
>                 if (!error)
>                         pci_update_current_state(dev, state);
> -               /* Fall back to PCI_D0 if native PM is not supported */
> -               if (!dev->pm_cap)
> +               else if (!dev->pm_cap) /* Fall back to PCI_D0 */
>                         dev->current_state = PCI_D0;
>         } else {
>                 error = -ENODEV;
>

Acked-by: Yinghai Lu <yinghai@kernel.org>

also could simplify it further.

---
 drivers/pci/pci.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -646,15 +646,11 @@ static int pci_platform_power_transition
         error = platform_pci_set_power_state(dev, state);
         if (!error)
             pci_update_current_state(dev, state);
-        /* Fall back to PCI_D0 if native PM is not supported */
-        if (!dev->pm_cap)
-            dev->current_state = PCI_D0;
-    } else {
+    } else
         error = -ENODEV;
-        /* Fall back to PCI_D0 if native PM is not supported */
-        if (!dev->pm_cap)
-            dev->current_state = PCI_D0;
-    }
+
+    if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
+        dev->current_state = PCI_D0;

     return error;
 }
