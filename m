Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3JGMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:18:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:55871 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab3JGMSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:18:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1050,1371106800"; 
   d="scan'208";a="406559400"
Date: Mon, 7 Oct 2013 20:18:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [DMA-API] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000248
Message-ID: <20131007121809.GB28025@localhost>
References: <20131004014016.GA4958@localhost>
 <20131004104136.GK12758@n2100.arm.linux.org.uk>
 <20131007083813.GA21545@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007083813.GA21545@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Mon, Oct 07, 2013 at 09:38:13AM +0100, Russell King - ARM Linux wrote:
> Fengguang,
> 
> Have you done anything with this at all?  If not, don't expect me to
> sort this out, because I can't test this.  Thanks.

Sorry it's my fault to overlook this! Just queued up the test..

Thanks,
Fengguang

> On Fri, Oct 04, 2013 at 11:41:36AM +0100, Russell King - ARM Linux wrote:
> > On Fri, Oct 04, 2013 at 09:40:17AM +0800, Fengguang Wu wrote:
> > > This BUG does not show up in upstream and linux-next, so either the
> > > commit has not been merged or has been fixed somewhere.
> > 
> > That's because I haven't pushed it out into linux-next yet.  Thanks
> > for testing nevertheless.
> > 
> > > [  267.537083] sdhci-pltfm: SDHCI platform and OF driver helper
> > > [  267.602219] ledtrig-cpu: registered to indicate activity on CPUs
> > > [  267.656654] BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
> > > [  267.656689] IP: [<ffffffff810073c9>] dma_supported+0x9/0xa0
> > 
> > This seems to be saying that 'dev' was approximately a NULL pointer.
> > 
> > This is a wonderfully written driver this is... it's not really a
> > platform driver at all.  It stores the platform device into the global
> > dcdbas_pdev, and then references it from within the driver.  The problem
> > is caused by that happening before platform_device_register_full() has
> > returned and stored the platform device pointer.  It's use of a
> > platform device is just to be able to have some sysfs attributes which
> > it can play around with (I wonder if anyone has reviewed what it does
> > with these...)
> > 
> > You can also find goodies like this here:
> > 
> >         /*
> >          * We have to free the buffer here instead of dcdbas_remove
> >          * because only in module exit function we can be sure that
> >          * all sysfs attributes belonging to this module have been
> >          * released.
> >          */
> >         smi_data_buf_free();
> >         platform_device_unregister(dcdbas_pdev);
> >         platform_driver_unregister(&dcdbas_driver);
> > 
> > which is quite a statement in itself, and if it's thought about, how
> > can putting smi_data_buf_free() before platform_device_unregister()
> > here satisfy that comment.
> > 
> > Well, short of dropping the patch, I think the easiest solution here is
> > this, which annoyingly makes the mess slightly worse:
> > 
> > diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
> > index a85fda2..0a751bf 100644
> > --- a/drivers/firmware/dcdbas.c
> > +++ b/drivers/firmware/dcdbas.c
> > @@ -545,6 +545,8 @@ static int dcdbas_probe(struct platform_device *dev)
> >  	host_control_action = HC_ACTION_NONE;
> >  	host_control_smi_type = HC_SMITYPE_NONE;
> >  
> > +	dcdbas_pdev = dev;
> > +
> >  	/*
> >  	 * BIOS SMI calls require buffer addresses be in 32-bit address space.
> >  	 * This is done by setting the DMA mask below.
> > @@ -588,6 +590,8 @@ static const struct platform_device_info dcdbas_dev_info __initdata = {
> >  	.dma_mask	= DMA_BIT_MASK(32),
> >  };
> >  
> > +static struct platform_device *dcdbas_pdev_reg;
> > +
> >  /**
> >   * dcdbas_init: initialize driver
> >   */
> > @@ -599,9 +603,9 @@ static int __init dcdbas_init(void)
> >  	if (error)
> >  		return error;
> >  
> > -	dcdbas_pdev = platform_device_register_full(&dcdbas_dev_info);
> > -	if (IS_ERR(dcdbas_pdev)) {
> > -		error = PTR_ERR(dcdbas_pdev);
> > +	dcdbas_pdev_reg = platform_device_register_full(&dcdbas_dev_info);
> > +	if (IS_ERR(dcdbas_pdev_reg)) {
> > +		error = PTR_ERR(dcdbas_pdev_reg);
> >  		goto err_unregister_driver;
> >  	}
> >  
> > @@ -629,8 +633,9 @@ static void __exit dcdbas_exit(void)
> >  	 * all sysfs attributes belonging to this module have been
> >  	 * released.
> >  	 */
> > -	smi_data_buf_free();
> > -	platform_device_unregister(dcdbas_pdev);
> > +	if (dcdbas_pdev)
> > +		smi_data_buf_free();
> > +	platform_device_unregister(dcdbas_pdev_reg);
> >  	platform_driver_unregister(&dcdbas_driver);
> >  }
> > 
> > Another is to try and pull the direct references to dcdbas_pdev up the
> > call chains... that's easier said than done because there is a global
> > function in this driver - dcdbas_smi_request.  The best I can get to
> > is the below, which leaves three direct uses of dcdbas_pdev:
> > 
> > diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
> > index a85fda2..d9d215c 100644
> > --- a/drivers/firmware/dcdbas.c
> > +++ b/drivers/firmware/dcdbas.c
> > @@ -58,15 +58,15 @@ static unsigned int host_control_on_shutdown;
> >  /**
> >   * smi_data_buf_free: free SMI data buffer
> >   */
> > -static void smi_data_buf_free(void)
> > +static void smi_data_buf_free(struct device *dev)
> >  {
> >  	if (!smi_data_buf)
> >  		return;
> >  
> > -	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> > +	dev_dbg(dev, "%s: phys: %x size: %lu\n",
> >  		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
> >  
> > -	dma_free_coherent(&dcdbas_pdev->dev, smi_data_buf_size, smi_data_buf,
> > +	dma_free_coherent(dev, smi_data_buf_size, smi_data_buf,
> >  			  smi_data_buf_handle);
> >  	smi_data_buf = NULL;
> >  	smi_data_buf_handle = 0;
> > @@ -77,7 +77,7 @@ static void smi_data_buf_free(void)
> >  /**
> >   * smi_data_buf_realloc: grow SMI data buffer if needed
> >   */
> > -static int smi_data_buf_realloc(unsigned long size)
> > +static int smi_data_buf_realloc(struct device *dev, unsigned long size)
> >  {
> >  	void *buf;
> >  	dma_addr_t handle;
> > @@ -89,10 +89,9 @@ static int smi_data_buf_realloc(unsigned long size)
> >  		return -EINVAL;
> >  
> >  	/* new buffer is needed */
> > -	buf = dma_alloc_coherent(&dcdbas_pdev->dev, size, &handle, GFP_KERNEL);
> > +	buf = dma_alloc_coherent(dev, size, &handle, GFP_KERNEL);
> >  	if (!buf) {
> > -		dev_dbg(&dcdbas_pdev->dev,
> > -			"%s: failed to allocate memory size %lu\n",
> > +		dev_dbg(dev, "%s: failed to allocate memory size %lu\n",
> >  			__func__, size);
> >  		return -ENOMEM;
> >  	}
> > @@ -102,7 +101,7 @@ static int smi_data_buf_realloc(unsigned long size)
> >  		memcpy(buf, smi_data_buf, smi_data_buf_size);
> >  
> >  	/* free any existing buffer */
> > -	smi_data_buf_free();
> > +	smi_data_buf_free(dev);
> >  
> >  	/* set up new buffer for use */
> >  	smi_data_buf = buf;
> > @@ -110,7 +109,7 @@ static int smi_data_buf_realloc(unsigned long size)
> >  	smi_data_buf_phys_addr = (u32) virt_to_phys(buf);
> >  	smi_data_buf_size = size;
> >  
> > -	dev_dbg(&dcdbas_pdev->dev, "%s: phys: %x size: %lu\n",
> > +	dev_dbg(dev, "%s: phys: %x size: %lu\n",
> >  		__func__, smi_data_buf_phys_addr, smi_data_buf_size);
> >  
> >  	return 0;
> > @@ -141,7 +140,7 @@ static ssize_t smi_data_buf_size_store(struct device *dev,
> >  
> >  	/* make sure SMI data buffer is at least buf_size */
> >  	mutex_lock(&smi_data_lock);
> > -	ret = smi_data_buf_realloc(buf_size);
> > +	ret = smi_data_buf_realloc(dev, buf_size);
> >  	mutex_unlock(&smi_data_lock);
> >  	if (ret)
> >  		return ret;
> > @@ -166,6 +165,7 @@ static ssize_t smi_data_write(struct file *filp, struct kobject *kobj,
> >  			      struct bin_attribute *bin_attr,
> >  			      char *buf, loff_t pos, size_t count)
> >  {
> > +	struct device *dev = kobj_to_dev(kobj);
> >  	ssize_t ret;
> >  
> >  	if ((pos + count) > MAX_SMI_DATA_BUF_SIZE)
> > @@ -173,7 +173,7 @@ static ssize_t smi_data_write(struct file *filp, struct kobject *kobj,
> >  
> >  	mutex_lock(&smi_data_lock);
> >  
> > -	ret = smi_data_buf_realloc(pos + count);
> > +	ret = smi_data_buf_realloc(dev, pos + count);
> >  	if (ret)
> >  		goto out;
> >  
> > @@ -199,7 +199,7 @@ static ssize_t host_control_action_store(struct device *dev,
> >  
> >  	/* make sure buffer is available for host control command */
> >  	mutex_lock(&smi_data_lock);
> > -	ret = smi_data_buf_realloc(sizeof(struct apm_cmd));
> > +	ret = smi_data_buf_realloc(dev, sizeof(struct apm_cmd));
> >  	mutex_unlock(&smi_data_lock);
> >  	if (ret)
> >  		return ret;
> > @@ -347,7 +347,7 @@ EXPORT_SYMBOL(dcdbas_smi_request);
> >   *
> >   * Caller must set up the host control command in smi_data_buf.
> >   */
> > -static int host_control_smi(void)
> > +static int host_control_smi(struct device *dev)
> >  {
> >  	struct apm_cmd *apm_cmd;
> >  	u8 *data;
> > @@ -426,7 +426,7 @@ static int host_control_smi(void)
> >  		break;
> >  
> >  	default:
> > -		dev_dbg(&dcdbas_pdev->dev, "%s: invalid SMI type %u\n",
> > +		dev_dbg(dev, "%s: invalid SMI type %u\n",
> >  			__func__, host_control_smi_type);
> >  		return -ENOSYS;
> >  	}
> > @@ -443,7 +443,7 @@ static int host_control_smi(void)
> >   * use smi_data_buf at this point because the system has finished
> >   * shutting down and no userspace apps are running.
> >   */
> > -static void dcdbas_host_control(void)
> > +static void dcdbas_host_control(struct device *dev)
> >  {
> >  	struct apm_cmd *apm_cmd;
> >  	u8 action;
> > @@ -455,13 +455,12 @@ static void dcdbas_host_control(void)
> >  	host_control_action = HC_ACTION_NONE;
> >  
> >  	if (!smi_data_buf) {
> > -		dev_dbg(&dcdbas_pdev->dev, "%s: no SMI buffer\n", __func__);
> > +		dev_dbg(dev, "%s: no SMI buffer\n", __func__);
> >  		return;
> >  	}
> >  
> >  	if (smi_data_buf_size < sizeof(struct apm_cmd)) {
> > -		dev_dbg(&dcdbas_pdev->dev, "%s: SMI buffer too small\n",
> > -			__func__);
> > +		dev_dbg(dev, "%s: SMI buffer too small\n", __func__);
> >  		return;
> >  	}
> >  
> > @@ -472,12 +471,12 @@ static void dcdbas_host_control(void)
> >  		apm_cmd->command = ESM_APM_POWER_CYCLE;
> >  		apm_cmd->reserved = 0;
> >  		*((s16 *)&apm_cmd->parameters.shortreq.parm[0]) = (s16) 0;
> > -		host_control_smi();
> > +		host_control_smi(dev);
> >  	} else if (action & HC_ACTION_HOST_CONTROL_POWERCYCLE) {
> >  		apm_cmd->command = ESM_APM_POWER_CYCLE;
> >  		apm_cmd->reserved = 0;
> >  		*((s16 *)&apm_cmd->parameters.shortreq.parm[0]) = (s16) 20;
> > -		host_control_smi();
> > +		host_control_smi(dev);
> >  	}
> >  }
> >  
> > @@ -495,7 +494,7 @@ static int dcdbas_reboot_notify(struct notifier_block *nb, unsigned long code,
> >  			/* firmware is going to perform host control action */
> >  			printk(KERN_WARNING "Please wait for shutdown "
> >  			       "action to complete...\n");
> > -			dcdbas_host_control();
> > +			dcdbas_host_control(&dcdbas_pdev->dev);
> >  		}
> >  		break;
> >  	}
> > @@ -545,11 +544,13 @@ static int dcdbas_probe(struct platform_device *dev)
> >  	host_control_action = HC_ACTION_NONE;
> >  	host_control_smi_type = HC_SMITYPE_NONE;
> >  
> > +	dcdbas_pdev = dev;
> > +
> >  	/*
> >  	 * BIOS SMI calls require buffer addresses be in 32-bit address space.
> >  	 * This is done by setting the DMA mask below.
> >  	 */
> > -	error = dma_set_coherent_mask(&dcdbas_pdev->dev, DMA_BIT_MASK(32));
> > +	error = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
> >  	if (error)
> >  		return error;
> >  
> > @@ -588,6 +589,8 @@ static const struct platform_device_info dcdbas_dev_info __initdata = {
> >  	.dma_mask	= DMA_BIT_MASK(32),
> >  };
> >  
> > +static struct platform_device *dcdbas_pdev_reg;
> > +
> >  /**
> >   * dcdbas_init: initialize driver
> >   */
> > @@ -599,9 +602,9 @@ static int __init dcdbas_init(void)
> >  	if (error)
> >  		return error;
> >  
> > -	dcdbas_pdev = platform_device_register_full(&dcdbas_dev_info);
> > -	if (IS_ERR(dcdbas_pdev)) {
> > -		error = PTR_ERR(dcdbas_pdev);
> > +	dcdbas_pdev_reg = platform_device_register_full(&dcdbas_dev_info);
> > +	if (IS_ERR(dcdbas_pdev_reg)) {
> > +		error = PTR_ERR(dcdbas_pdev_reg);
> >  		goto err_unregister_driver;
> >  	}
> >  
> > @@ -629,8 +632,9 @@ static void __exit dcdbas_exit(void)
> >  	 * all sysfs attributes belonging to this module have been
> >  	 * released.
> >  	 */
> > -	smi_data_buf_free();
> > -	platform_device_unregister(dcdbas_pdev);
> > +	if (dcdbas_pdev)
> > +		smi_data_buf_free(&dcdbas_pdev->dev);
> > +	platform_device_unregister(dcdbas_pdev_reg);
> >  	platform_driver_unregister(&dcdbas_driver);
> >  }
> >  
