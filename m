Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3IMBNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:13:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:16639 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab3IMBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,894,1371106800"; 
   d="scan'208";a="294289014"
Message-ID: <523266EC.1060501@intel.com>
Date: Fri, 13 Sep 2013 09:14:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com> <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com> <52323AC8.30403@gmail.com>
In-Reply-To: <52323AC8.30403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 06:06 AM, Sylwester Nawrocki wrote:
> On 09/11/2013 05:32 PM, Mika Westerberg wrote:
>> From: Aaron Lu<aaron.lu@intel.com>
>>
>> This patch adds runtime PM support for the I2C bus in a similar way that
>> has been done for PCI bus already. This means that the I2C bus core
>> prepares runtime PM for a client device just before a driver is about to be
>> bound to it. Devices that are not bound to any driver are not prepared for
>> runtime PM.
>>
>> In order to take advantage of this runtime PM support, the client device
>> driver needs drop the device runtime PM reference count by calling
>> pm_runtime_put() in its ->probe() callback and possibly implement rest of
>> the runtime PM callbacks.
>>
>> If the driver doesn't support runtime PM (like most of the existing I2C
>> client drivers), the device in question is regarded as being runtime PM
>> active and powered on.
>>
>> The patch adds also runtime PM support for the adapter device because it is
>> needed to be able to runtime power manage the I2C controller device. The
>> adapter device is handled along with the I2C controller device (it uses
>> pm_runtime_no_callbacks()).
>>
>> Signed-off-by: Aaron Lu<aaron.lu@intel.com>
>> Signed-off-by: Mika Westerberg<mika.westerberg@linux.intel.com>
>> ---
>>   drivers/i2c/i2c-core.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index f32ca29..44374b4 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
>>   					client->flags&  I2C_CLIENT_WAKE);
>>   	dev_dbg(dev, "probe\n");
>>
>> +	/* Make sure the adapter is active */
>> +	pm_runtime_get_sync(&client->adapter->dev);
> 
> So there is currently no way to avoid this behaviour, i.e. to have the 
> adapter
> not activated before any of its client devices is probed, but only later on,
> after explicit call to pm_runtime_get*(&client->dev) in the client driver ?

The above pm_runtime_get_sync is used to make sure when the client I2C
device is going to be probed, its host adapter device is turned on(or we
will fail the probe). It doesn't affect the adapter's status before the
probe of I2C client device.

Thanks,
Aaron
