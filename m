Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaC3AOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 20:14:33 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51110 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaC3AOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 20:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140329171903.GA10551@google.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
	<CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
	<CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
	<CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
	<CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com>
	<20140329171903.GA10551@google.com>
Date: Sat, 29 Mar 2014 20:14:30 -0400
Message-ID: <CAOULuOaUke-W1W0o=1rhhk43Fy_RAYLdfhXQjdhy2xjHxP0oWA@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
From: Parag Warudkar <parag.lkml@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 1:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Rafael, linux-pci, linux-acpi]
>
> On Sat, Mar 29, 2014 at 09:41:20AM -0700, Linus Torvalds wrote:

>> Parag, can you add a WARN_ON_ONCE() to that message, so that we see
>> what the call chain is for it.
>
> I think we likely get a Bus Check notification when resuming, so we're
> probably in this path:
>
>     acpi_hotplug_notify_cb
>       acpi_hotplug_execute(acpi_device_hotplug, ...)
>         acpi_device_hotplug
>           acpi_scan_bus_check
>             acpi_pci_root_scan_dependent        # .hotplug.scan_dependent
>               acpiphp_check_host_bridge
>                 acpiphp_check_bridge
>                   enable_slot
>                     pcibios_resource_survey_bus
>                       dev_printk("Allocating resources")
>
> It seems like we ought to do the equivalent of a Bus Check from the
> root at boot-time, even if we don't receive an explicit Bus Check
> notification then (ACPI 5.0, sec 5.6.6, says "OSPM will typically
> perform a full enumeration automatically at boot time, but after
> system initialization it is the responsibility of the ACPI AML code to
> notify OSPM whenever a re-enumeration operation is required"), but I
> don't think we do, which makes the resume path different from the boot
> path.
>
> Parag, would you mind collecting an acpidump and attaching it to the
> bugzilla below?

I have attached a single acpidump to the bugzilla.

I realized that I misspoke when I said VTd makes a difference.
Actually on 3.14 exact same message appears on resume irrespective of
whether or not VTd is enabled.

However on 3.11 (3.11.0-18-generic Ubuntu LTS latest kernel) - I don't
see those messages irrespective of VTd status.
I must have accidentally booted into 3.11 kernel after disabling VTd
and thought the messages went away because of disabling VTd.

So we can ignore the VTd part.

>
> Is this a regression?  I guess you said that the message (and the sec-
> latency change, which I don't think is applicable to PCIe anyway) are
> the only ill effects you see, so it might not be too serious even if
> it is.

Not sure if Ubuntu includes any patches on top of 3.11 mainline that
make a difference to this issue - but in case they don't this might be
a regression.
About the seriousness part - I am not seeing any issues in my regular
use. Not sure what that bridge does and if there are any specific
devices involved - so it might just be that I am not using anything
that could be problematic due to this issue.

Thanks,

Parag
