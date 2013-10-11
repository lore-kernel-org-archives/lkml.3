Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3JKXRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:17:25 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63679 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3JKXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:17:20 -0400
Date: Fri, 11 Oct 2013 18:17:17 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: scottwood@freescale.com
Cc: R65777@freescale.com, B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org, a.motakis@virtualopensystems.com,
        agraf@suse.de, B16395@freescale.com, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
Message-Id: <20131011181717.e4051736cf42c5a647222941@linaro.org>
In-Reply-To: <1381524220.7979.560.camel@snotra.buserror.net>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	<1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	<1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
	<1381524220.7979.560.camel@snotra.buserror.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 15:43:40 -0500
Scott Wood <scottwood@freescale.com> wrote:

> On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> > Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
> > conflics with other drivers in the event of a hotplug.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 6ab71b9..bdd7833 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -901,6 +901,9 @@ static struct pci_driver vfio_pci_driver = {
> >  	.probe		= vfio_pci_probe,
> >  	.remove		= vfio_pci_remove,
> >  	.err_handler	= &vfio_err_handlers,
> > +	.driver = {
> > +		.sysfs_bind_only = true,
> > +	},
> >  };
> >  
> >  static void __exit vfio_pci_cleanup(void)
> 
> You also need to add a PCI_ANY_ID match in order to be able to get rid
> of the new_id usage.

thanks - see below.

Can someone with a PCI bus test this?  Bharat?

Kim

>From a8d6c12f2ec763c2ac7fd384a3397c370cc1b932 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@linaro.org>
Date: Thu, 10 Oct 2013 22:16:34 -0500
Subject: [PATCH 3/4 v2] VFIO: pci: amend vfio-pci for explicit binding via sysfs
 only

Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
conflics with other drivers in the event of a hotplug.  Also replace
the only dynamic ids assignment with a table with a single PCI_ANY_ID
entry since writing the sysfs bind file without having to specify ids
via the new_id file first should no longer be necessary.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
 drivers/vfio/pci/vfio_pci.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6ab71b9..c5b434f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -895,12 +895,22 @@ static struct pci_error_handlers vfio_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
 
+static DEFINE_PCI_DEVICE_TABLE(vfio_pci_id_table) = {
+        { PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID) },
+        { 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, vfio_pci_id_table);
+
 static struct pci_driver vfio_pci_driver = {
 	.name		= "vfio-pci",
-	.id_table	= NULL, /* only dynamic ids */
+	.id_table	= vfio_pci_id_table, /* no dynamic ids */
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
 	.err_handler	= &vfio_err_handlers,
+	.driver = {
+		.sysfs_bind_only = true, /* bind only via sysfs */
+	},
 };
 
 static void __exit vfio_pci_cleanup(void)
-- 
1.8.4
