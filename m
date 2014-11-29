Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaK2SBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:01:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34381 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaK2SBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:01:32 -0500
Message-ID: <547A09AA.9010505@roeck-us.net>
Date: Sat, 29 Nov 2014 10:00:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        "lm-sensors >> LM Sensors" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <20141129174315.GA32132@kroah.com>
In-Reply-To: <20141129174315.GA32132@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.547A09F2.0099,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On 11/29/2014 09:43 AM, Greg Kroah-Hartman wrote:
> On Sat, Nov 29, 2014 at 05:04:07PM +0100, Pali Rohár wrote:
>> This patch adds labels for temperature sensors if SMM function with EAX register
>> 0x11a3 reports it. These informations was taken from DOS binary NBSVC.MDM.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> ---
>>   drivers/char/i8k.c |  110 +++++++++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 88 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
>> index e34a019..77af46b 100644
>> --- a/drivers/char/i8k.c
>> +++ b/drivers/char/i8k.c
>> @@ -42,6 +42,7 @@
>>   #define I8K_SMM_GET_FAN		0x00a3
>>   #define I8K_SMM_GET_SPEED	0x02a3
>>   #define I8K_SMM_GET_TEMP	0x10a3
>> +#define I8K_SMM_GET_TEMP_TYPE	0x11a3
>>   #define I8K_SMM_GET_DELL_SIG1	0xfea3
>>   #define I8K_SMM_GET_DELL_SIG2	0xffa3
>>
>> @@ -288,6 +289,14 @@ static int i8k_set_fan(int fan, int speed)
>>   	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
>>   }
>>
>> +static int i8k_get_temp_type(int sensor)
>> +{
>> +	struct smm_regs regs = { .eax = I8K_SMM_GET_TEMP_TYPE, };
>> +
>> +	regs.ebx = sensor & 0xff;
>> +	return i8k_smm(&regs) ? : regs.eax & 0xff;
>> +}
>> +
>>   /*
>>    * Read the cpu temperature.
>>    */
>> @@ -493,6 +502,29 @@ static int i8k_open_fs(struct inode *inode, struct file *file)
>>    * Hwmon interface
>>    */
>>
>> +static ssize_t i8k_hwmon_show_temp_label(struct device *dev,
>> +				   struct device_attribute *devattr,
>> +				   char *buf)
>> +{
>> +	static const char * const labels[] = {
>> +		"CPU",
>> +		"GPU",
>> +		"SODIMM",
>> +		"Other",
>> +		"Ambient",
>> +		"Other",
>> +	};Documentation/hwmon/
>> +	int index = to_sensor_dev_attr(devattr)->index;
>> +	int type;
>> +
>> +	type = i8k_get_temp_type(index);
>> +	if (type < 0)
>> +		return type;
>> +	if (type >= ARRAY_SIZE(labels))
>> +		type = ARRAY_SIZE(labels) - 1;
>> +	return sprintf(buf, "%s\n", labels[type]);
>> +}
>
> No Documentation/ABI/ entry for your new sysfs file?
>
That would be Documentation/hwmon/sysfs-interface,
presumably for historic reasons (its existence precedes
the existence of Documentation/ABI).

Question might be if we should move that file at some point
to Documentation/ABI/<some-name>, though that would be a
major effort.

Guenter

