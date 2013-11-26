Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3KZSil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:38:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21571 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3KZSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:38:38 -0500
Date: Tue, 26 Nov 2013 11:37:50 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Chang Liu <cl91tp@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Jility <jility09@gmail.com>,
        Florian Otti <f.otti@gmx.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] PCI: add a quirk for keeping Bus Master bit on shutdown
Message-ID: <20131126183750.GA29265@concerto>
References: <1384285203-642-1-git-send-email-cl91tp@gmail.com>
 <CAErSpo5E4584zgTt4ySPSEFhtwdHDOyrrowirp=SmtmJjDyHgg@mail.gmail.com>
 <5294CF1A.6080707@oracle.com>
 <CAErSpo6eAbVDfc8PFPP4b4HLzAjkFe23pJytu-TZq-V8-pfQMA@mail.gmail.com>
 <20131126174806.GA14789@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126174806.GA14789@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 05:48:06PM +0000, Matthew Garrett wrote:
> On Tue, Nov 26, 2013 at 10:35:26AM -0700, Bjorn Helgaas wrote:
> > On Tue, Nov 26, 2013 at 9:40 AM, Khalid Aziz <khalid.aziz@oracle.com> wrote:
> > > Disabling Bus Master bit is effectively a brute force and not an elegant way
> > > to stop unwanted DMA. It can have side effects as Alan and others pointed
> > > out in the original discussion, and we are now seeing one with Lynx Point on
> > > Acer.
> > 
> > I'm getting more queasy all the time about disabling Bus Master.  I
> > don't think RHEL does it, and that's probably where most kexec use is.
> >  So I doubt we really have much experience with it yet.
> 
> Does Windows disable the BM bit on shutdown? If not, it's likely that 
> there are platforms where the SMM code assumes it's still enabled. We 
> also know that there are devices that hang if BM is disabled while their 
> DMA engines are still running.
> 
> Unless we verify that Windows does this, I think there's no way we can 
> guarantee that firmware won't make assumptions about the state of PCI. 
> The easiest compromise would probably be to set a flag that disables 
> busmastering purely when we're performing a kexec.
> 

This is the approach that is most appealing to me. If we confine
clearing Bus Master bit to just the kexec path, we can side step all
the land mines in normal shutdown path. Here is an informal patch
just for comments and discussion. It has been tested lightly. If
this approach is acceptable, I will create a more formal patch.

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 9042fdb..c605be0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -400,10 +400,11 @@ static void pci_device_shutdown(struct device *dev)
 	pci_msix_shutdown(pci_dev);
 
 	/*
-	 * Turn off Bus Master bit on the device to tell it to not
-	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
+	 * If this is a kexec reboot, turn off Bus Master bit on the
+	 * device to tell it to not continue to do DMA. Don't touch
+	 * devices in D3cold or unknown states.
 	 */
-	if (pci_dev->current_state <= PCI_D3hot)
+	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
 		pci_clear_master(pci_dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9c91ecc..7d85733 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -9,6 +9,9 @@
 extern const unsigned char pcix_bus_speed[];
 extern const unsigned char pcie_link_speed[];
 
+/* flag to track if kexec reboot is in progress */
+extern unsigned long kexec_in_progress;
+
 /* Functions internal to the PCI core code */
 
 int pci_create_sysfs_dev_files(struct pci_dev *pdev);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 490afc0..fd2d63e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -47,6 +47,9 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
+/* Flag to indicate we are going to kexec a new kernel */
+unsigned long kexec_in_progress = 0;
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1675,6 +1678,7 @@ int kernel_kexec(void)
 	} else
 #endif
 	{
+		kexec_in_progress = 1;
 		kernel_restart_prepare(NULL);
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();


--
Khalid
