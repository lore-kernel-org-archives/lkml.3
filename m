Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3J2XRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:17:35 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42662 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3J2XRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:17:34 -0400
MIME-Version: 1.0
In-Reply-To: <201310252021.51846@pali>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com>
 <201310251838.32001@pali> <CAK5ve-JrQhpwx9ZG1Kyhuxdc=dqfAaA6YBOMkDWYWrefeoeUxw@mail.gmail.com>
 <201310252021.51846@pali>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 29 Oct 2013 16:17:11 -0700
Message-ID: <CAK5ve-JN=xkaiYJU7f-4Kt5edxNU7_L8UMUBEtwXv9p2yPp7qw@mail.gmail.com>
Subject: Re: [PATCH 00/10] leds: lp5521,5523: restore device attributes for
 running LED patterns
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Milo Kim <woogyom.kim@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:21 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Friday 25 October 2013 19:10:07 Bryan Wu wrote:
>> On Fri, Oct 25, 2013 at 9:38 AM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > On Tuesday 13 August 2013 23:04:14 Bryan Wu wrote:
>> >> On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim
> <woogyom.kim@gmail.com> wrote:
>> >> > This patch-set resolves the application conflict by
>> >> > restoring sysfs files.
>> >> >
>> >> > For LP5521
>> >> >
>> >> >   engine1/2/3_mode
>> >> >   engine1/2/3_load
>> >> >
>> >> > For LP5523
>> >> >
>> >> >   engine1/2/3_mode
>> >> >   engine1/2/3_load
>> >> >   engine1/2/3_leds
>> >> >
>> >> > Those attributes are accessed when LED pattern is run by
>> >> > custom application. Those were removed when LED pattern
>> >> > interface was changed to generic firmware interface.
>> >> > Please refer to commits below.
>> >> >
>> >> >   git commit 9ce7cb170f97f83a78dc948bf7d25690f15e1328
>> >> >   (leds-lp5521: use generic firmware interface)
>> >> >
>> >> >   git commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
>> >> >   (leds-lp5523: use generic firmware interface)
>> >> >
>> >> > Necessary attributes are restored in this patch-set.
>> >> >
>> >> > (Other changes)
>> >> > New data structure is added for handling values from/to
>> >> > an application. Few code fixes for reducing writing I2C
>> >> > commands.
>> >> > Add LP55xx common macros for code refactoring.
>> >> > Documentation updates.
>> >> >
>> >> > You can also pull from the location below
>> >> > This branch is based on 'for-next' of linux-leds.
>> >> >
>> >> >   https://github.com/milokim/lp55xx.git
>> >> >   resolve-missing-sysfs
>> >>
>> >> Thanks, I've already merged the whole patchset in my -devel
>> >> branch [1].
>> >>
>> >> Pali, could you please help to test it on your hardware?
>> >> Just grab my -devel branch and build then run.
>> >>
>> >> Thanks,
>> >> -Bryan
>> >
>> > Hi, I see that all your patches are part of 3.12-rc5 kernel.
>> >
>> > Now I tested this example led program:
>> >     # Clearing LED-state to be sure
>> >     echo "disabled" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>> >     "disabled" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo 0
>> >     > /sys/class/leds/lp5523:r/brightness
>> >     echo 0 > /sys/class/leds/lp5523:g/brightness
>> >     echo 0 > /sys/class/leds/lp5523:b/brightness
>> >
>> >     # Setting yellow light pattern and running it
>> >     echo "load" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>> >     "000001100" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_leds echo
>> >     "9d804000427f0d7f7f007f0042000000" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_load echo
>> >     "load" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
>> >     "000000000" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_leds echo
>> >     "9d800000" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_load echo
>> >     "run" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine2_mode echo
>> >     "run" >
>> >     /sys/class/i2c-adapter/i2c-2/2-0032/engine1_mode echo
>> >     20 > /sys/class/leds/lp5523:r/led_current
>> >     echo 2 > /sys/class/leds/lp5523:g/led_current
>> >     echo 0 > /sys/class/leds/lp5523:b/led_current
>> >
>> > All sysfs entries exists and every echo returned 0.
>> >
>> > But led does not start blinking that yellow ligh pattern.
>> > So it not working on 3.12-rc5 kernel :-(
>>
>> OK, great! Do you still remember which kernel version works on
>> you system? Milo, do you have time to take a look? I bet it's
>> a regression somewhere.
>>
>> Thanks,
>> -Bryan
>
> I do not know which version. Now I tried pattern example from
> Documentation/leds/leds-lp55xx.txt which using new API.
>
> echo 2 > /sys/class/i2c-adapter/i2c-2/2-0032/select_engine
> echo 1 > /sys/class/firmware/lp5523/loading
> echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
> echo 0 > /sys/class/firmware/lp5523/loading
> echo 1 > /sys/class/i2c-adapter/i2c-2/2-0032/run_engine
>
> But it failed at second command. In directory /sys/class/firmware/
> I have only one file with name timeout. Nothing more, no lp5523
> folder.
>
> Any idea who and when creating that lp5523 folder?

Milo,

Do you have time to take a look at this?

Thanks,
-Bryan
