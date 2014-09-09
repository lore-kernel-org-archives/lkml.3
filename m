Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaIISRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:17:10 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59629 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIISRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:17:07 -0400
Message-ID: <540F4420.9090505@mvista.com>
Date: Tue, 09 Sep 2014 13:17:04 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        gouji.masayuki@jp.fujitsu.com
Subject: Re: [RESEND PATCH] ipmi: Clear drvdata when interface is removed
 by hotmod
References: <1410221957-4120-1-git-send-email-indou.takao@jp.fujitsu.com>
In-Reply-To: <1410221957-4120-1-git-send-email-indou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I can see the problem.  Instead of the change you have, can you add
something like:

if (!info)
        return;
if (info->dev)
        dev_set_drvdata(info->dev, NULL);

to the top of cleanup_one_si() instead?  I think that would be a cleaner
and more general.

-corey


On 09/08/2014 07:19 PM, Takao Indoh wrote:
> Add another email of maintainer just in case.
>
>
> This patch fixes a bug on hotmod removing.
>
> After ipmi interface is removed using hotmod, kernel panic occurs when
> rmmod impi_si. For example, try this:
>
>  # echo "remove,"`cat /proc/ipmi/0/params` > \
>  /sys/module/ipmi_si/parameters/hotmod
>  # rmmod ipmi_si
>
> Then, rmmod fails with the following messages.
>
> ------------[ cut here ]------------
> WARNING: CPU: 12 PID: 10819 at /mnt/repos/linux/lib/list_debug.c:53
> __list_del_entry+0x63/0xd0()
> (snip)
> CPU: 12 PID: 10819 Comm: rmmod Not tainted 3.17.0-rc1 #19
> Hardware name: FUJITSU-SV PRIMERGY BX920 S2/D3030, BIOS 080015
> Rev.3D81.3030 02/10/2012
>  0000000000000009 ffff88022d547d40 ffffffff81575778 ffff88022d547d88
>  ffff88022d547d78 ffffffff8104ec5d ffff88023908cdb0 ffffffffa06fa4e0
>  ffff8800bac20860 0000000000000000 0000000002046090 ffff88022d547dd8
> Call Trace:
>  [<ffffffff81575778>] dump_stack+0x45/0x56
>  [<ffffffff8104ec5d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff8104eccc>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffff811f60bf>] ? __kernfs_remove+0xdf/0x220
>  [<ffffffff81291213>] __list_del_entry+0x63/0xd0
>  [<ffffffff8129128d>] list_del+0xd/0x30
>  [<ffffffffa06f285a>] cleanup_one_si+0x2a/0x230 [ipmi_si]
>  [<ffffffffa06f2f05>] ipmi_pnp_remove+0x15/0x20 [ipmi_si]
>  [<ffffffff8131c7d4>] pnp_device_remove+0x24/0x40
>  [<ffffffff8137175f>] __device_release_driver+0x7f/0xf0
>  [<ffffffff81372100>] driver_detach+0xb0/0xc0
>  [<ffffffff81371415>] bus_remove_driver+0x55/0xd0
>  [<ffffffff8137283c>] driver_unregister+0x2c/0x50
>  [<ffffffff8131ca02>] pnp_unregister_driver+0x12/0x20
>  [<ffffffffa06f347c>] cleanup_ipmi_si+0xbc/0xf0 [ipmi_si]
>  [<ffffffff810c33f2>] SyS_delete_module+0x132/0x1c0
>  [<ffffffff81002ab9>] ? do_notify_resume+0x59/0x80
>  [<ffffffff8157c45a>] ? int_signal+0x12/0x17
>  [<ffffffff8157c1d2>] system_call_fastpath+0x16/0x1b
> ---[ end trace 70b4377268f85c23 ]---
>
> list_del in cleanup_one_si() fails because the smi_info is already
> removed when hotmod removing.
>
> When ipmi interface is removed by hotmod, smi_info is removed by
> cleanup_one_si(), but it is still set in drvdata. Therefore when rmmod
> ipmi_si, ipmi_pnp_remove tries to remove it again and fails.
>
> By this patch, a pointer to smi_info in drvdata is cleared when hotmod
> removing so that it will be not accessed when rmmod.
>
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 5d66568..20a3739 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1904,8 +1904,14 @@ static int hotmod_handler(const char *val, struct kernel_param *kp)
>  					continue;
>  				if (e->si_type != si_type)
>  					continue;
> -				if (e->io.addr_data == addr)
> -					cleanup_one_si(e);
> +				if (e->io.addr_data != addr)
> +					continue;
> +
> +				/* Clear driver data */
> +				if (e->dev)
> +					dev_set_drvdata(e->dev, NULL);
> +
> +				cleanup_one_si(e);
>  			}
>  			mutex_unlock(&smi_infos_lock);
>  		}
> @@ -2316,7 +2322,8 @@ static void ipmi_pnp_remove(struct pnp_dev *dev)
>  {
>  	struct smi_info *info = pnp_get_drvdata(dev);
>  
> -	cleanup_one_si(info);
> +	if (info)
> +		cleanup_one_si(info);
>  }
>  
>  static const struct pnp_device_id pnp_dev_table[] = {
> @@ -2621,7 +2628,8 @@ static int ipmi_pci_probe(struct pci_dev *pdev,
>  static void ipmi_pci_remove(struct pci_dev *pdev)
>  {
>  	struct smi_info *info = pci_get_drvdata(pdev);
> -	cleanup_one_si(info);
> +	if (info)
> +		cleanup_one_si(info);
>  	pci_disable_device(pdev);
>  }
>  
> @@ -2729,7 +2737,10 @@ static int ipmi_probe(struct platform_device *dev)
>  static int ipmi_remove(struct platform_device *dev)
>  {
>  #ifdef CONFIG_OF
> -	cleanup_one_si(dev_get_drvdata(&dev->dev));
> +	struct smi_info *info = dev_get_drvdata(&dev->dev);
> +
> +	if (info)
> +		cleanup_one_si(info);
>  #endif
>  	return 0;
>  }
> @@ -2796,7 +2807,11 @@ static int ipmi_parisc_probe(struct parisc_device *dev)
>  
>  static int ipmi_parisc_remove(struct parisc_device *dev)
>  {
> -	cleanup_one_si(dev_get_drvdata(&dev->dev));
> +	struct smi_info *info = dev_get_drvdata(&dev->dev);
> +
> +	if (info)
> +		cleanup_one_si(info);
> +
>  	return 0;
>  }
>  

