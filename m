Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3GTDz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 23:55:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3GTDz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 23:55:56 -0400
Date: Sat, 20 Jul 2013 06:55:29 +0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2] EDAC: Fix lockdep splat
Message-ID: <20130720065529.1aa63249.mchehab@infradead.org>
In-Reply-To: <1374229705-21471-1-git-send-email-bp@alien8.de>
References: <20130718232718.GA14824@pd.tnic>
	<1374229705-21471-1-git-send-email-bp@alien8.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 19 Jul 2013 12:28:25 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> From: Borislav Petkov <bp@suse.de>
> 
> Fix the following:
> 
> BUG: key ffff88043bdd0330 not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x565/0x5a0()
> DEBUG_LOCKS_WARN_ON(1)
> Modules linked in: glue_helper sb_edac(+) edac_core snd acpi_cpufreq lrw gf128mul ablk_helper iTCO_wdt evdev i2c_i801 dcdbas button cryptd pcspkr iTCO_vendor_support usb_common lpc_ich mfd_core soundcore mperf processor microcode
> CPU: 2 PID: 599 Comm: modprobe Not tainted 3.10.0 #1
> Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
>  0000000000000009 ffff880439a1d920 ffffffff8160a9a9 ffff880439a1d958
>  ffffffff8103d9e0 ffff88043af4a510 ffffffff81a16e11 0000000000000000
>  ffff88043bdd0330 0000000000000000 ffff880439a1d9b8 ffffffff8103dacc
> Call Trace:
>   dump_stack
>   warn_slowpath_common
>   warn_slowpath_fmt
>   lockdep_init_map
>   ? trace_hardirqs_on_caller
>   ? trace_hardirqs_on
>   debug_mutex_init
>   __mutex_init
>   bus_register
>   edac_create_sysfs_mci_device
>   edac_mc_add_mc
>   sbridge_probe
>   pci_device_probe
>   driver_probe_device
>   __driver_attach
>   ? driver_probe_device
>   bus_for_each_dev
>   driver_attach
>   bus_add_driver
>   driver_register
>   __pci_register_driver
>   ? 0xffffffffa0010fff
>   sbridge_init
>   ? 0xffffffffa0010fff
>   do_one_initcall
>   load_module
>   ? unset_module_init_ro_nx
>   SyS_init_module
>   tracesys
> ---[ end trace d24a70b0d3ddf733 ]---
> EDAC MC0: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#0': DEV 0000:3f:0e.0
> EDAC sbridge: Driver loaded.
> 
> What happens is that bus_register needs a statically allocated lock_key
> because the last is handed in to lockdep. However, struct mem_ctl_info
> embeds struct bus_type (the whole struct, not a pointer to it) and the
> whole thing gets dynamically allocated.
> 
> Fix this by using a statically allocated struct bus_type for the MC bus.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

But see below.

> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/edac/edac_mc.c       |  9 +++++++++
>  drivers/edac/edac_mc_sysfs.c | 28 +++++++++++++++-------------
>  drivers/edac/i5100_edac.c    |  2 +-
>  include/linux/edac.h         |  7 ++++++-
>  4 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 27e86d938262..c55ad285c285 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -48,6 +48,8 @@ static LIST_HEAD(mc_devices);
>   */
>  static void const *edac_mc_owner;
>  
> +static struct bus_type mc_bus[EDAC_MAX_MCS];
> +
>  unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
>  			         unsigned len)
>  {
> @@ -723,6 +725,11 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
>  	int ret = -EINVAL;
>  	edac_dbg(0, "\n");
>  
> +	if (mci->mc_idx >= EDAC_MAX_MCS) {
> +		pr_warn_once("Too many memory controllers: %d\n", mci->mc_idx);
> +		return ret;

Hmm... while I'm ok with returning -EINVAL, maybe instead it could be
returning some other error more meaningful error code (ENODEV?).

> +	}
> +
>  #ifdef CONFIG_EDAC_DEBUG
>  	if (edac_debug_level >= 3)
>  		edac_mc_dump_mci(mci);
> @@ -762,6 +769,8 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
>  	/* set load time so that error rate can be tracked */
>  	mci->start_time = jiffies;
>  
> +	mci->bus = &mc_bus[mci->mc_idx];
> +
>  	if (edac_create_sysfs_mci_device(mci)) {
>  		edac_mc_printk(mci, KERN_WARNING,
>  			"failed to create sysfs device\n");
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index ef15a7e613bc..e7c32c4f7837 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -370,7 +370,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
>  		return -ENODEV;
>  
>  	csrow->dev.type = &csrow_attr_type;
> -	csrow->dev.bus = &mci->bus;
> +	csrow->dev.bus = mci->bus;
>  	device_initialize(&csrow->dev);
>  	csrow->dev.parent = &mci->dev;
>  	csrow->mci = mci;
> @@ -605,7 +605,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
>  	dimm->mci = mci;
>  
>  	dimm->dev.type = &dimm_attr_type;
> -	dimm->dev.bus = &mci->bus;
> +	dimm->dev.bus = mci->bus;
>  	device_initialize(&dimm->dev);
>  
>  	dimm->dev.parent = &mci->dev;
> @@ -975,11 +975,13 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  	 * The memory controller needs its own bus, in order to avoid
>  	 * namespace conflicts at /sys/bus/edac.
>  	 */
> -	mci->bus.name = kasprintf(GFP_KERNEL, "mc%d", mci->mc_idx);
> -	if (!mci->bus.name)
> +	mci->bus->name = kasprintf(GFP_KERNEL, "mc%d", mci->mc_idx);
> +	if (!mci->bus->name)
>  		return -ENOMEM;
> -	edac_dbg(0, "creating bus %s\n", mci->bus.name);
> -	err = bus_register(&mci->bus);
> +
> +	edac_dbg(0, "creating bus %s\n", mci->bus->name);
> +
> +	err = bus_register(mci->bus);
>  	if (err < 0)
>  		return err;
>  
> @@ -988,7 +990,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  	device_initialize(&mci->dev);
>  
>  	mci->dev.parent = mci_pdev;
> -	mci->dev.bus = &mci->bus;
> +	mci->dev.bus = mci->bus;
>  	dev_set_name(&mci->dev, "mc%d", mci->mc_idx);
>  	dev_set_drvdata(&mci->dev, mci);
>  	pm_runtime_forbid(&mci->dev);
> @@ -997,8 +999,8 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  	err = device_add(&mci->dev);
>  	if (err < 0) {
>  		edac_dbg(1, "failure: create device %s\n", dev_name(&mci->dev));
> -		bus_unregister(&mci->bus);
> -		kfree(mci->bus.name);
> +		bus_unregister(mci->bus);
> +		kfree(mci->bus->name);
>  		return err;
>  	}
>  
> @@ -1064,8 +1066,8 @@ fail:
>  	}
>  fail2:
>  	device_unregister(&mci->dev);
> -	bus_unregister(&mci->bus);
> -	kfree(mci->bus.name);
> +	bus_unregister(mci->bus);
> +	kfree(mci->bus->name);
>  	return err;
>  }
>  
> @@ -1098,8 +1100,8 @@ void edac_unregister_sysfs(struct mem_ctl_info *mci)
>  {
>  	edac_dbg(1, "Unregistering device %s\n", dev_name(&mci->dev));
>  	device_unregister(&mci->dev);
> -	bus_unregister(&mci->bus);
> -	kfree(mci->bus.name);
> +	bus_unregister(mci->bus);
> +	kfree(mci->bus->name);
>  }
>  
>  static void mc_attr_release(struct device *dev)
> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
> index 1b635178cc44..157b934e8ce3 100644
> --- a/drivers/edac/i5100_edac.c
> +++ b/drivers/edac/i5100_edac.c
> @@ -974,7 +974,7 @@ static int i5100_setup_debugfs(struct mem_ctl_info *mci)
>  	if (!i5100_debugfs)
>  		return -ENODEV;
>  
> -	priv->debugfs = debugfs_create_dir(mci->bus.name, i5100_debugfs);
> +	priv->debugfs = debugfs_create_dir(mci->bus->name, i5100_debugfs);
>  
>  	if (!priv->debugfs)
>  		return -ENOMEM;
> diff --git a/include/linux/edac.h b/include/linux/edac.h
> index 0b763276f619..5c6d7fbaf89e 100644
> --- a/include/linux/edac.h
> +++ b/include/linux/edac.h
> @@ -622,7 +622,7 @@ struct edac_raw_error_desc {
>   */
>  struct mem_ctl_info {
>  	struct device			dev;
> -	struct bus_type			bus;
> +	struct bus_type			*bus;
>  
>  	struct list_head link;	/* for global list of mem_ctl_info structs */
>  
> @@ -742,4 +742,9 @@ struct mem_ctl_info {
>  #endif
>  };
>  
> +/*
> + * Maximum number of memory controllers in the coherent fabric.
> + */
> +#define EDAC_MAX_MCS	16
> +
>  #endif




Cheers,
Mauro
