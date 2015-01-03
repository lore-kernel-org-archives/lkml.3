Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbbACPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 10:09:56 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52481 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbACPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 10:09:51 -0500
MIME-Version: 1.0
In-Reply-To: <1420158432-645-1-git-send-email-sasha.levin@oracle.com>
References: <1420158432-645-1-git-send-email-sasha.levin@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 3 Jan 2015 08:09:30 -0700
Message-ID: <CAErSpo6cBsE2nggKJ+D-oC-t6qrZu3WPCYXqw2orv6ZhsRujoQ@mail.gmail.com>
Subject: Re: [PATCH] PCI/sysfs: off by two and memory corruption in
 driver_override parameter
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 5:27 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> There are two different issues fixed here:
>
>  - On nun-NULL terminated input a random byte of memory would get flipped
> from '\n' to '\0'.
>  - When printing the driver_override parameter when it is 4095 and 4094 bytes
> long the printing code would access invalid memory.

Thanks, Sasha.

Can you please:

  - Split these two fixes into two separate patches
  - Look up the commit that introduced this code
  - CC the author
  - Add "Fixes: " lines
  - Add stable tags for the relevant kernels

Bjorn

> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/pci/pci-sysfs.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index aa012fb..be6b2b1 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -521,17 +521,17 @@ static ssize_t driver_override_store(struct device *dev,
>         struct pci_dev *pdev = to_pci_dev(dev);
>         char *driver_override, *old = pdev->driver_override, *cp;
>
> -       if (count > PATH_MAX)
> +       /* We need to keep extra room for a newline */
> +       if (count >= (PATH_MAX - 1))
>                 return -EINVAL;
>
>         driver_override = kstrndup(buf, count, GFP_KERNEL);
>         if (!driver_override)
>                 return -ENOMEM;
>
> -       cp = strchr(driver_override, '\n');
> -       if (cp)
> -               *cp = '\0';
> -
> +       driver_override[count] = '\0';
> +       if (driver_override[count - 1] == '\n')
> +               driver_override[count - 1] = 0;
>         if (strlen(driver_override)) {
>                 pdev->driver_override = driver_override;
>         } else {
> --
> 1.7.10.4
>
