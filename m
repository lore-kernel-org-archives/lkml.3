Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbbAJPbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 10:31:16 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:51783 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbAJPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 10:31:14 -0500
Date: Sat, 10 Jan 2015 08:31:09 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Graf <agraf@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: [PATCH v2] PCI/sysfs: off by two when checking the limit on
 driver_override length
Message-ID: <20150110153109.GJ6575@google.com>
References: <1420663977-30707-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420663977-30707-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Kim, Stuart]

On Wed, Jan 07, 2015 at 03:52:57PM -0500, Sasha Levin wrote:
> When printing the driver_override parameter when it is 4095 and 4094 bytes
> long the printing code would access invalid memory because we need count+1
> bytes for printing.

Hi Sasha,

I swear I'm not trying to be a nuisance, but wasn't there another fix for a
different memory corruption problem?  I was expecting two patches, but I
only see one.

If I understand this right, the problem is that driver_override_show() adds
"\n" at the end of the driver name, and the whole string (driver name +
newline) must fit within a page because sysfs show functions only have a
page to put their data in.

So the buffer overrun is in driver_override_show(), but the proposed fix is
in driver_override_store().  I think that's too complicated.  I'd rather
use snprintf(..., PAGE_SIZE, ...) in driver_override_show() because that's
a  common pattern and it's easy to verify that it's correct.

I don't think it's worth it to validate the length in
driver_override_store().  I think the pattern in resume_store() should be
sufficient, e.g.,

    if (count && buf[count - 1] == '\n')
        count--;
    name = kstrndup(buf, count, GFP_KERNEL);
    if (!name)
        return -ENOMEM;

    pdev->driver_override = name;
    kfree(old);

If a user sets a driver name that's 4KB long, and the output of
driver_override_show() is truncated, that doesn't seem like a real issue.

driver_override_store()/driver_override_show() in drivers/base/platform.c
(added by 3d713e0e382e ("driver core: platform: add device binding path
'driver_override'")) is basically the same code, and it looks like it has
the same two problems.  Can you add fix those at the same time?

Bjorn

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
> -- 
> 1.7.10.4
> 
