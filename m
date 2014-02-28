Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaB1WcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:32:24 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47324 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaB1WcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:32:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv34UB52FCDQGMWWgsdHH8ksTLmTg0iWQcC+dUbhk5nwuoQ@mail.gmail.com>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
	<1393375569-21751-2-git-send-email-sre@debian.org>
	<CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
	<20140226215452.GA11468@earth.universe>
	<CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
	<20140228020536.GB5427@earth.universe>
	<CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
	<20140228210857.GA17467@earth.universe>
	<CAAfyv34UB52FCDQGMWWgsdHH8ksTLmTg0iWQcC+dUbhk5nwuoQ@mail.gmail.com>
Date: Fri, 28 Feb 2014 23:32:22 +0100
Message-ID: <CAAfyv36RPCkUKLOC6yHRwaNjA16EeG_niyfZoaJ15LZ5_HdR7g@mail.gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:13 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> On Fri, Feb 28, 2014 at 10:08 PM, Sebastian Reichel <sre@debian.org> wrote:
>> On Fri, Feb 28, 2014 at 09:32:12PM +0100, Belisko Marek wrote:
>>> On Fri, Feb 28, 2014 at 3:05 AM, Sebastian Reichel <sre@debian.org> wrote:
>>> > On Thu, Feb 27, 2014 at 10:34:35PM +0100, Belisko Marek wrote:
>>> >> Well I've tried and it's worse :). I got during booting:
>>> >> [    2.218383] ERROR: could not get IIO channel /battery:temp(0)
>>> >> [    2.224639] platform battery.4: Driver twl4030_madc_battery
>>> >> requests probe deferral
>>> >> Not sure if it's just error or warning but temp is always reported as
>>> >> 0 (and also other values in sysfs).
>>> >
>>> > This is an error, which basically means, that twl4030-madc has not
>>> > yet been loaded. Do you get proper values when you use the old madc
>>> > API with the patchset applied?
>>>
>>> It works without converting to iio consumer (at least I get some
>>> reasonable values).  With conversion it fails with above error. I
>>> recheck (add printk to iio twl4030-madc) that madc driver is
>>> loaded. Could this be that twl4030_madc_battery is loaded earlier
>>> then twl4030_madc and than it fails to get iio channels?
>>
>> The error above implies, that twl4030-madc has not been loaded when
>> twl4030-madc-battery was loaded. This iio_channel_get() fails and
>> returns -EPROBE_DEFER. This results in twl4030-madc-battery probe
>> function returning -EPROBE_DEFER. Thus you can simply ignore the
>> error if the twl4030-madc-battery driver is loaded later.
>>
>> I guess the easiest way to debug the problem is adding some
>> dev_dbg() at the start of twl4030_madc_conversion(), which
>> prints out the entries of twl4030_madc_request. Currently
>> the IIO API simply calls twl4030_madc_request(), so you
>> should be able to find out the difference.
> OK I'll try to debug it deeper.
Seems I found issue. I have missing property ti,system-uses-second-madc-irq
as original twl4030_madc_battery used SW2 but this change doesn't fix completely
the problem. What it fixed completely is change:
-       req.raw = !(mask == IIO_CHAN_INFO_PROCESSED);
+       req.raw = 0;//!(mask == IIO_CHAN_INFO_PROCESSED);

>>
>> Also: Can you post you DTS? I use the following for Nokia N900:
>>
>> / {
>>         battery: n900-battery {
>>                 compatible = "nokia,n900-battery";
>>                 io-channels = <&twl_madc 0>, <&twl_madc 4>, <&twl_madc 12>;
>>                 io-channel-names = "temp", "bsi", "vbat";
>>         };
>> };
>>
>> &twl {
>>         twl_madc: madc {
>>                 compatible = "ti,twl4030-madc";
>>                 interrupts = <3>;
>>                 #io-channel-cells = <1>;
>>         };
>> };
> I put twl_madc property to twl4030.dtsi as following:
> twl_madc: madc {
> compatible = "ti,twl4030-madc";
> interrupts = <3>;
> #io-channel-cells = <1>;
> };
>
> and node for battery is:
> battery {
> compatible = "ti,twl4030-madc-battery";
> capacity = <1200000>;
> charging-calibration-data = <4200 100
>     4100 75
>     4000 55
>     3900 25
>     3800 5
>     3700 2
>     3600 1
>     3300 0>;
> discharging-calibration-data = <4200 100
> 4100 95
> 4000 70
> 3800 50
> 3700 10
> 3600 5
> 3300 0>;
> io-channels = <&twl_madc 1>,
>                      <&twl_madc 10>,
>      <&twl_madc 12>;
> io-channel-names = "temp",
>                   "ichg",
>                   "vbat";
> };
>>
>> -- Sebastian
>
> BR,
>
> marek
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
