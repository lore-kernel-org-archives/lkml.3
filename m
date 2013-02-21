Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3BUIyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:54:15 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41048 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3BUIyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:54:13 -0500
Message-ID: <5125E0AE.302@kernel.org>
Date: Thu, 21 Feb 2013 08:54:06 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Rob Herring <robherring2@gmail.com>, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        devicetree-discuss@lists.ozlabs.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: Re: [PATCH v5] iio: Add OF support
References: <1360256940-19438-1-git-send-email-linux@roeck-us.net> <51250A0E.80806@gmail.com> <20130220181148.GA19278@roeck-us.net> <2dada206-6401-4a35-85d8-298dd08b0420@email.android.com> <20130220192458.GA29247@roeck-us.net>
In-Reply-To: <20130220192458.GA29247@roeck-us.net>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 07:24 PM, Guenter Roeck wrote:
> On Wed, Feb 20, 2013 at 06:51:08PM +0000, Jonathan Cameron wrote:
>>
>>
>> Guenter Roeck <linux@roeck-us.net> wrote:
>>
>>> On Wed, Feb 20, 2013 at 11:38:22AM -0600, Rob Herring wrote:
>>>> On 02/07/2013 11:09 AM, Guenter Roeck wrote:
>>>>> Provide bindings and parse OF data during initialization.
>>>>>
>>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>>> ---
>>>>> v5:
>>>>> - Updated examples in bindings.
>>>>> v4:
>>>>> - Fixed wrong parameter to dummy of_iio_channel_get_by_name if
>>> CONFIG_OF is
>>>>>   undefined, and wrong return value.
>>>>> - Initialize indio_dev->of_node in iio_device_register if the
>>> calling driver
>>>>>   neglected to do it.
>>>>> v3:
>>>>> - Cleaned up documentation (formatting, left-over clock references)
>>>>> - Updated bindings description to permit sub-devices
>>>>> - When searching for iio devices, use the pointer to the iio device
>>> type instead
>>>>>   of strcmp. Rename iio_dev_type to iio_device_type (to match other
>>> device
>>>>>   types) and make it global for that purpose. Check the OF node
>>> first, then the
>>>>>   device type, as the node is less likely to match.
>>>>> - Move the common code in of_iio_channel_get and
>>> of_iio_channel_get_all to
>>>>>   __of_iio_channel_get.
>>>>> - Return NULL from of_iio_channel_get_by_name if nothing is found,
>>> or
>>>>>   an error if there is a problem with consistency or if the
>>> provider device is
>>>>>   not yet available.
>>>>> - In iio_channel_get, return if of_iio_channel_get_by_name()
>>> returns a channel
>>>>>   or an error, and continue otherwise.
>>>>> v2:
>>>>> - Rebased to iio/togreg
>>>>> - Documentation update per feedback
>>>>> - Dropped io-channel-output-names from the bindings document. The
>>> property is
>>>>>   not used in the code, and it is not entirely clear what it would
>>> be used for.
>>>>>   If there is a need for it, we can add it back in later on.
>>>>> - Don't export OF specific API calls
>>>>> - For OF support, no longer depend on iio_map
>>>>> - Add #ifdef CONFIG_OF where appropriate, and ensure that the code
>>> still builds
>>>>>   if it is not selected.
>>>>> - Change iio_channel_get to take device pointer as argument instead
>>> of device
>>>>>   name. Retain old API as of_iio_channel_get_sys.
>>>>> - iio_channel_get now works for both OF and non-OF configurations
>>>>> - Use regulator to get vref for max1363 driver.
>>>>>
>>>>>  .../devicetree/bindings/iio/iio-bindings.txt       |   97
>>> +++++++++++
>>>>>  drivers/iio/iio_core.h                             |    1 +
>>>>>  drivers/iio/industrialio-core.c                    |    8 +-
>>>>>  drivers/iio/inkern.c                               |  171
>>> ++++++++++++++++++++
>>>>>  4 files changed, 275 insertions(+), 2 deletions(-)
>>>>>  create mode 100644
>>> Documentation/devicetree/bindings/iio/iio-bindings.txt
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/iio/iio-bindings.txt
>>> b/Documentation/devicetree/bindings/iio/iio-bindings.txt
>>>>> new file mode 100644
>>>>> index 0000000..1182845
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/iio/iio-bindings.txt
>>>>> @@ -0,0 +1,97 @@
>>>>> +This binding is a work-in-progress. It is derived from clock
>>> bindings,
>>>>> +and based on suggestions from Lars-Peter Clausen [1].
>>>>
>>>> Bindings are an ABI. It should not be a WIP. What part is a WIP?
>>>>
>>> The text is copied from clock bindings. I do not claim to be better
>>> than the clock subsystem is doing in respect to its bindings.
>>>
>>> I'll be more than happy to take this text out if it is a source of
>>> contention,
>>> even more so if that is what is holding up the patch. Jonathan ?
>> I don't really care about the wording though can see why Rob asked!
>> We will probably have other stuff to add anyway.
>>
> 
> Quite likely - for example, I did not add io-output-names since I did not
> know what to do with it.
> 
> What do you want me to do ? Submit another version with the sentence deleted,
> or keep it as-is ?
Keep as is.  Thanks,

Jonathan
