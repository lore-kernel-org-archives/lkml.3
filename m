Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaETM1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:27:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48875 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaETM1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:27:08 -0400
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20140520055026.E3A98C412DA@trevor.secretlab.ca>
Date: Tue, 20 May 2014 15:27:01 +0300
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F62AE653-E758-404F-AD3A-1215BB324EA5@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com> <1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com> <20140514100856.5198DC4153D@trevor.secretlab.ca> <E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com> <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com> <20140516105814.3EA3FC403C2@trevor.secretlab.ca> <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com> <20140520055026.E3A98C412DA@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On May 20, 2014, at 8:50 AM, Grant Likely wrote:

> On Fri, 16 May 2014 13:52:42 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> Hi Grant,
>> 
>> On Fri, May 16, 2014 at 12:58 PM, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>>> On Thu, 15 May 2014 09:20:24 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>> On Thu, May 15, 2014 at 9:12 AM, Pantelis Antoniou
>>>> <pantelis.antoniou@konsulko.com> wrote:
>>>>>> We also need to think about kexec. Kexec works by sucking the live tree
>>>>>> out of the kernel and creating a .dtb from it to pass to the new kernel.
>>>>>> What will the rules be when kexecing? Do all the overlays need to be
>>>>>> removed, or does the kernel get the tree with all the overlays applied
>>>>>> (in which case none of the overlays can be removed on the other side of
>>>>>> kexec).
>>>>> 
>>>>> We can add a sysfs attribute that configures whether overlays are reverted before
>>>>> kexec or not. I can't really tell which is the correct option, so let's allow the
>>>>> policy up to user-space.
>>>> 
>>>> Kexec'ing into a new kernel doesn't change the hardware, so IMHO the
>>>> in-kernel DT should not change.
>>> 
>>> Conceptually though, if overlays are applied then the new kernel has a
>>> different tree from the old one. If the overlay is hotpluggable, then
>>> after the kexec, the new kernel would no longer be able to unplug the
>>> overlay if it uses the current state of the tree instead of pulling the
>>> overlays off first.
>> 
>> Which brings me to another question...
>> 
>> Why has the overlay system been designed for plugging and unpluging whole
>> overlays?
>> That means the kernel has to remember the full stack, causing issues with
>> e.g. kexec.
> 
> Mostly so that drivers don't see any difference in the livetree data
> structure. It also means that userspace sees a single representation of
> the hardware at any given time.
> 

Yes. No change in semantics what-so-ever, when using the base DTS or an overlay.
In a nutshell, you should be able to copy the overlay contents on the base DTS
with equivalent results.

>> Why not allowing the addition of removal of subtrees of the full device
>> tree?
> 
> Overlays is more than just a subtree. A single overlay can make
> manipulations of multiple subtrees that should be handled as logically
> atomic.
> 

Right again. Drivers/subsystems are nowhere near ready to handle non-atomic
changes in their properties.

>> This is similar to other hotpluggable subsystems (which are not necessarily
>> DT-based), like PCI Express. That way the kernel can pass a
>> DT-representation of the actual current device tree to a kexec'ed kernel.
> 
> I'm not following you argument. Hardware hotplug systems like PCIe don't
> manipulate the firmware data. The kernel detects the new device and
> populates the Linux device model directly. Firmware provided data (ACPI
> or FDT) isn't involved.
> 

Hotplugged busses in theory do not need DT. In practice... that will come
later.

>> 
>> I missed the initial design discussions, so forgive me if this has been
>> beaten to death before.
> 
> It's a good question. An alternative would be to keep the overlay tree
> as a separate data structure and figure out how to make the core code
> reference the overlay when iterating over nodes and properties. I don't
> know how complex it would be to do that. We would definitely need to
> adjust the data structure a bit, but that isn't an insurmountable
> barrier.
> 

The changes required would be mind-boggingly complex. At least with the
overlay when you're done applying the changes you're done. Think about
the cases where multiple overlays are present. You'll have to iterate over
each and every one of them.
 
> g.
> 

Regards

-- Pantelis

