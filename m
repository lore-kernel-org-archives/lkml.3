Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaGVFES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:04:18 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:29272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbaGVFEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:04:16 -0400
X-WSS-ID: 0N93K2F-07-RDG-02
X-M-MSG: 
Date: Tue, 22 Jul 2014 13:02:24 +0800
From: Huang Rui <ray.huang@amd.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Aaron Lu <aaron.lu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: core: hcd-pci: free IRQ before disabling PCI device
 when shutting down
Message-ID: <20140722050223.GA6811@hr-slim.amd.com>
References: <1405909068-2998-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405909068-2998-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(199002)(24454002)(189002)(479174003)(80022001)(86362001)(44976005)(77096002)(107046002)(84676001)(50986999)(83072002)(46102001)(575784001)(79102001)(102836001)(53416004)(85306003)(76176999)(20776003)(47776003)(85852003)(99396002)(31966008)(15975445006)(101416001)(33656002)(68736004)(81542001)(95666004)(74502001)(77982001)(92726001)(81342001)(19580395003)(106466001)(87936001)(97756001)(76482001)(74662001)(46406003)(64706001)(105586002)(97736001)(19580405001)(21056001)(83322001)(50466002)(23726002)(54356999)(110136001)(4396001)(92566001)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:17:44AM +0800, Jiang Liu wrote:
> The assigned IRQ should be freed before calling pci_disable_device()
> when shutting down system, otherwise it will cause following warning.
> [  568.879482] ------------[ cut here ]------------
> [  568.884236] WARNING: CPU: 1 PID: 3300 at /home/konrad/ssd/konrad/xtt-i386/bootstrap/linux-usb/fs/proc/generic.c:521 remove_proc_entry+0x165/0x170()
> [  568.897846] remove_proc_entry: removing non-empty directory 'irq/16', leaking at least 'ohci_hcd:usb4'
> [  568.907430] Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c_generic sg sd_mod crct10dif_generic crc_t10dif crct10dif_common radeon fbcon tileblit ttm font bitblit softcursor ata_generic ahci libahci drm_kms_helper skge r8169 libata mii scsi_mod wmi acpi_cpufreq
> [  568.938539] CPU: 1 PID: 3300 Comm: init Tainted: G        W     3.16.0-rc5upstream-01651-g03b9189 #1
> [  568.947946] Hardware name: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01/2010
> [  568.956008]  00000209 ed0f1cd0 c1617946 c175403c ed0f1d00 c1090c3f c1754084 ed0f1d2c
> [  568.964068]  00000ce4 c175403c 00000209 c11f22a5 c11f22a5 f755e8c0 ed0f1d78 f755e90d
> [  568.972128]  ed0f1d18 c1090cde 00000009 ed0f1d10 c1754084 ed0f1d2c ed0f1d60 c11f22a5
> [  568.980194] Call Trace:
> [  568.982715]  [<c1617946>] dump_stack+0x48/0x60
> [  568.987294]  [<c1090c3f>] warn_slowpath_common+0x7f/0xa0
> [  569.003887]  [<c1090cde>] warn_slowpath_fmt+0x2e/0x30
> [  569.009092]  [<c11f22a5>] remove_proc_entry+0x165/0x170
> [  569.014476]  [<c10da6ca>] unregister_irq_proc+0xaa/0xc0
> [  569.019858]  [<c10d582f>] free_desc+0x1f/0x60
> [  569.024346]  [<c10d58aa>] irq_free_descs+0x3a/0x80
> [  569.029283]  [<c10d9e9d>] irq_dispose_mapping+0x2d/0x50
> [  569.034666]  [<c1078fd3>] mp_unmap_irq+0x73/0xa0
> [  569.039423]  [<c107196b>] acpi_unregister_gsi_ioapic+0x2b/0x40
> [  569.045431]  [<c107180f>] acpi_unregister_gsi+0xf/0x20
> [  569.050725]  [<c1339cad>] acpi_pci_irq_disable+0x4b/0x50
> [  569.056196]  [<c14daa38>] pcibios_disable_device+0x18/0x20
> [  569.061848]  [<c130123d>] do_pci_disable_device+0x4d/0x60
> [  569.067410]  [<c13012b7>] pci_disable_device+0x47/0xb0
> [  569.077814]  [<c14800b1>] usb_hcd_pci_shutdown+0x31/0x40
> [  569.083285]  [<c1304b19>] pci_device_shutdown+0x19/0x50
> [  569.088667]  [<c13fda64>] device_shutdown+0x14/0x120
> [  569.093777]  [<c10ac29d>] kernel_restart_prepare+0x2d/0x30
> [  569.099429]  [<c10ac41e>] kernel_restart+0xe/0x60
> [  569.109028]  [<c10ac611>] SYSC_reboot+0x191/0x220
> [  569.159269]  [<c10ac6ba>] SyS_reboot+0x1a/0x20
> [  569.163843]  [<c161c718>] sysenter_do_call+0x12/0x16
> [  569.168951] ---[ end trace ccc1ec4471c289c9 ]---
> 
> Tested-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Reviewed-by: Huang Rui <ray.huang@amd.com>

> ---
> Hi Greg,
> 	This issue was triggered when testing patch set "use irqdomain
> to dynamically allocate IRQ for IOAPIC", please refer to
> https://lkml.org/lkml/2014/6/9/44 for more information.
> Regards!
> Gerry
> ---
>  drivers/usb/core/hcd-pci.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index 82044b5d6113..efc953119ce2 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -380,6 +380,8 @@ void usb_hcd_pci_shutdown(struct pci_dev *dev)
>  	if (test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags) &&
>  			hcd->driver->shutdown) {
>  		hcd->driver->shutdown(hcd);
> +		if (usb_hcd_is_primary_hcd(hcd) && hcd->irq > 0)
> +			free_irq(hcd->irq, hcd);
>  		pci_disable_device(dev);
>  	}
>  }
> -- 
> 1.7.10.4
> 
