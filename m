Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3LSAU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:20:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:15085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3LSAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:20:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,510,1384329600"; 
   d="scan'208";a="446664333"
Date: Wed, 18 Dec 2013 16:25:19 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc: simplify platform data approach
Message-ID: <20131219002519.GB24731@psi-dev26.jf.intel.com>
References: <1386030001-18348-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386030001-18348-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:20:00PM -0800, David Cohen wrote:
> This patch removes the unnecessary enum for platform type to handle the
> array of pdatas. We can set pdata directly to pci_device_id struct
> instead.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Ping. Comments here?

Br, David

> ---
>  drivers/platform/x86/intel_scu_ipc.c | 84 +++++++++++++++++-------------------
>  1 file changed, 40 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
> index 60ea476a9130..259969d31055 100644
> --- a/drivers/platform/x86/intel_scu_ipc.c
> +++ b/drivers/platform/x86/intel_scu_ipc.c
> @@ -62,13 +62,6 @@
>  #define IPC_RWBUF_SIZE    20		/* IPC Read buffer Size */
>  #define IPC_IOC	          0x100		/* IPC command register IOC bit */
>  
> -enum {
> -	SCU_IPC_LINCROFT,
> -	SCU_IPC_PENWELL,
> -	SCU_IPC_CLOVERVIEW,
> -	SCU_IPC_TANGIER,
> -};
> -
>  /* intel scu ipc driver data*/
>  struct intel_scu_ipc_pdata_t {
>  	u32 ipc_base;
> @@ -78,35 +71,29 @@ struct intel_scu_ipc_pdata_t {
>  	u8 irq_mode;
>  };
>  
> -static struct intel_scu_ipc_pdata_t intel_scu_ipc_pdata[] = {
> -	[SCU_IPC_LINCROFT] = {
> -		.ipc_base = 0xff11c000,
> -		.i2c_base = 0xff12b000,
> -		.ipc_len = 0x100,
> -		.i2c_len = 0x10,
> -		.irq_mode = 0,
> -	},
> -	[SCU_IPC_PENWELL] = {
> -		.ipc_base = 0xff11c000,
> -		.i2c_base = 0xff12b000,
> -		.ipc_len = 0x100,
> -		.i2c_len = 0x10,
> -		.irq_mode = 1,
> -	},
> -	[SCU_IPC_CLOVERVIEW] = {
> -		.ipc_base = 0xff11c000,
> -		.i2c_base = 0xff12b000,
> -		.ipc_len = 0x100,
> -		.i2c_len = 0x10,
> -		.irq_mode = 1,
> -	},
> -	[SCU_IPC_TANGIER] = {
> -		.ipc_base = 0xff009000,
> -		.i2c_base  = 0xff00d000,
> -		.ipc_len  = 0x100,
> -		.i2c_len = 0x10,
> -		.irq_mode = 0,
> -	},
> +static struct intel_scu_ipc_pdata_t intel_scu_ipc_lincroft_pdata = {
> +	.ipc_base = 0xff11c000,
> +	.i2c_base = 0xff12b000,
> +	.ipc_len = 0x100,
> +	.i2c_len = 0x10,
> +	.irq_mode = 0,
> +};
> +
> +/* Penwell and Cloverview */
> +static struct intel_scu_ipc_pdata_t intel_scu_ipc_penwell_pdata = {
> +	.ipc_base = 0xff11c000,
> +	.i2c_base = 0xff12b000,
> +	.ipc_len = 0x100,
> +	.i2c_len = 0x10,
> +	.irq_mode = 1,
> +};
> +
> +static struct intel_scu_ipc_pdata_t intel_scu_ipc_tangier_pdata = {
> +	.ipc_base = 0xff009000,
> +	.i2c_base  = 0xff00d000,
> +	.ipc_len  = 0x100,
> +	.i2c_len = 0x10,
> +	.irq_mode = 0,
>  };
>  
>  static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id);
> @@ -583,15 +570,14 @@ static irqreturn_t ioc(int irq, void *dev_id)
>   */
>  static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  {
> -	int err, pid;
> +	int err;
>  	struct intel_scu_ipc_pdata_t *pdata;
>  	resource_size_t pci_resource;
>  
>  	if (ipcdev.pdev)		/* We support only one SCU */
>  		return -EBUSY;
>  
> -	pid = id->driver_data;
> -	pdata = &intel_scu_ipc_pdata[pid];
> +	pdata = (struct intel_scu_ipc_pdata_t *)id->driver_data;
>  
>  	ipcdev.pdev = pci_dev_get(dev);
>  	ipcdev.irq_mode = pdata->irq_mode;
> @@ -650,11 +636,21 @@ static void ipc_remove(struct pci_dev *pdev)
>  }
>  
>  static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
> -	{PCI_VDEVICE(INTEL, 0x082a), SCU_IPC_LINCROFT},
> -	{PCI_VDEVICE(INTEL, 0x080e), SCU_IPC_PENWELL},
> -	{PCI_VDEVICE(INTEL, 0x08ea), SCU_IPC_CLOVERVIEW},
> -	{PCI_VDEVICE(INTEL, 0x11a0), SCU_IPC_TANGIER},
> -	{ 0,}
> +	{
> +		PCI_VDEVICE(INTEL, 0x082a),
> +		(kernel_ulong_t)&intel_scu_ipc_lincroft_pdata,
> +	}, {
> +		PCI_VDEVICE(INTEL, 0x080e),
> +		(kernel_ulong_t)&intel_scu_ipc_penwell_pdata,
> +	}, {
> +		PCI_VDEVICE(INTEL, 0x08ea),
> +		(kernel_ulong_t)&intel_scu_ipc_penwell_pdata,
> +	}, {
> +		PCI_VDEVICE(INTEL, 0x11a0),
> +		(kernel_ulong_t)&intel_scu_ipc_tangier_pdata,
> +	}, {
> +		0,
> +	}
>  };
>  MODULE_DEVICE_TABLE(pci, pci_ids);
>  
> -- 
> 1.8.4.2
