Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaLSWZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:25:35 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44569 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaLSWZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:25:33 -0500
MIME-Version: 1.0
In-Reply-To: <5494A3D6.60607@gmx.de>
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
	<5494A3D6.60607@gmx.de>
Date: Sat, 20 Dec 2014 00:25:31 +0200
X-Google-Sender-Auth: grBOsAFLj7N90ZYEuQcBlLPwm5o
Message-ID: <CAEnQRZABxH5MuWEnS=RHmQqGUN0QhFTtXxnM1uyrLxvP2a-Rmg@mail.gmail.com>
Subject: Re: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
From: Daniel Baluta <daniel.baluta@intel.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, gwendal@chromium.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        beomho.seo@samsung.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "octavian.purdila@intel.com" <octavian.purdila@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 12:16 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
> Daniel Baluta schrieb am 18.12.2014 um 18:16:
>> When using ACPI, if acpi_match_device fails then chipset enum will be
>> uninitialized and &ak_def_array[chipset] will point to some bad address.
>>
>> This fixes the following compilation warning:
>>
>> drivers/iio/magnetometer/ak8975.c: In function ‘ak8975_probe’:
>> drivers/iio/magnetometer/ak8975.c:788:14: warning: ‘chipset’ may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
>>   data->def =ak_def_array[chipset];
>>
>> Reported-by: Octavian Purdila <octavian.purdila@intel.com>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> ---
>> This is a RFC because while I'm pretty sure that chipset should be initialized
>> with AK_MAX_TYPE in ak8975_match_acpi_device, I am not sure if we can live with
>> a NULL return value of ak8975_match_acpi_device. Current implementation ignores
>> return value of ak8975_match_acpi_device.
> This seems to be the actual problem: these _match_acpi_device functions return
> NULL on failure, and this should be checked for.

Ok, so this would acceptable?

diff --git a/drivers/iio/magnetometer/ak8975.c
b/drivers/iio/magnetometer/ak8975.c
index 0d10a4b..68d99e9 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -776,8 +776,9 @@ static int ak8975_probe(struct i2c_client *client,
                name = id->name;
        } else if (ACPI_HANDLE(&client->dev))
                name = ak8975_match_acpi_device(&client->dev, &chipset);
-       else
-               return -ENOSYS;
+
+       if (!name)
+               return -ENODEV;


I still have some doubts about return code in case of error.

For ak8975 we use -ENOSYS, but for kxcjk-1013 we use -ENODEV.

I will send a patch after we clear this out.

thanks,
Daniel.
