Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaEXKhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 06:37:24 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:32915 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaEXKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 06:37:23 -0400
Message-ID: <538076CA.6050809@kernel.org>
Date: Sat, 24 May 2014 11:39:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: HID Sensor support for True/Magnetic North usage attributes
References: <CA+BWVUShz2_Xd8EBWE+igjYk6Bc+K=LbjCr6EH7hNhvVodka6A@mail.gmail.com> <53764EDE.8090008@linux.intel.com>
In-Reply-To: <53764EDE.8090008@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/14 18:46, Srinivas Pandruvada wrote:
> On 05/13/2014 07:14 PM, Reyad Attiyat wrote:
>> Dear IIO/HID maintainers,
>>
>> I have a device, Surface Pro, that has the hid-sensor-hub and many
>> sensors attached. With the help of Srinivas I was able to get them all
>> working except for the magnometer. It uses the hid-magn-3d driver as
>> it should but it does not contain an axis (X, Y, Z) usage attributes.
>> Instead it only has a True North usage attribute. I see two solutions
>> to this problem and was inquiring which one would work best?
>>
>> 1) Modify the hid-magn-3d driver to handle True North attribute. I
>> realize there might not be many devices that have this so not sure if
>> appropriate. I think this could be done; by passing a variable amount
>> of IIO Channels when setting up the hid-magn-3d driver, depending on
>> how many axis and/or if it find True/Magnetic North usage attribute.
> I prefer this approach. The spec doesn't say whether magnetic flux for x,y or z are mandatory.
> Ultimately they are used to calculate the true north. So if the hub is trying to expose true north,
> we should add this attribute.
>
> "Heading True North SV – Indicates compass true north heading is not compensated.
>                      Default unit of measure is degrees; can be overridden using
>                     explicit Unit and/or Unit Exponent."
>
Agreed. Don't worry too much about the driver naming.  Plenty of convention
says that it has no real meaning other than labelling one part supported by
the driver.

> Thanks,
> Srinivas
>> 2) Create a whole new driver that handles True/Magnetic North. This
>> would not work on my device as it is set to Compass 3D Usage
>> Attribute. This could be resolved by adding another quirk for the
>> Surface to ensure it used the new driver.
No to this one as we'll end up with lots of similar cases and far too many
similar drivers.
>>
>> For both options I think we'd need a new IIO_MOD_NORTH for the
>> iio_chan_spec, as the current ones don't really apply. I like the
>> first solution as it could allow for handling of devices with only one
>> or two axis present. I do realize if the hid-mangn-3d driver was
>> changed it's name would not make sense anymore and the pattern I'm
>> notcing is a driver for each HID Usage.
If you are introducing a north attribute, allow for both true and magnetic
norths (only introduce the one you are using).

IIO_MOD_NORTH_TRUE
IIO_MOD_NORTH_MAGNETIC perhaps?
I see the spec also mentions compensated variants of these...   If you do
include these I think
IIO_MOD_NORTH_TRUE_TILT_COMPENSATED or similar would be needed to make it
clear what was going on.
>>
>> Here's a link to the hid report description with some labels for my device:
>> Bug 73321 Comment 7
>> https://bugzilla.kernel.org/show_bug.cgi?id=73321#c7
>>
>> I'd be willing to work on this. Just wanted to know what would work best
>>
Cool. I'd suggest perhaps doing the documentation first for the new ABI elements
then we can hammer that out in parallel with work on the driver.
(it's usually the harder part!)
>> Thank You,
>> Reyad Attiyat
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

