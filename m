Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaJFOLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:11:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:39317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbaJFOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396050796"
Message-ID: <5432A474.7000700@intel.com>
Date: Mon, 06 Oct 2014 17:17:24 +0300
From: Daniel Baluta <daniel.baluta@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com
Subject: Re: [RFC PATCH 3/8] iio: core: Introduce new MOTION event
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com> <1412257439-15683-4-git-send-email-daniel.baluta@intel.com> <542FF252.1020206@kernel.org>
In-Reply-To: <542FF252.1020206@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/04/2014 04:12 PM, Jonathan Cameron wrote:
> On 02/10/14 14:43, Daniel Baluta wrote:
>> This is to be used by drivers to signal detection of motion. We also
>> add some possible values for motion as IIO events modifiers:
>> 	* running
>> 	* jogging
>> 	* walking
>> 	* still
>>
>> These values are supported by Frescale's MMA9553 sensor:
>>
>> http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Hmm.. This is the interesting one.
> Not immediately obvious how best to represent this stuff.
>> ---
>>   Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
>>   drivers/iio/industrialio-core.c         | 4 ++++
>>   drivers/iio/industrialio-event.c        | 1 +
>>   include/linux/iio/types.h               | 7 ++++++-
>>   4 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
>> index d760b02..070346d 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -808,6 +808,13 @@ Description:
>>   		number or direction is not specified, applies to all channels of
>>   		this type.
>>
>> +What:		/sys/.../events/in_activity_motion_either_en
>> +KernelVersion:	3.17
>> +Contact:	linux-iio@vger.kernel.org
>> +Description:
>> +		Enables or disables motion detection. Each time motion is detected an
>> +		event of this type will be generated.
>> +
> The either bit seems a bit random but I can see there is no particularly obvious
> alternative.

I wonder if introducing a new IIO_EV_DIR_NONE event direction type would 
make sense. In this case the sysfs attribute will drop event direction 
text from its name (e.g /sys/.../events/in_activity_motion_en)

>
> We really need a clean way of representing a multilevel 'state change' like this.
>
> Looking at the event code, I almost wonder if we would be better using the
> direction element for running, walking etc rather than a modifier.

When pushing events code to userspace the modifier seemed to be the only 
option.

>
> Having said that we will probably also get devices where this is polled rather than
> event.  'What activity is currently going on?'

Adding IIO_EV_INFO_VALUE bit, would create an attribute 
/sys/.../events/in_activity_motion_either_value that could expose the 
current activity going on.

> If we take that view modifiers make sense as it becomes
> 'Is the user running?'  Perhaps even offering a confidence interval, e.g units as
> percentage
> in_activity_running_input 0..100
> in_activity_walking_input 0..100
> etc
>
> Then our event becomes a state change event (yup we'll need to add that)
>
> /events/in_activity_walking_rising_en  will then cause events when the percentage
> confidence on a state rises above the provided threshold or goes above it
> (default of 50% perhaps on devices which only report one state).
>
> /events/in_activity_walking_falling_en will do the leaving case.

This is a very nice idea and it will also offer more flexibility. I am 
not sure about the use case of confidence interval but using 0 and 100 
will do the trick for us.

We will use this interface for implementation of significant motion in 
Android's HAL. [1]

I will experiment more with how IIO attributes work and I will send a v2
using direction instead of modifier for activity type (running, walking 
etc).


>
> Note these are just some quick initial thoughts on alternative methods.
> I'll want to think on this more and get responses from more interested
> parties!

Thanks a lot for your time!

Daniel.

[1] https://source.android.com/devices/sensors/composite_sensors.html
