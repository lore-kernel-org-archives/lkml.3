Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaJJXqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:46:49 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50149 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaJJXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:46:46 -0400
Message-ID: <5436E3E1.3050306@kernel.org>
Date: Thu, 09 Oct 2014 20:37:05 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        irina.tirdea@intel.com
Subject: Re: [RFC PATCH 3/8] iio: core: Introduce new MOTION event
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>	<1412257439-15683-4-git-send-email-daniel.baluta@intel.com>	<542FF252.1020206@kernel.org> <CAEnQRZDP84sdnO4mnS2CtCdy7WzBMhMfuNrMM=rkR0ty7b-1Rw@mail.gmail.com>
In-Reply-To: <CAEnQRZDP84sdnO4mnS2CtCdy7WzBMhMfuNrMM=rkR0ty7b-1Rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 11:48, Daniel Baluta wrote:
> On Sat, Oct 4, 2014 at 4:12 PM, Jonathan Cameron <jic23@kernel.org> wrote:
>> On 02/10/14 14:43, Daniel Baluta wrote:
>>> This is to be used by drivers to signal detection of motion. We also
>>> add some possible values for motion as IIO events modifiers:
>>>       * running
>>>       * jogging
>>>       * walking
>>>       * still
>>>
>>> These values are supported by Frescale's MMA9553 sensor:
>>>
>>> http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf
>>>
>>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>> Hmm.. This is the interesting one.
>> Not immediately obvious how best to represent this stuff.
>>> ---
>>>  Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
>>>  drivers/iio/industrialio-core.c         | 4 ++++
>>>  drivers/iio/industrialio-event.c        | 1 +
>>>  include/linux/iio/types.h               | 7 ++++++-
>>>  4 files changed, 18 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
>>> index d760b02..070346d 100644
>>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>>> @@ -808,6 +808,13 @@ Description:
>>>               number or direction is not specified, applies to all channels of
>>>               this type.
>>>
>>> +What:                /sys/.../events/in_activity_motion_either_en
>>> +KernelVersion:       3.17
>>> +Contact:     linux-iio@vger.kernel.org
>>> +Description:
>>> +             Enables or disables motion detection. Each time motion is detected an
>>> +             event of this type will be generated.
>>> +
>> The either bit seems a bit random but I can see there is no particularly obvious
>> alternative.
>>
>> We really need a clean way of representing a multilevel 'state change' like this.
>>
>> Looking at the event code, I almost wonder if we would be better using the
>> direction element for running, walking etc rather than a modifier.
>>
>> Having said that we will probably also get devices where this is polled rather than
>> event.  'What activity is currently going on?'
>> If we take that view modifiers make sense as it becomes
>> 'Is the user running?'  Perhaps even offering a confidence interval, e.g units as
>> percentage
>> in_activity_running_input 0..100
>> in_activity_walking_input 0..100
>> etc
>>
> 
> This is clear.
> 
>> Then our event becomes a state change event (yup we'll need to add that)
> 
> So this means we will have a single event type named "state_change"?
> Or better "transition".
I was being rather incoherent here.  I think we are mostly covered
simple rising type events for the confidence interval measurements for
each of the activity_running, activity_walking etc 'modified channels'
we have above.

Don't need a state change.  If we actually have a device that interrupts on
simply the event has change, then the event handling will need to check what
the new state is and fire the relevant event.
> 
>>
>> /events/in_activity_walking_rising_en  will then cause events when the percentage
>> confidence on a state rises above the provided threshold or goes above it
>> (default of 50% perhaps on devices which only report one state).
> 
> Then here the attribute name will be:
> /events/in_activity_state_change_walking_rising_en
> 
> or if we call the event type "transition" this will be:
> /events/in_activity_transition_walking_rising_en
> 
> I am a little bit confused :).
I confused myself as well.

we should end up with
/events/in_activity_walking_rising_en
/events/in_activity_running_rising_en
/events/in_activity_hopping_rising_en
(I'll stop there before things get silly)

Each of which claims to based on the confidence level of that state, even if that
only ever takes values of 0 and 100%
> 
>>
>> /events/in_activity_walking_falling_en will do the leaving case.
>>
>> Note these are just some quick initial thoughts on alternative methods.
>> I'll want to think on this more and get responses from more interested
>> parties!
>>
>>>  What:                /sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
>>>  KernelVersion:       2.6.35
>>>  Contact:     linux-iio@vger.kernel.org
>>> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
>>> index 67e8561..e453ef9 100644
>>> --- a/drivers/iio/industrialio-core.c
>>> +++ b/drivers/iio/industrialio-core.c
>>> @@ -92,6 +92,10 @@ static const char * const iio_modifier_names[] = {
>>>       [IIO_MOD_NORTH_TRUE] = "from_north_true",
>>>       [IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
>>>       [IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
>>> +     [IIO_MOD_RUNNING] = "running",
>>> +     [IIO_MOD_JOGGING] = "jogging",
>>> +     [IIO_MOD_WALKING] = "walking",
>>> +     [IIO_MOD_STILL] = "still",
>>>  };
>>>
>>>  /* relies on pairs of these shared then separate */
>>> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
>>> index 0c1e37e..eca5af2 100644
>>> --- a/drivers/iio/industrialio-event.c
>>> +++ b/drivers/iio/industrialio-event.c
>>> @@ -197,6 +197,7 @@ static const char * const iio_ev_type_text[] = {
>>>       [IIO_EV_TYPE_ROC] = "roc",
>>>       [IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>>>       [IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
>>> +     [IIO_EV_TYPE_MOTION] = "motion",
>>>  };
>>>
>>>  static const char * const iio_ev_dir_text[] = {
>>> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>>> index d58769a..003638d 100644
>>> --- a/include/linux/iio/types.h
>>> +++ b/include/linux/iio/types.h
>>> @@ -60,7 +60,11 @@ enum iio_modifier {
>>>       IIO_MOD_NORTH_MAGN,
>>>       IIO_MOD_NORTH_TRUE,
>>>       IIO_MOD_NORTH_MAGN_TILT_COMP,
>>> -     IIO_MOD_NORTH_TRUE_TILT_COMP
>>> +     IIO_MOD_NORTH_TRUE_TILT_COMP,
>>> +     IIO_MOD_RUNNING,
>>> +     IIO_MOD_JOGGING,
>>> +     IIO_MOD_WALKING,
>>> +     IIO_MOD_STILL,
>>>  };
>>>
>>>  enum iio_event_type {
>>> @@ -69,6 +73,7 @@ enum iio_event_type {
>>>       IIO_EV_TYPE_ROC,
>>>       IIO_EV_TYPE_THRESH_ADAPTIVE,
>>>       IIO_EV_TYPE_MAG_ADAPTIVE,
>>> +     IIO_EV_TYPE_MOTION,
>>>  };
>>>
>>>  enum iio_event_info {
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
