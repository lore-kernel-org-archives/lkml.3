Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3EaD7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:59:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44312 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3EaD7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:59:32 -0400
Message-ID: <51A81FF9.8030403@linaro.org>
Date: Fri, 31 May 2013 11:58:49 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
References: <519E0F2A.4070602@linaro.org> <51A5E177.3090809@fold.natur.cuni.cz> <51A6B9A2.8090904@linaro.org> <2969934.XTKV7y9VVT@vostro.rjw.lan> <20130530222542.GD1630@kroah.com>
In-Reply-To: <20130530222542.GD1630@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------040608000109010708060807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040608000109010708060807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 2013-5-31 6:25, Greg Kroah-Hartman wrote:
> On Thu, May 30, 2013 at 03:57:58PM +0200, Rafael J. Wysocki wrote:
>> On Thursday, May 30, 2013 10:29:54 AM Hanjun Guo wrote:
>>> On 2013-5-29 19:07, Martin Mokrejs wrote:
>>>> Hanjun Guo wrote:
>>>>> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
>>>>>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
>>>>>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
>>>>>>> although the chances are small, I think it should be fixed.
>>>>>>>
>>>>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>>>>
>>>>>> This patch isn't necessary any more after the changes queued up for 3.11
>>>>>> in the acpi-hotplug branch of the linux-pm.git tree.
>>>>>
>>>>> Ok, I noticed your patch set, just drop my patch.
>>>>
>>>> But shouldn't this go to stable at least? I checked linux-3.9.4
>>>> and it applies fine. Whether this is relevant for other stable
>>>> series I will leave up to somebody else. ;)
>>>
>>> Hi Rafeal,
>>>
>>> What's your opinion on Martin's suggestion?
>>
>> Well, this is kind of hard to say.  We generally don't apply patches to -stable
>> that don't have mainline counterparts.
>>
>> Greg, I wonder what your opinion is?
> 
> We do not apply patches to -stable that are not in Linus's tree, unless
> there is no problem in Linus's tree due to a major rewrite of the code,
> and it has been confirmed that the same problem isn't there.

Hi Rafael,

I found that the problem is still there in your acpi-hotplug tree, sorry for
I didn't noticed early. I made a patch for this again, I hope it will make
sense to you.

The patch is attached, based on your acpi-hotplug tree.

Thanks
Hanjun




--------------040608000109010708060807
Content-Type: text/plain; charset=gb18030;
 name="0001-ACPI-processor-Fix-potential-NULL-pointer-dereferenc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ACPI-processor-Fix-potential-NULL-pointer-dereferenc.pa";
 filename*1="tch"

>From 975e30f5906a883e533e4226d8eca1c449c7366b Mon Sep 17 00:00:00 2001
From: Hanjun Guo <hanjun.guo@linaro.org>
Date: Fri, 31 May 2013 11:36:08 +0800
Subject: [PATCH 1/1] ACPI / processor: Fix potential NULL pointer dereference
 in acpi_processor_add()

In acpi_processor_add(), get_cpu_device() will return NULL in some cases,
and ACPI_HANDLE_SET() just use the return dev directly, this will case a
potential NULL pointer dereference, fix it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/acpi_processor.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 587d2af..4466b36 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -389,6 +389,11 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device,
 	per_cpu(processor_device_array, pr->id) = device;
 
 	dev = get_cpu_device(pr->id);
+	if (!dev) {
+		result = -ENODEV;
+		goto err;
+	}
+
 	ACPI_HANDLE_SET(dev, pr->handle);
 	result = acpi_bind_one(dev, NULL);
 	if (result)
-- 
1.7.9.5


--------------040608000109010708060807--
