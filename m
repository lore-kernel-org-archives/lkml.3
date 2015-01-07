Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbbAGVEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:04:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbbAGVEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:04:02 -0500
Message-ID: <1420664631.6345.25.camel@redhat.com>
Subject: Re: [PATCH v2] PCI/sysfs: off by two when checking the limit on
 driver_override length
From: Alex Williamson <alex.williamson@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Graf <agraf@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Date: Wed, 07 Jan 2015 14:03:51 -0700
In-Reply-To: <1420663977-30707-1-git-send-email-sasha.levin@oracle.com>
References: <1420663977-30707-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 15:52 -0500, Sasha Levin wrote:
> When printing the driver_override parameter when it is 4095 and 4094 bytes
> long the printing code would access invalid memory because we need count+1
> bytes for printing.
> 
> Cc: <stable@vger.kernel.org> # v3.16+
> Fixes: 782a985d ("PCI: Introduce new device binding path using pci_dev.driver_override")
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/pci/pci-sysfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index aa012fb..17459ed 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -521,7 +521,8 @@ static ssize_t driver_override_store(struct device *dev,
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	char *driver_override, *old = pdev->driver_override, *cp;
>  
> -	if (count > PATH_MAX)
> +	/* We need to keep extra room for a newline */
> +	if (count >= (PATH_MAX - 1))
>  		return -EINVAL;
>  
>  	driver_override = kstrndup(buf, count, GFP_KERNEL);

Thanks for posting this Sasha, it fell off my plate with other
activities.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

