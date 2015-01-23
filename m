Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbbAWJzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:55:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37252 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbbAWJzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:55:16 -0500
Message-ID: <54C21A7E.1050304@collabora.co.uk>
Date: Fri, 23 Jan 2015 10:55:10 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] misc: Add cros_ec_lpc driver for x86 devices
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>	<1421954186-29764-4-git-send-email-javier.martinez@collabora.co.uk> <CAEUmHyYQ_oOE0Bd2Qi++DdJ2OMg=SuESx_pEJug4Ci=N0uYF0g@mail.gmail.com>
In-Reply-To: <CAEUmHyYQ_oOE0Bd2Qi++DdJ2OMg=SuESx_pEJug4Ci=N0uYF0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Varka,

Thanks a lot for your feedback.

On 01/23/2015 04:57 AM, Varka Bhadram wrote:
> (...)
>> +static int cros_ec_lpc_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct cros_ec_device *ec_dev;
>> +       int err = -ENOTTY;
>> +
>> +       if (!request_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE, MYNAME)) {
> 
> Why dont you use devres API for request_region()... Then maximum of
> your goto label regarding
> release region will gone...
>

Good point, I'll change that on next version.
 
>> +               dev_warn(dev, "couldn't reserve memmap region\n");
>> +               goto failed_memmap;
>> +       }
>> +
>> +       if ((inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID) != 'E') ||
>> +           (inb(EC_LPC_ADDR_MEMMAP + EC_MEMMAP_ID + 1) != 'C')) {
>> +               dev_warn(dev, "EC ID not detected\n");
>> +               goto failed_ec_probe;
>> +       }
>> +
>> +       if (!request_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE,
>> +                           MYNAME)) {
> 
> same...
> 
>> +               dev_warn(dev, "couldn't reserve region0\n");
>> +               goto failed_region0;
>> +       }
>> +       if (!request_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE,
>> +                           MYNAME)) {
> 
> same ...
> 
>> +               dev_warn(dev, "couldn't reserve region1\n");
>> +               goto failed_region1;
>> +       }
>> +
>> +       ec_dev = devm_kzalloc(dev, sizeof(*ec_dev), GFP_KERNEL);
>> +       if (!ec_dev) {
>> +               err = -ENOMEM;
>> +               goto failed_ec_dev;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, ec_dev);
>> +       ec_dev->dev = dev;
>> +       ec_dev->ec_name = pdev->name;
>> +       ec_dev->phys_name = dev_name(dev);
>> +       ec_dev->parent = dev;
>> +       ec_dev->cmd_xfer = cros_ec_cmd_xfer_lpc;
>> +       ec_dev->cmd_readmem = cros_ec_lpc_readmem;
>> +
>> +       err = cros_ec_register(ec_dev);
>> +       if (err) {
>> +               dev_warn(dev, "couldn't register ec_dev\n");
>> +               goto failed_ec_dev;
>> +       }
>> +
>> +       return 0;
>> +
>> +failed_ec_dev:
>> +       release_region(EC_HOST_CMD_REGION1, EC_HOST_CMD_REGION_SIZE);
>> +failed_region1:
>> +       release_region(EC_HOST_CMD_REGION0, EC_HOST_CMD_REGION_SIZE);
>> +failed_region0:
>> +failed_ec_probe:
>> +       release_region(EC_LPC_ADDR_MEMMAP, EC_MEMMAP_SIZE);
> 
> All these goto labels will be gone if you use devres API..
> 

Yes, I'll wait a couple more days to see if I get more feedback and re-post.

Best regards,
Javier

