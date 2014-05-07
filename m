Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbaEGPMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:12:20 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62350 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553AbaEGPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
References: <536982E3.10303@gmail.com>
	<CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
Date: Wed, 7 May 2014 08:12:17 -0700
Message-ID: <CAJAp7OiyjefyPMu2p8jTkbfQWYUKeYV62pVTtJ2JOP-6YOOGKA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] devicetree, qcomm PMIC: fix node name conflict
From: Bjorn Andersson <bjorn@kryo.se>
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 6:32 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, May 6, 2014 at 7:48 PM, Frank Rowand <frowand.list@gmail.com> wrote:
>> An issue with the path of SPMI nodes under /sys/bus/... was reported in
>> https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different
>> grandchild nodes of the spmi with the same node-name@unit-address will
>> result in attempting to create duplicate links at
>> /sys/bus/platform/devices/unit-address.node-name.  It turns out that the
>> specific example provided might not be an expected configuration for
>> current hardware, but the reported trap remains an issue.
>>
>> I have been poking at the problem, trying to figure out how to cleanly
>> fix the issue without breaking devicetree device creation.
>>
>> The first patch in the series is the one that may be a very bad idea.  Or
>> it may help show the way forward to deal with what I think is the major
>> underlying problem.  I have not finished investigating the possible negative
>> side effects.  And I am still thinking whether this is a conceptually good
>> approach, or whether it is simply an expediant hack that hides the underlying
>> problem.  But I am throwing this out prematurely because I have mentioned
>> it to several people, and I want to make it visible to everyone involved.
>>
>> The underlying architectural problem (in my opinion) is that a lot of devices
>> are created by the device tree infrastructure as platform devices, when they
>> truly should not be platform devices.  They should not be platform devices
>> because they are not physically on a platform bus, they are instead somewhere
>> below some other bus.  The first patch in this series is a hack which
>> results in the devices still being represented by "struct platform_device"
>> objects, but with a link to their parent's "struct bus_type" instead of
>> to &platform_bus_type.
>>
>> The second patch does not require the first patch.  The second patch provides
>> a mechanism to allow subsystems to provide a method of naming devices to
>> avoid name collisions.
>>
>> The third patch provides an example of a subsystem using the new feature
>> provided by the second patch.
>>
>
> I think the primary question to ask is there any added benefit to
> having the additional hierarchy of devices. I don't think there is
> much support to have more hierarchy from what I have seen of past
> discussions.
>
> Another approach could be to support having multiple platform bus
> instances. Then drivers can easily create a new instance for each set
> of sub-devices.
>
> This can be solved in a much less invasive way just in the DT naming
> algorithm. This is slightly different from what I had suggested of
> just dropping the unit address. It keeps the unit address, but adds
> the unique index on untranslate-able addresses. The diff is bigger due
> to refactoring to reduce the indentation levels. It is untested and
> whitespace corrupted:

The unique index leads to an interesting dependency between the order
of nodes in the DTB and userspace; paths to e.g. our the path to our
block devices contains soc.X where X changes now and then. Fortunately
soc.X won't change that often, but forcing more peripheral nodes to use
the same schema would show the problem quite often.

Does translatable/untranslatable refer to if this is an address translatable
my the cpu or that it's just a translatable address on this specific bus?
As far as I can see it's the latter and in our case (revid { reg =
<0x100, 0x100>; })
seem to be translatable with the current implementation.

Regards,
Bjorn
