Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbbAWD5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:57:39 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:49007 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbbAWD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:57:24 -0500
MIME-Version: 1.0
In-Reply-To: <1421954186-29764-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
	<1421954186-29764-4-git-send-email-javier.martinez@collabora.co.uk>
Date: Fri, 23 Jan 2015 09:27:22 +0530
Message-ID: <CAEUmHyYQ_oOE0Bd2Qi++DdJ2OMg=SuESx_pEJug4Ci=N0uYF0g@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] misc: Add cros_ec_lpc driver for x86 devices
From: Varka Bhadram <varkabhadram@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:46 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> Chromebooks have an Embedded Controller (EC) that is used to
> implement various functions such as keyboard, power and battery.
>
> The AP can communicate with the EC through different bus types
> such as I2C, SPI or LPC.
>
> The cros_ec mfd driver is then composed of a core driver that
> register the sub-devices as mfd cells and provide a high level
> communication interface that is used by the rest of the kernel
> and bus specific interfaces modules.
>
> Each connection method then has its own driver, which register
> with the EC driver interface-agnostic interface.
>
> Currently, there are drivers to communicate with the EC over
> I2C and SPI and this driver adds support for LPC.
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>
> Changes since v2:
>  - Move out from drivers/mfd to drivers/misc. Suggested by Lee Jones.
>
> Changes since v1: None, new patch.
> ---
>  drivers/misc/Kconfig       |  10 ++
>  drivers/misc/Makefile      |   1 +
>  drivers/misc/cros_ec_lpc.c | 306 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 317 insertions(+)
>  create mode 100644 drivers/misc/cros_ec_lpc.c
(...)
> +static int cros_ec_lpc_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct cros_ec_device *ec_dev;
> +       int err = -ENOTTY;
> +
> +       if (!request_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE, MYNAME)) {

Why dont you use devres API for request_region()... Then maximum of
your goto label regarding
release region will gone...

> +               dev_warn(dev, "couldn't reserve memmap region\n");
> +               goto failed_memmap;
> +       }
> +
> +       if ((inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID) != 'E') ||
> +           (inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID + 1) != 'C')) {
> +               dev_warn(dev, "EC ID not detected\n");
> +               goto failed_ec_probe;
> +       }
> +
> +       if (!request_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE,
> +                           MYNAME)) {

same...

> +               dev_warn(dev, "couldn't reserve region0\n");
> +               goto failed_region0;
> +       }
> +       if (!request_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE,
> +                           MYNAME)) {

same ...

> +               dev_warn(dev, "couldn't reserve region1\n");
> +               goto failed_region1;
> +       }
> +
> +       ec_dev = devm_kzalloc(dev, sizeof(*ec_dev), GFP_KERNEL);
> +       if (!ec_dev) {
> +               err = -ENOMEM;
> +               goto failed_ec_dev;
> +       }
> +
> +       platform_set_drvdata(pdev, ec_dev);
> +       ec_dev->dev = dev;
> +       ec_dev->ec_name = pdev->name;
> +       ec_dev->phys_name = dev_name(dev);
> +       ec_dev->parent = dev;
> +       ec_dev->cmd_xfer = cros_ec_cmd_xfer_lpc;
> +       ec_dev->cmd_readmem = cros_ec_lpc_readmem;
> +
> +       err = cros_ec_register(ec_dev);
> +       if (err) {
> +               dev_warn(dev, "couldn't register ec_dev\n");
> +               goto failed_ec_dev;
> +       }
> +
> +       return 0;
> +
> +failed_ec_dev:
> +       release_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE);
> +failed_region1:
> +       release_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE);
> +failed_region0:
> +failed_ec_probe:
> +       release_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE);

All these goto labels will be gone if you use devres API..

> +failed_memmap:
> +       return err;
> +}
> +
> +static int cros_ec_lpc_remove(struct platform_device *pdev)
> +{
> +       struct cros_ec_device *ec_dev;
> +
> +       ec_dev = platform_get_drvdata(pdev);
> +       cros_ec_remove(ec_dev);
> +
> +       release_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE);
> +       release_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE);
> +       release_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE);
> +

These also will be gone....


-- 
Thanks and Regards,
Varka Bhadram.
