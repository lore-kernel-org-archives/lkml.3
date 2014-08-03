Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaHCQNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:13:34 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38437 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaHCQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <CADYu309eydkp83a1aMybHn5vyLLGBAmFDYeR59RRiC+mGc9w7w@mail.gmail.com>
References: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
	<20140801192300.GB16085@kroah.com>
	<CADYu30_o7rzERKEDe=eZiONp6n1ktMWPydMnXQjDeLrDFQh+vg@mail.gmail.com>
	<20140801224127.GA11596@kroah.com>
	<CADYu309eydkp83a1aMybHn5vyLLGBAmFDYeR59RRiC+mGc9w7w@mail.gmail.com>
Date: Sun, 3 Aug 2014 21:43:30 +0530
Message-ID: <CADYu308x=G4g5A_D3zkjjieGjScE-DhQKZq=yd017rF_AHz9Gg@mail.gmail.com>
Subject: Re: [Question: Drivers/base/core.c] Why dev->init_name = NULL in
 device_add function ?
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Greg KH and Linux Kernel Community,
Greetings of the day ! :)

I need to mark one open linux thread as solved as it is open for a
long time now.
Kindly help in answering my below two queries. :)


On Sat, Aug 2, 2014 at 5:14 AM, Aniroop Mathur <aniroop.mathur@gmail.com> wrote:
> On Sat, Aug 2, 2014 at 4:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sat, Aug 02, 2014 at 03:54:32AM +0530, Aniroop Mathur wrote:
>>> On Sat, Aug 2, 2014 at 12:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> > On Fri, Aug 01, 2014 at 10:43:23PM +0530, Aniroop Mathur wrote:
>>> >> Dear Mr. Greg Kroah-Hartman and Linux Community,
>>> >> Greetings of the day !! :)
>>> >>
>>> >> I am Aniroop Mathur working on Linux Kernel for last two years.
>>> >> I am stuck at one point and could not find the solution over internet.
>>> >> I posted on linuxquestions.org too.
>>> >> So I need your help and suggestion for it.
>>> >>
>>> >> Can you please help in answering my query as below:
>>> >>
>>> >> =====================================================
>>> >> In function device_add of /drivers/base/core.c file, it is mentioned:
>>> >> /*
>>> >> * for statically allocated devices, which should all be converted
>>> >> * some day, we need to initialize the name. We prevent reading back
>>> >> * the name, and force the use of dev_name()
>>> >> */
>>> >> if (dev->init_name) {
>>> >> dev_set_name(dev, "%s", dev->init_name);
>>> >> dev->init_name = NULL;
>>> >> }
>>> >>
>>> >>
>>> >> Except forcing the use of dev_name to read device name,
>>> >> Is there any other reason to make init_name as NULL ?
>>> >
>>> > Why would you want init_name to not be NULL?
>>> >
>>>
>>> Currently in kernel, we cannot set name of event node.
>>
>> What do you mean by "event node"?
>>
>
> I am referring to the device node which HAL/Application uses
> as an interface to interact with kernel for read/write data operation.
> like /dev/input/event0, /dev/input/event1, etc
>
> int fd = open("/dev/input/event0", O_RDONLY);
> int res = read(fd, &input_event, sizeof(input_event));
>
>>> If dev->init_name is not set as NULL in device_add(),
>>> then I can easily set name of event node in evdev_dev.c
>>> file as below:
>>>
>>> if(dev->init_name) {
>>>       sprintf(dev->init_name, "event_%s", dev->init_name);
>>> }
>>> error = device_add(&evdev->dev);
>>>
>>> And in some input device driver code, I will use like below:
>>> dev->init_name = "accelerometer";
>>> input_register_device(dev);
>>
>> What's wrong with:
>>         dev_set_name(dev, "%s", "accelerometer");
>>         input_register_device(dev);
>>
>
> It is good way for setting name of "Input node".
> But it will not set name of "Event node".
>
> input_register_device call sets name of two nodes
> 1. Input node - sys/class/input/input<x>
> 2. Event node - /dev/input/event<x> or sys/class/input/event<x>
>
> Here, input<x> and event<x> are default names set without using
> dev_set_name in driver.
> input<x> - kobject name of struct input_dev;
> event<x> - kobject name of struct evdev;
>
> In input_register_device(dev) function call,
> dev refers to struct input_dev and not struct evdev.
>
> struct input_dev is defined in input.h and
> struct evdev is defined in evdev.c (not a header file).
>
> So driver can use struct input_dev and set its name
> using  dev_set_name(dev, "%s", "accelerometer");
> But struct evdev is not accessible to driver as it is defined in
> evdev.c file. So driver cannot use dev_set_name for evdev.
> It can only be used in evdev.c file.
>
> So above method output will be
> sys/class/input/accelerometer
> /dev/input/event<x> and sys/class/input/event<x>
> (event node name not set)
>
>>> So, overall output will be
>>> /dev/input/event<x> --> /dev/input/event_accelerometer
>>> sys/class/input/input<x> --> sys/class/input/accelerometer
>>>
>>> In short, input and event node names are set just by
>>> adding one line, which i found quite efficient.
>>> There is other way also to set name of event node but
>>> it involves using extra variable and little more code,
>>> So I am looking for best solution possible. :)
>>
>> Only use init_name for static struct devices, for a dynamic one, jsut
>> set the name like everyone else does, how is that "more" code than
>> anything else?
>>
>
> Can you please elaborate what do you mean by static struct devices ?
> Can I consider embedded accelerometer, proximity, gyro sensor,
> touch panel in android mobile devices as static devices ?
>

1. What are statically allocated devices and dynamically allocated devices ?

> Input subsystem is setting default name of input and event node.
> This is the normal method everyone uses.
>
> I do not want to use default name like event0, event4, input2, etc
> My aim is to set name of input and event node through driver as desired.
> So after discussion of other ways to set name through driver,
> we can compare which way is better.
> In one other method, there is a need to add extra variable in
> struct input_dev and hence more memory size.
>
>>> >> And if it is not made NULL, is there any problem or side-effect ?
>>> >
>>> > Yes, people would start to use it thinking it was the real name of the
>>> > device, when it might not be.
>>> >
>>>
>>> As the name itself nicely suggests, it is just a initial name.
>>
>> So please do not use it, someday it will go away...
>>

2. Why init_name field will be removed from struct device someday ?

>> thanks,
>>
>

Thanks,
Aniroop
