Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaHVLl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:41:58 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63942 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaHVLl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4SJZQeAuXhggdnsjRFKFJD01WEnBpcdPC1pkJiv3WegCA@mail.gmail.com>
References: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com>
	<1408706963-23195-1-git-send-email-sudeep.holla@arm.com>
	<CANq1E4SJZQeAuXhggdnsjRFKFJD01WEnBpcdPC1pkJiv3WegCA@mail.gmail.com>
Date: Fri, 22 Aug 2014 13:41:56 +0200
Message-ID: <CANq1E4Snx_n3XDWXU5PtmLtt31sRqnkKrSRsx2_b=i+6GTLnxw@mail.gmail.com>
Subject: Re: [PATCH] drivers: base: add cpu_device_create to support per-cpu devices
From: David Herrmann <dh.herrmann@gmail.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Aug 22, 2014 at 1:37 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Fri, Aug 22, 2014 at 1:29 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch adds a new function to create per-cpu devices.
>> This helps in:
>> 1. reusing the device infrastructure to create any cpu related
>>    attributes and corresponding sysfs instead of creating and
>>    dealing with raw kobjects directly
>> 2. retaining the legacy path(/sys/devices/system/cpu/..) to support
>>    existing sysfs ABI
>> 3. avoiding to create links in the bus directory pointing to the
>>    device as there would be per-cpu instance of these devices with
>>    the same name since dev->bus is not populated to cpu_sysbus on
>>    purpose
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/base/cpu.c  | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/cpu.h |  4 ++++
>>  2 files changed, 58 insertions(+)
>>
>> Hi Greg,
>>
>> Here is the alternate solution I could come up with instead of
>> creating cpu class. cpu_device_create is very similar to
>> device_create_groups_vargs w/o class support, but I could not
>> reuse anything else to avoid creating similar function.
>>
>> Let me know your thoughts/suggestions on this.
>>
>> Regards,
>> Sudeep
>>
>>
>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 277a9cfa9040..53f0c4141d05 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -363,6 +363,60 @@ struct device *get_cpu_device(unsigned cpu)
>>  }
>>  EXPORT_SYMBOL_GPL(get_cpu_device);
>>
>> +static void device_create_release(struct device *dev)
>> +{
>> +       kfree(dev);
>> +}
>> +
>> +static struct device *
>> +__cpu_device_create(struct device *parent, void *drvdata,
>> +                   const struct attribute_group **groups,
>> +                   const char *fmt, va_list args)
>> +{
>> +       struct device *dev = NULL;
>> +       int retval = -ENODEV;
>> +
>> +       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>> +       if (!dev) {
>> +               retval = -ENOMEM;
>> +               goto error;
>> +       }
>> +
>> +       device_initialize(dev);
>> +       dev->parent = parent;
>> +       dev->groups = groups;
>> +       dev->release = device_create_release;
>> +       dev_set_drvdata(dev, drvdata);
>> +
>> +       retval = kobject_set_name_vargs(&dev->kobj, fmt, args);
>> +       if (retval)
>> +               goto error;
>> +
>> +       retval = device_add(dev);
>> +       if (retval)
>> +               goto error;
>
> Exactly! As I said, simply setting dev->groups before calling device_add().
>
> However, I really don't understand why we need this as global API.
> Skimming over the other patches, you use cpu_device_create() only in
> one place. Why not hard-code this all there? It is totally OK to do
> device initialization in drivers. All the helpers (like
> device_create(), device_create_with_groups(), and so on) are just
> convenience functions. The driver-core API explicitly allows drivers
> to initialize devices manually.
>
> Nevertheless, this patch looks fine.

Wait, no. Why don't you set dev->bus to cpu_subsys? Is this thing
supposed to create child-devices of CPUs? Can you describe what your
topology is supposed to look like?

Thanks
David
