Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3FQSIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:08:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33335 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3FQSIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:08:44 -0400
Date: Mon, 17 Jun 2013 12:08:40 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3, part2 14/20] PCI, DRM: use hotplug-safe iterators to
 walk PCI buses
Message-ID: <20130617180840.GA4233@google.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
 <1369583597-3801-15-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369583597-3801-15-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:53:11PM +0800, Jiang Liu wrote:
> Enhance DRM drvier to use hotplug-safe iterators to walk PCI buses.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_fops.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
> index 429e07d..dc8c40b 100644
> --- a/drivers/gpu/drm/drm_fops.c
> +++ b/drivers/gpu/drm/drm_fops.c
> @@ -359,9 +359,11 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
>  			pci_dev_put(pci_dev);
>  		}
>  		if (!dev->hose) {
> -			struct pci_bus *b = pci_bus_b(pci_root_buses.next);
> -			if (b)
> +			struct pci_bus *b = pci_get_next_root_bus(NULL);
> +			if (b) {
>  				dev->hose = b->sysdata;
> +				pci_bus_put(b);
> +			}

This is a gross hack to begin with, and it would be far better to get
rid of the whole "#ifdef __alpha__" block that contains this code.
I can't believe alpha is so special that it needs to do something
that no other arch needs.

>  		}
>  	}
>  #endif
> -- 
> 1.8.1.2
> 
