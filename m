Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaI0BfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:35:15 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64405 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaI0BfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1409261302520.22196@pobox.suse.cz>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1409261302520.22196@pobox.suse.cz>
Date: Fri, 26 Sep 2014 18:35:11 -0700
Message-ID: <CANRwn3Sng5nxc7YZEUYQVgFhidSMQCBdDsiWebs_zFZ7s=gsiQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] HID: wacom: introduce generic HID handling
From: Jason Gerecke <killertofu@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 4:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 23 Sep 2014, Benjamin Tissoires wrote:
>
>> Hi guys,
>>
>> So, this patch series aims at supporting natively any future HID compliant wacom
>> tablet. Those found on the various laptops (ISDv4/5) already are HID compliant
>> and they should work in the future without any modification of the kernel.
>>
>> Few things to note here:
>> - I used the PID 0x00E6 found on the Lenovo X230 for the tests
>> - I did not removed its entry in the list because there is a slightly different
>>   behavior while using this patch set: when more than two fingers are on the
>>   screen, the tablet stops sending finger events, while with the wacom
>>   proprietary bits, it continues to send them. Besides that, the events emitted
>>   before and after the patch series are the same (at least on the E6)
>> - I can not rely on hid-input directly because wacom wants to be in control of
>>   the input devices it creates. This might be solved in the future, but for now
>>   it is just easier to rewrite the few mapping/events handling than trying to
>>   fit in the hid-input model.
>> - there will still be more specific use cases to handle later (see the joke of
>>   the MS surface 3 pen[1] for instance), but this should give a roughly working
>>   pen/touch support for those future devices.
>>
>> Jason, I would be very glad if you could conduct a few tests for this on the
>> ISDv4/5 sensors you have.
>
> I am waiting with this one for testing results from Jason, but if you guys
> want this to go in the next merge window, I'd like to ask you not to
> postpone the testing too much.
>
> Thanks.
>

I'm in the process of capturing traces from hid-record for multiple
tablet PCs both pre- and post-patch to locate any obvious issues. My
initial results are promising on the pen side (the only things I've
noticed so far is the 2nd barrel switch not being supported -- as
might be suspected) but less so on the touch side (single-finger
devices seem to work fine, but the new code doesn't seem to handle any
of the multitouch devices I've tried).

Expect more news next week :)


PS: I'm pretty sure ISDv5 shouldn't be relied on for HID data :| The
descriptor for the Cintiq Companion Hybrid, at least, is like our
branded sensors with useful data only in the touchscreen descriptor
(the pen descriptor is a bunch of opaque vendor-defined reports). Not
sure if the Cintiq Companion is the same though since it runs
Windows...

Jason
---
Now instead of four in the eights place /
you’ve got three, ‘Cause you added one  /
(That is to say, eight) to the two,     /
But you can’t take seven from three,    /
So you look at the sixty-fours....

>>
>> Cheers,
>> Benjamin
>>
>> [1] http://who-t.blogspot.com/2014/09/stylus-behaviour-on-microsoft-surface-3.html
>>
>> Benjamin Tissoires (5):
>>   HID: wacom: rename failN with some meaningful information
>>   HID: wacom: split out input allocation and registration
>>   HID: wacom: move allocation of inputs earlier
>>   HID: wacom: implement generic HID handling for pen generic devices
>>   HID: wacom: implement the finger part of the HID generic handling
>>
>>  drivers/hid/hid-core.c  |   3 +
>>  drivers/hid/wacom.h     |   6 +
>>  drivers/hid/wacom_sys.c | 184 +++++++++++++++++++++--------
>>  drivers/hid/wacom_wac.c | 299 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/hid/wacom_wac.h |  17 +++
>>  include/linux/hid.h     |   2 +
>>  6 files changed, 462 insertions(+), 49 deletions(-)
>>
>> --
>> 2.1.0
>>
>
> --
> Jiri Kosina
> SUSE Labs
