Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3FATpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:45:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56442 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3FATpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:45:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] clean up scary strncpy(dst, src, strlen(src)) uses
Date: Sat, 01 Jun 2013 21:54:29 +0200
Message-ID: <1473633.hHuG9rKQnc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130531161807.GA9536@www.outflux.net>
References: <20130531161807.GA9536@www.outflux.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 31, 2013 09:18:07 AM Kees Cook wrote:
> Fix various weird constructions of strncpy(dst, src, strlen(src)). Length
> limits should be about the space available in the destination, not
> repurposed as a method to either always include or always exclude
> a trailing NULL byte. Either the NULL should always be copied
> (using strlcpy), or it should not be copied (using something like
> memcpy). Readable code should not depend on the weird behavior of strncpy
> when it hits the length limit. Better to avoid the anti-pattern entirely.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> This is a follow-up to the anti-pattern being fixed in iscsi-target,
> which was exploitable:
> "iscsi-target: fix heap buffer overflow on error"
> http://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=cea4dcfdad926a27a18e188720efe0f2c9403456
> ---
>  Documentation/accounting/getdelays.c             |    3 ++-
>  drivers/acpi/sysfs.c                             |    3 +--
>  drivers/s390/net/qeth_l3_sys.c                   |    6 ++----
>  drivers/staging/tidspbridge/rmgr/drv_interface.c |    3 +--
>  fs/hppfs/hppfs.c                                 |   11 ++++++-----
>  5 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index f8ebcde..5e4773d 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -23,6 +23,7 @@
>  #include <sys/socket.h>
>  #include <sys/wait.h>
>  #include <signal.h>
> +#include <bsd/string.h>
>  
>  #include <linux/genetlink.h>
>  #include <linux/taskstats.h>
> @@ -299,7 +300,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'C':
>  			containerset = 1;
> -			strncpy(containerpath, optarg, strlen(optarg) + 1);
> +			strlcpy(containerpath, optarg, sizeof(containerpath));
>  			break;
>  		case 'w':
>  			logfile = strdup(optarg);
> diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
> index fcae5fa..193745d 100644
> --- a/drivers/acpi/sysfs.c
> +++ b/drivers/acpi/sysfs.c
> @@ -677,10 +677,9 @@ void acpi_irq_stats_init(void)
>  		else
>  			sprintf(buffer, "bug%02X", i);
>  
> -		name = kzalloc(strlen(buffer) + 1, GFP_KERNEL);
> +		name = kstrdup(buffer, GFP_KERNEL);
>  		if (name == NULL)
>  			goto fail;
> -		strncpy(name, buffer, strlen(buffer) + 1);
>  
>  		sysfs_attr_init(&counter_attrs[i].attr);
>  		counter_attrs[i].attr.name = name;
> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
> index e70af24..d1c8025 100644
> --- a/drivers/s390/net/qeth_l3_sys.c
> +++ b/drivers/s390/net/qeth_l3_sys.c
> @@ -315,10 +315,8 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
>  	if (qeth_configure_cq(card, QETH_CQ_ENABLED))
>  		return -EPERM;
>  
> -	for (i = 0; i < 8; i++)
> -		card->options.hsuid[i] = ' ';
> -	card->options.hsuid[8] = '\0';
> -	strncpy(card->options.hsuid, tmp, strlen(tmp));
> +	snprintf(card->options.hsuid, sizeof(card->options.hsuid),
> +		 "%-8s", tmp);
>  	ASCEBC(card->options.hsuid, 8);
>  	if (card->dev)
>  		memcpy(card->dev->perm_addr, card->options.hsuid, 9);
> diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> index df0f37e..c4d632c 100644
> --- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
> +++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> @@ -421,12 +421,11 @@ static int omap3_bridge_startup(struct platform_device *pdev)
>  	drv_datap->tc_wordswapon = tc_wordswapon;
>  
>  	if (base_img) {
> -		drv_datap->base_img = kmalloc(strlen(base_img) + 1, GFP_KERNEL);
> +		drv_datap->base_img = kstrdup(base_img, GFP_KERNEL);
>  		if (!drv_datap->base_img) {
>  			err = -ENOMEM;
>  			goto err2;
>  		}
> -		strncpy(drv_datap->base_img, base_img, strlen(base_img) + 1);
>  	}
>  
>  	dev_set_drvdata(bridge, drv_datap);
> diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
> index cd3e389..d619b83 100644
> --- a/fs/hppfs/hppfs.c
> +++ b/fs/hppfs/hppfs.c
> @@ -69,7 +69,7 @@ static char *dentry_name(struct dentry *dentry, int extra)
>  	struct dentry *parent;
>  	char *root, *name;
>  	const char *seg_name;
> -	int len, seg_len;
> +	int len, seg_len, root_len;
>  
>  	len = 0;
>  	parent = dentry;
> @@ -81,7 +81,8 @@ static char *dentry_name(struct dentry *dentry, int extra)
>  	}
>  
>  	root = "proc";
> -	len += strlen(root);
> +	root_len = strlen(root);
> +	len += root_len;
>  	name = kmalloc(len + extra + 1, GFP_KERNEL);
>  	if (name == NULL)
>  		return NULL;
> @@ -91,7 +92,7 @@ static char *dentry_name(struct dentry *dentry, int extra)
>  	while (parent->d_parent != parent) {
>  		if (is_pid(parent)) {
>  			seg_name = "pid";
> -			seg_len = strlen("pid");
> +			seg_len = strlen(seg_name);
>  		}
>  		else {
>  			seg_name = parent->d_name.name;
> @@ -100,10 +101,10 @@ static char *dentry_name(struct dentry *dentry, int extra)
>  
>  		len -= seg_len + 1;
>  		name[len] = '/';
> -		strncpy(&name[len + 1], seg_name, seg_len);
> +		memcpy(&name[len + 1], seg_name, seg_len);
>  		parent = parent->d_parent;
>  	}
> -	strncpy(name, root, strlen(root));
> +	memcpy(name, root, root_len);
>  	return name;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
