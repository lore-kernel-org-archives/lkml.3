Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAKBOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 20:14:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57775 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbbAKBOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 20:14:33 -0500
Message-ID: <54B1CE58.4040407@roeck-us.net>
Date: Sat, 10 Jan 2015 17:14:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 3/8] watchdog: at91rm9200: use the regmap from mfd
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com> <1420797094-9444-4-git-send-email-alexandre.belloni@free-electrons.com> <54B074B9.2090704@roeck-us.net> <20150110184146.GH2447@piout.net>
In-Reply-To: <20150110184146.GH2447@piout.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54B1CE78.00C2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2015 10:41 AM, Alexandre Belloni wrote:
> On 09/01/2015 at 16:39:21 -0800, Guenter Roeck wrote :
>> On 01/09/2015 01:51 AM, Alexandre Belloni wrote:
>>>   /* ......................................................................... */
>>> @@ -204,6 +201,7 @@ static struct miscdevice at91wdt_miscdev = {
>>>   static int at91wdt_probe(struct platform_device *pdev)
>>>   {
>>>   	int res;
>>> +	regmap_st = dev_get_drvdata(pdev->dev.parent);
>>>
>>
>> Is it guaranteed that parent is never NULL, and that the parent's
>> drvdata is always set ?
>>
>
> The only way to probe the driver left is to use platform_data. It is
> done from the MFD driver. If you prefer, I can test for NULL here and
> return.
>

I am fine if you are sure about that. The problem though is still the
check for double instantiation. Either the driver can not be instantiated
multiple times, and the check is no longer necessary, or it can, meaning
there must be some other means to instantiate it besides through the
mfd driver. And in that case you don't necessarily know if platform_data
is set.

>> Also, it seems that regmap_st will be overwritten if the device
>> is already open (see code below). That may not be a good idea.
>>
>
> I'm not sure what you meani, pdev->dev.parent and at91wdt_miscdev.parent
> are not the same thing. I didn't touch the code below but I believe
> there is no reason to pass in the probe twice and return -EBUSY.
>

Not sure I understand what my comment has to do with 'parent'.

The fact that the code checks if it has already been instantiated
suggests that the original author of the driver was concerned about
that case. Since you did not remove that check I have to assume that
this can still happen. If so, the second instantiation attempt will
overwrite regmap_st, since that variable is written prior to checking
for the dual instantiation.

Guenter

