Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3KPP2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:28:52 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:51729 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3KPP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:28:45 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-20-52878f2c3ebb
Message-id: <52878F17.6020104@samsung.com>
Date: Sat, 16 Nov 2013 08:28:23 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, anton@enomsg.org,
        dwmw2@infradead.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, len.brown@intel.com, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] power: Change device_wakeup_enable() to check for null
 dev_name(dev)
References: <1384560238-10708-1-git-send-email-shuah.kh@samsung.com>
 <4035469.UfR6Rto3I2@vostro.rjw.lan> <5286B95F.4040306@samsung.com>
 <20131116002501.GA20625@kroah.com>
In-reply-to: <20131116002501.GA20625@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+wn65Of3uQwa2JAhYHt2paTFw5mdmi
	efF6NotZU/YyWVzeNYfN4nPvEUaLu6eOslmcOX2J1eLrTweLBRsfMTpweUzo/8TosXPWXXaP
	zSu0PBbvecnksX/uGnaPLVfbWTxWrP7O7vF5k1wARxSXTUpqTmZZapG+XQJXxou7bAVvBSqu
	ve5iamA8wdvFyMkhIWAi8abvKROELSZx4d56ti5GLg4hgWWMEr2brrNAOL1MEqf23YXKbGSU
	eLxzKTtIC6+AlsSD2/eZQWwWAVWJDTN/gI1iE1CX+Px6B1iNkICcRNOS1WA1ogIREkdXP2OF
	6BWU+DH5HguILSLgL7G2ZwvYAmaBW4wSHx6fACsSFoiW+D37OTvE5nWMEr92PWUDSXAK6Eus
	fboebCqzgLXEyknbGCFseYnNa94yQ2xWlvhz+RTQRRxAzylKbF9tNYFRZBaS3bOQdM9C0r2A
	kXkVo1hpcXJBcVJ6aoWxXnFibnFpXrpecn7uJkZIBNbsYLz31eYQowAHoxIPb4JfW5AQa2JZ
	cWXuIUYJDmYlEV5tw/YgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzOn9inT171L5b/WqSav+jr
	imrVPj7vwzbvmXNuuci9kgpe8KJASTvpRgzvqf4Xlya3S26f2sBldD/0adQl+W93fylIZT/c
	/v8Pg+pkn+1vPYXOxamwrX8kw/3m6OLb7/9cPfN5Rlqv4YnobZ8KTB/OWyiY8vwW+zNT73Mz
	qvhtE/7f5DEXf7NGiaU4I9FQi7moOBEA1HYzYp4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 05:25 PM, Greg KH wrote:
> On Fri, Nov 15, 2013 at 05:16:31PM -0700, Shuah Khan wrote:
>> On 11/15/2013 05:21 PM, Rafael J. Wysocki wrote:
>>> On Friday, November 15, 2013 05:03:57 PM Shuah Khan wrote:
>>>> device_wakeup_enable() uses dev_name(dev) as the wakeup source name.
>>>> When it gets called with a device with its name not yet set, ws structure
>>>> with ws->name = NULL gets created.
>>>>
>>>> When kernel is booted with wakeup_source_activate enabled, it will panic
>>>> when the trace point code tries to derefernces ws->name.
>>>>
>>>> Change device_wakeup_enable() to check for dev_name(dev) null condition
>>>> and return -EINVAL to avoid panics when device_wakeup_enable() gets called
>>>> before device is fully initialized with its name.
>>    		return -EINVAL;
>>>
>>> Can you please use WARN_ON(!dev_name(dev)) here?  While I agree that it is a
>>> bad idea to crash the kernel because dev has no name, that indicates a driver
>>> bug that shouldn't be too easy to ignore.
>>>
>>> Thanks!
>>>
>>
>> Right. ok I will re-cut the patch with WARN_ON and send it. fyi I did
>> send fix for the driver (power_supply) as well.
>>
>> http://www.kernelhub.org/?msg=362354&p=2
>
> Why is a driver calling kobject_set_name() instead of device_set_name()?
>
> Yes, it's really the same thing deep down, but drivers should never care
> about a kobject, just 'struct device'.  Well, even then it usually
> should care about it's type of 'struct device' but that's a different
> issue...
>
> Anyway, not saying your patch is wrong at all, just for the future if
> people are looking for code cleanups...
>

Use of kobject_set_name() did look odd to me. I will fix that for this 
driver by re-doing the patch while I am it. About the power_supply 
patch, stable needs fixing as well, and I will have to backport once he 
fix goes into the mainline.

http://www.kernelhub.org/?msg=362354&p=2 as is doesn't apply to 3.10 and 
3.11

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
