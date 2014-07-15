Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbaGOVvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:51:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:63622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759933AbaGOVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,668,1400050800"; 
   d="diff'?scan'208";a="543840091"
Message-ID: <53C59F78.8060009@linux.intel.com>
Date: Tue, 15 Jul 2014 14:39:04 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v5 0/4] iio: Add support for rotation from north
References: <1404934213-2733-1-git-send-email-reyad.attiyat@gmail.com> <53BD9BD5.5030204@linux.intel.com> <CA+BWVUSLtG9pH245ofyGsrST5H_5W_EbvOXZ_YkCxmg4DX09_A@mail.gmail.com>
In-Reply-To: <CA+BWVUSLtG9pH245ofyGsrST5H_5W_EbvOXZ_YkCxmg4DX09_A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050309040802090906050803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050309040802090906050803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Since you have only one attribute, it is working for you.
There is a dereference error in *channels.

Check the attached diff, which will fix this.

Thanks,
Srinivas

On 07/09/2014 03:12 PM, Reyad Attiyat wrote:
> Hey Srinivas,
>
> I did look into the panic you sent. I wasn't sure exactly what caused
> the NULL pointer.
> I tested it with out applying the last rotation from north patch, so
> no hid usages are found, my device only has rotation_from_north, and
> hid_parse_report() would return -EINVAL.
> I added another check to make sure a iio channel were set up, and
> return -EINVAL if not, but couldn't think of anything else.
>
> Could you test this version with dynamic debugging and see if it is
> finding any hid usage attributes.
> Any ideas what could cause this? I think I'm handling errors properly
> by returning what parse_report returns (-EINVAL or -ENOMEM) in probe
>
> Thanks,
> Reyad Attiyat
>
> On Wed, Jul 9, 2014 at 2:45 PM, Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
>> On 07/09/2014 12:30 PM, Reyad Attiyat wrote:
>>> This series of patches modifies magn-3d driver to handle the rotation
>>> from north usage. This is done by scanning the report and then building
>>> the iio arrays (vals and channels) dynamically.
>>>
>>> Changes from V4
>>> I use the address field of struct iio_chan_spec to hold the array index
>>> of the usage attribute. The scan_index field is generated when creating
>>> an iio channel.
>>>
>>> Reyad Attiyat (4):
>>>     iio: Documentation: Add documentation for rotation from north sensor
>>>       usage attributes
>>>     iio: types: Added support for rotation from north usage attributes
>>>     iio: hid-sensor-magn-3d: Scan for usage attributes before setting up
>>>       iio channels
>>>     iio: hid-sensor-magn-3d: Add support for rotation from north
>>>
>>>    Documentation/ABI/testing/sysfs-bus-iio       |  82 +++++++++++
>>>    drivers/iio/industrialio-core.c               |   4 +
>>>    drivers/iio/magnetometer/hid-sensor-magn-3d.c | 199
>>> ++++++++++++++++++++------
>>>    include/linux/iio/types.h                     |   4 +
>>>    4 files changed, 245 insertions(+), 44 deletions(-)
>>>
>> Did you get chance to look at the cause of panic?
>>
>> Thanks,
>> Srinivas


--------------050309040802090906050803
Content-Type: text/x-patch;
 name="hid-sensor-magn-3d.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hid-sensor-magn-3d.diff"

diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index 070d20e..63f23af 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -271,6 +271,7 @@ static int magn_3d_parse_report(struct platform_device *pdev,
 	int ret = 0;
 	int i;
 	int attr_count = 0;
+	struct iio_chan_spec *_channels;
 
 	/* Scan for each usage attribute supported */
 	for (i = 0; i < MAGN_3D_CHANNEL_MAX; i++) {
@@ -300,10 +301,10 @@ static int magn_3d_parse_report(struct platform_device *pdev,
 		return  -EINVAL;
 
 	/* Setup IIO channel array */
-	*channels = devm_kcalloc(&pdev->dev, attr_count,
+	_channels = devm_kcalloc(&pdev->dev, attr_count,
 								sizeof(struct iio_chan_spec),
 								GFP_KERNEL);
-	if (!*channels) {
+	if (!_channels) {
 		dev_err(&pdev->dev, "failed to allocate space for iio channels\n");
 		return -ENOMEM;
 	}
@@ -322,14 +323,16 @@ static int magn_3d_parse_report(struct platform_device *pdev,
 	{
 		if (st->magn[i].index >= 0) {
 			/* Setup IIO channel struct */
-			*channels[*chan_count] = magn_3d_channels[i];
+			_channels[*chan_count] = magn_3d_channels[i];
 
 			st->magn_val_addr[i] = &(st->iio_val[*chan_count]);
-			magn_3d_adjust_channel_bit_mask(*channels, *chan_count, st->magn[i].size);
+			magn_3d_adjust_channel_bit_mask(_channels, *chan_count, st->magn[i].size);
 			(*chan_count)++;
 		}
 	}
 
+	*channels = _channels;
+
 	st->scale_precision = hid_sensor_format_scale(
 				HID_USAGE_SENSOR_COMPASS_3D,
 				&st->magn[CHANNEL_SCAN_INDEX_X],

--------------050309040802090906050803--
