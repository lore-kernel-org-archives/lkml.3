Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3HMTPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:15:07 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:39928 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab3HMTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <520A7CDF.3070808@ahsoftware.de>
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
	<1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com>
	<520A7CDF.3070808@ahsoftware.de>
Date: Tue, 13 Aug 2013 21:15:01 +0200
Message-ID: <CAN+gG=EkGToAGatxqywBatJOjcWUF6=u1SZ86vVmUPnujJMJvw@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: Use existing parser for pre-scanning the report descriptors
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 8:37 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 13.08.2013 16:58, schrieb Benjamin Tissoires:
>
>> hid_scan_report() implements its own HID report descriptor parsing. It was
>> fine until we added the SENSOR_HUB detection. It is going to be even worse
>> with the detection of Win 8 certified touchscreen, as this detection
>> relies on a special feature and on the report_size and report_count
>> fields.
>
>
> Sorry, but I can't agree with your wording here.
>
> If you look at the if expression I've added to support HID sensor hubs, you
> will notice that the first expression was a test for the usage page of
> sensor hubs. That wasn't the first test by accident, instead I've choosen
> the order of those 4 tests very carefully to make the impact on the existing
> parsing of other HID devices very small. So it might not have be pleasing to
> your eyes, but it was for sure an appropriate solution.

I'm sorry if you feel like it was a personal attack. I'm sure the
upstream code is working good and that there is no extra tests and
that you implemented it that way without proper testing and
validating. What I meant was that the initial code was not exactly
meant to address the particular problem of sensor hub (at that time,
we only needed to check for one input report). However, I need now to
add a test against a feature report, which would need a new custom
detection, and a heavy modification of the existing code.

>
> Anyway, I've tested your patch 1/3 on top of 3.11-rc5 here and the detection
> of sensor hubs doesn't work anymore with your patch applied. Up to now I
> only had a quick look at it, but it looks like the test in
> hid_scan_open_collection() isn't hit for my device.

oops, this is not intentional. I'll try to fix this in v2.

>
> Another problem is that I don't have any commercial sensor hub and I'm
> therefor not a very relvant as tester (I've implemented the firmware for my
> HID (sensor hub) device too). Therefor I've added Srinivas Pandruvada to cc,
> because he's the only one I know who has HID sensor hubs.

It is not a problem if you don't have a commercial sensor hub :)
Thanks for adding Srinivas in CC.

>
> And, as said, I've implemented the other side here too, therefor I've added
> the descriptor I'm using below.
>

Thanks, this will help me to test against your report descriptors.
Can I also ask you to send me some hid-recorder[1] traces of your
sensor? With hid-replay, I can then re-inject them in the hid
subsystem, and then I include the results in a regression test suite.

Cheers,
Benjamin

[1] http://bentiss.github.io/hid-replay-docs/

>
> --my-descriptor--
>         0x05, 0x20, // HID_USAGE_PAGE_SENSOR
>         0xa1, 0x01, // COLLECTION (Application)
>                 0x09, 0xa0, // HID_USAGE_SENSOR_CATEGORY_TIME
>                 0xa1, 0x00, // COLLECTION (Physical)
> #ifndef USE_FULL_YEAR
>                         0x75, 0x08, // REPORT_SIZE (8 bits)
> #endif
>                         0x95, 0x01, // REPORT_COUNT (1)
>                         0x85, HID_REPORT_ID_TIME, // REPORT_ID
>
>                         0x0a, 0x21, 0x05, // USAGE (Year)
> #ifdef USE_FULL_YEAR
>                         0x75, 0x10, // REPORT_SIZE (16 bits)
> #else
>                         0x15, 0x00, // LOGICAL_MINIMUM (0) (Range is
> currently not specified in HUTRR39)
>                         0x25, 0x63, // LOGICAL_MAXIMUM (99)
> #endif
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x22, 0x05, // USAGE (Month)
> #ifdef USE_FULL_YEAR
>                         0x75, 0x08, // REPORT_SIZE (8 bits)
> #endif
>                         0x15, 0x01, // LOGICAL_MINIMUM (1)
>                         0x25, 0x0c, // LOGICAL_MAXIMUM (12)
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x23, 0x05, // USAGE (Day)
>                         0x15, 0x01, // LOGICAL_MINIMUM (1)
>                         0x25, 0x1f, // LOGICAL_MAXIMUM (31)
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x24, 0x05, // USAGE (Day of Week)
>                         0x15, 0x00, // LOGICAL_MINIMUM (0)
>                         0x25, 0x06, // LOGICAL_MAXIMUM (6)
>                         0xa1, 0x02, // COLLECTION (Logical)
>                                 0x0a, 0xc0, 0x08, // Day of Week: Sunday
>                                 0x0a, 0xc1, 0x08, // Day of Week: Monday
>                                 0x0a, 0xc2, 0x08, // Day of Week: Tuesday
>                                 0x0a, 0xc3, 0x08, // Day of Week: Wednesday
>                                 0x0a, 0xc4, 0x08, // Day of Week: Thursday
>                                 0x0a, 0xc5, 0x08, // Day of Week: Friday
>                                 0x0a, 0xc6, 0x08, // Day of Week: Saturday
>                                 0x81, 0x02, // INPUT (Const,Arr,Abs)
>                         0xc0, // END_COLLECTION
>
>                         0x0a, 0x25, 0x05, // USAGE (Hour)
>                         0x15, 0x00, // LOGICAL_MINIMUM (0)
>                         0x25, 0x17, // LOGICAL_MAXIMUM (23)
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x26, 0x05, // USAGE (Minute)
>                         0x15, 0x00, // LOGICAL_MINIMUM (0)
>                         0x25, 0x3b, // LOGICAL_MAXIMUM (59)
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x27, 0x05, // USAGE (Second)
>                         0x15, 0x00, // LOGICAL_MINIMUM (0)
>                         0x25, 0x3b, // LOGICAL_MAXIMUM (59)
>                         0x65, 0x00, // UNIT (None)
>                         //0x66, 0x10, 0x01, // UNIT (second)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                         0x0a, 0x28, 0x05, // USAGE (Millisecond)
>                         0x75, 0x10, // REPORT_SIZE (16 bits)
>                         0x65, 0x00, // UNIT (None)
>                         0x81, 0x02, // INPUT (Data,Var,Abs)
>
>                 0xc0, // END_COLLECTION
>         0xc0, // END_COLLECTION
> --my-descriptor--
>
>
