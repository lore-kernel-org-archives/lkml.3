Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaGHWDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaGHWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:03:32 -0400
Message-ID: <53BC6AAA.4030305@redhat.com>
Date: Tue, 08 Jul 2014 15:03:22 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alex Elsayed <eternaleye@gmail.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 1/2] target: Add documentation on the target userspace pass-through
 driver
References: <1404241875-29164-1-git-send-email-agrover@redhat.com> <1404241875-29164-2-git-send-email-agrover@redhat.com> <lp8niu$ltr$1@ger.gmane.org>
In-Reply-To: <lp8niu$ltr$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[re-adding individual CCs that were dropped]

On 07/05/2014 04:29 AM, Alex Elsayed wrote:
>> +Device Discovery:
>> +
>> +Other devices may be using UIO besides TCMU. Unrelated user processes
>> +may also be handling different sets of TCMU devices. TCMU userspace
>> +processes must find their devices by scanning sysfs
>> +class/uio/uio*/name. For TCMU devices, these names will be of the
>> +format:
>> +
>> +tcm-user/<subtype>/<path>
>> +
>> +where "tcm-user" is common for all TCMU-backed UIO devices. <subtype>
>> +will be a userspace-process-unique string to identify the TCMU device
>> +as expecting to be backed by a certain handler, and <path> will be an
>> +additional handler-specific string for the user process to configure
>> +the device, if needed. Neither <subtype> or <path> can contain ':',
>> +due to LIO limitations.
>
> It might be good to change this somewhat; in the vast majority of cases it'd
> be saner for userspace programs to figure this information out via udev etc.
> rather than parsing sysfs themselves. This information is still worth
> documenting, but saying things like "must find their devices by scanning
> sysfs" is likely to lead to users of this interface making suboptimal
> choices.

I agree. There's no getting around a certain degree of work required by 
the backing user program. I'm planning on writing a "tcmu-runner" 
program with a plugin interface, that will handle the event loop, device 
notifications, enumeration, and possibly thread pools, to minimize the 
amount of boilerplate code each implementation must contain.

>> +Device Events:
>> +
>> +If a new device is added or removed, user processes will recieve a HUP
>> +signal, and should re-scan sysfs. File descriptors for devices no
>> +longer in sysfs should be closed, and new devices should be opened and
>> +handled.
>
> Is there a cleaner way to do this? In particular, re-scanning sysfs may
> cause race conditions (device removed, one of the same name re-added but a
> different UIO device node; probably more to be found). Perhaps recommend
> netlink uevents, so that remove+add is noticeable? Also, is the SIGHUP
> itself the best option? Could we simply require the user process to listen
> for add/remove uevents to get such change notifications, and thus enforce
> good behavior?

Yes this sounds better, let's do it this way.

> One use case I'm actually interested in is having userspace provide
> something other than just SPC - for instance, tgt can provide a virtual tape
> library or an OSD, and CDemu can provide emulated optical discs from various
> image formats.
>
> Currently, CDemu uses its own out-of-tree driver called VHBA (Virtual Host
> Bus Adapter) to do pretty much exactly what TCMU+Loopback would
> accomplish... and in the process misses out on all of the other fabrics,
> unless you're willing to _re-import_ those devices using PSCSI, which has
> its own quirks.
>
> Perhaps there could be a level 0 (or 4, or whatever) which means "explicitly
> enabled list of commands" - maybe as a bitmap that could be passed to the
> kernel somehow? Hopefully, that could also avoid some of the quirks of PSCSI
> regarding ALUA and such - if it's not implemented, leave the relevant bits
> at zero, and LIO handles it.

I'm beginning to sour on pass_level and having configurable cmd 
filtering in the kernel interface.

I think a less-clever but simpler approach might be to eliminate 
filtering, and the user process can return CHECK_CONDITION, INVALID 
COMMAND OPERATION CODE for commands it doesn't wish to support. TCMU 
checks for this, and the pending command thus returned can still be 
emulated by LIO (it looks like we could just re-call sbc_parse_cdb and 
target_execute_cmd).

> This does look really nice, thanks for writing it!

Thanks for your helpful feedback! :)

-- Andy

