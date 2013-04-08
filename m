Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936153Ab3DHOPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:15:44 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.198]:59775 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935972Ab3DHOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:15:42 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-8.tower-46.messagelabs.com!1365430540!24417245!7
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5162D0DA.6050505@digi.com>
Date: Mon, 8 Apr 2013 16:14:50 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>
Subject: Re: [PATCH v2] watchdog: core: don't try to stop device if not running
References: <1365412258-10785-1-git-send-email-hector.palacios@digi.com> <20130408134118.GA18644@roeck-us.net>
In-Reply-To: <20130408134118.GA18644@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 03:41 PM, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 11:10:58AM +0200, Hector Palacios wrote:
>> A watchdog device may be stopped from userspace using WDIOC_SETOPTIONS
>> ioctl and flag WDIOS_DISABLECARD. If the device is closed after this
>> operation, watchdog_release() is called and status bits checked for
>> stopping it. Besides, if the device has not been unregistered a critical
>> message "watchdog did not stop!" is printed, although the ioctl may have
>> successfully stopped it already.
>>
>> Without the patch a user application sample code like this will successfully
>> stop the watchdog, but the kernel will output the message
>> "watchdog did not stop!":
>>
>> 	wd_fd = open("/dev/watchdog", O_RDWR);
>>
>> 	flags = WDIOS_DISABLECARD;
>> 	ioctl(wd_fd, WDIOC_SETOPTIONS, &flags);
>>
>> 	close(wd_fd);
>>
>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>> ---
>>
>> Changes from v1:
>> - Make it less intrusive with 'if/else if' clauses
>> - Change the logic of 'err' variable for better readability of code
>> - Remove one-liner if brackets that broke coding sytle
>>
>>   drivers/watchdog/watchdog_dev.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
>> index ef8edec..8e0f1b8 100644
>> --- a/drivers/watchdog/watchdog_dev.c
>> +++ b/drivers/watchdog/watchdog_dev.c
>> @@ -463,15 +463,17 @@ out:
>>   static int watchdog_release(struct inode *inode, struct file *file)
>>   {
>>   	struct watchdog_device *wdd = file->private_data;
>> -	int err = -EBUSY;
>> +	int err = 0;
>>
>>   	/*
>>   	 * We only stop the watchdog if we received the magic character
>>   	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
>>   	 * watchdog_stop will fail.
>>   	 */
>> -	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
>> -	    !(wdd->info->options & WDIOF_MAGICCLOSE))
>> +	if (test_bit(WDOG_ACTIVE, &wdd->status))
>> +		err = -EBUSY;
>> +	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
>> +		 !(wdd->info->options & WDIOF_MAGICCLOSE))
>>   		err = watchdog_stop(wdd);
>>
> Looking at it again, it is now broken and fails with EBUSY if WDOG_ACTIVE is
> set, and it tries to stop the watchdog if it is already stopped.

You are right, good catch! So your patch version wins.
Thank you
-- 
Héctor Palacios
