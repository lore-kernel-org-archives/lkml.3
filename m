Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3K0TiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:38:17 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41902 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3K0TiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:38:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: bhelgaas@google.com, cl91tp@gmail.com, tianyu.lan@intel.com,
        khlebnikov@openvz.org, gnomes@lxorguk.ukuu.org.uk,
        indou.takao@jp.fujitsu.com, jility09@gmail.com, f.otti@gmx.at,
        mjg59@srcf.ucam.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
Date: Wed, 27 Nov 2013 11:38:04 -0800
In-Reply-To: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
	(Khalid Aziz's message of "Wed, 27 Nov 2013 12:18:28 -0700")
Message-ID: <87ob55my8z.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19t6O6goykWhsbbWa0IV6n5J4pkbfh45bk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4290]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Khalid Aziz <khalid.aziz@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@oracle.com> writes:

> Add a flag to tell the PCI subsystem that kernel is shutting down
> in prepapration to kexec a kernel. Add code in PCI subsystem to use
> this flag to clear Bus Master bit on PCI devices only in case of
> kexec reboot. This fixes https://bugzilla.kernel.org/show_bug.cgi?id=63861
> and avoids any other issues caused by clearing Bus Master bit on PCI
> devices in normal shutdown path. This patch is based on discussion at
> http://marc.info/?l=linux-pci&m=138425645204355&w=2

Scratches head.

Given that most devices already call pci_disable_device which clears the
bus master bit how does this change anything meaningful?

Is is the problem here that most drivers are lazy and have a noop
shutdown method?

Eric


> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
> Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pci/pci-driver.c | 9 ++++++---
>  drivers/pci/pci.h        | 3 +++
>  kernel/kexec.c           | 4 ++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 9042fdb..e920195 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -400,10 +400,13 @@ static void pci_device_shutdown(struct device *dev)
>  	pci_msix_shutdown(pci_dev);
>  
>  	/*
> -	 * Turn off Bus Master bit on the device to tell it to not
> -	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
> +	 * If this is a kexec reboot, turn off Bus Master bit on the
> +	 * device to tell it to not continue to do DMA. Don't touch
> +	 * devices in D3cold or unknown states.
> +	 * If it is not a kexec reboot, firmware will hit the PCI
> +	 * devices with big hammer and stop their DMA any way.
>  	 */
> -	if (pci_dev->current_state <= PCI_D3hot)
> +	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
>  		pci_clear_master(pci_dev);
>  }
>  
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 9c91ecc..7d85733 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -9,6 +9,9 @@
>  extern const unsigned char pcix_bus_speed[];
>  extern const unsigned char pcie_link_speed[];
>  
> +/* flag to track if kexec reboot is in progress */
> +extern unsigned long kexec_in_progress;
> +
>  /* Functions internal to the PCI core code */
>  
>  int pci_create_sysfs_dev_files(struct pci_dev *pdev);
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 490afc0..fd2d63e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -47,6 +47,9 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>  size_t vmcoreinfo_size;
>  size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
>  
> +/* Flag to indicate we are going to kexec a new kernel */
> +unsigned long kexec_in_progress = 0;
> +
>  /* Location of the reserved area for the crash kernel */
>  struct resource crashk_res = {
>  	.name  = "Crash kernel",
> @@ -1675,6 +1678,7 @@ int kernel_kexec(void)
>  	} else
>  #endif
>  	{
> +		kexec_in_progress = 1;
>  		kernel_restart_prepare(NULL);
>  		printk(KERN_EMERG "Starting new kernel\n");
>  		machine_shutdown();
