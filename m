Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaCUGo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:44:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38327 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaCUGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:44:27 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2L6hQGM003014, This message is accepted by code: ctloc85258
Message-ID: <532BDF8D.2060402@realtek.com>
Date: Fri, 21 Mar 2014 14:43:25 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 3/3] memstick: Add realtek USB memstick host driver
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com>	<1392199238-14500-4-git-send-email-rogerable@realtek.com> <20140320161827.5904bc407f9d3490514fd84e@linux-foundation.org>
In-Reply-To: <20140320161827.5904bc407f9d3490514fd84e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 07:18 AM, Andrew Morton wrote:
> On Wed, 12 Feb 2014 18:00:38 +0800 <rogerable@realtek.com> wrote:
>
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Realtek USB memstick host driver provides memstick host support based on the
>> Realtek USB card reader MFD driver.
>>
...
>> +static int rtsx_usb_ms_drv_probe(struct platform_device *pdev)
>> +{
>> +	struct memstick_host *msh;
>> +	struct rtsx_usb_ms *host;
>> +	struct rtsx_ucr *ucr;
>> +	int err;
>> +
>> +	ucr = usb_get_intfdata(to_usb_interface(pdev->dev.parent));
>> +	if (!ucr)
>> +		return -ENXIO;
>> +
>> +	dev_dbg(&(pdev->dev),
>> +			"Realtek USB Memstick controller found\n");
>> +
>> +	msh = memstick_alloc_host(sizeof(*host), &pdev->dev);
>> +	if (!msh)
>> +		return -ENOMEM;
>> +
>> +	host = memstick_priv(msh);
>> +	host->ucr = ucr;
>> +	host->msh = msh;
>> +	host->pdev = pdev;
>> +	host->power_mode = MEMSTICK_POWER_OFF;
>> +	platform_set_drvdata(pdev, host);
>> +
>> +	mutex_init(&host->host_mutex);
>> +	INIT_WORK(&host->handle_req, rtsx_usb_ms_handle_req);
>> +
>> +	init_completion(&host->detect_ms_exit);
>> +	host->detect_ms = kthread_create(rtsx_usb_detect_ms_card, host,
>> +			"rtsx_usb_ms_%d", pdev->id);
>> +	if (IS_ERR(host->detect_ms)) {
>> +		dev_dbg(&(pdev->dev),
>> +				"Unable to create polling thread.\n");
>> +		err = PTR_ERR(host->detect_ms);
>> +		goto err_out;
>> +	}
>> +
>> +	msh->request = rtsx_usb_ms_request;
>> +	msh->set_param = rtsx_usb_ms_set_param;
>> +	msh->caps = MEMSTICK_CAP_PAR4;
>> +
>> +	pm_runtime_enable(&pdev->dev);
>> +	err = memstick_add_host(msh);
>> +	if (err)
>> +		goto err_out;
>
> Isn't that kernel thread still running?
>
The kernel thread is created(kthread_create) but should not start before 
the "goto".

Did I miss anything or will it be better to move all kthread things 
after here?
>> +	wake_up_process(host->detect_ms);
>> +	return 0;
>> +err_out:
>> +	memstick_free_host(msh);
>> +	return err;
>> +}

Best regards,
Roger Tseng
