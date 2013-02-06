Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3BFO2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:28:36 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:48924 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3BFO2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:28:33 -0500
MIME-Version: 1.0
In-Reply-To: <51125B56.9050407@imgtec.com>
References: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com>
 <51125B56.9050407@imgtec.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Feb 2013 14:28:13 +0000
X-Google-Sender-Auth: MMn07nF56oD41j89CPjBBj03nV8
Message-ID: <CACxGe6vuZ2H-G7xamS6SAiX_aCbjpO+vKavqCK77ek8tTdOmdA@mail.gmail.com>
Subject: Re: Heads up on a device tree change
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 1:32 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 06/02/13 13:11, Grant Likely wrote:
>> Hi Stephen,
>>
>> I've just pushed out a change which cleans up platform device
>> registration to use the same path whether or not the device tree is
>> used. It should be safe, but there is a risk of breakage on powerpc
>> platforms.
>>
>> The patch has two effects of note:
>> - DT generated platform devices move from /sys/devices to under
>> /sys/devices/platform. Userspace *should* be okay with this, but if
>> there are any problems then I can post a workaround patch that keeps
>> DT generiated platform_devices in the current location.
>> - Resources on platform_devices get registered so they appear in
>> /proc/iomem and /proc/ioports and so that device drivers get the added
>> protection of request_region. This will cause breakage on device trees
>> nodes with partially overlapping memory regions. (ie. 0x100..0x1ff and
>> 0x180..0x27f). I also have a workaround for this, but I doubt that it
>> will be necessary.
>
> Hi Grant,
>
> If I understand you correctly, the non-overlapping memory regions thing
> could be a problem for me. We have a Meta based SoC that has various SoC
> registers grouped together for doing GPIOs and Pin control things. I'm
> still in the process of converting it to device tree, but the way I've
> been handling it is to provide overlapping registers to both the gpio
> and pinctl DT nodes. Each GPIO bank's registers are also interleaved
> with the others, so I've been providing overlapping register ranges
> (offset by 4 for each bank) to the DT node for each gpio bank too, so
> each bank can function independently and the driver doesn't have to
> worry about multiple banks. Does that sound like a reasonable use case?
>
> I guess I could cheat with the length, or specify each register in it's
> own memory resource, but it seems like overkill.

Note that overlapping regions are fine /provided/ that they are the
same size or one fits nicely inside another. It's partial overlap that
is a problem

I've been thinking about your exact problem though and I think the
best way to handle it is for the gpio driver to understand multiple
banks. Most memory mapped GPIO controllers should be drivable by the
generic gpio driver anyway, so it is a matter of crafting the binding
so a single node can describe multiple banks. I still need to review
the patch that adds a DT binding for the generic gpio driver.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
