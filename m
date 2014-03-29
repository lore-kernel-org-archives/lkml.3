Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaC2RTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:19:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40165 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2RTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:19:08 -0400
Date: Sat, 29 Mar 2014 11:19:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Parag Warudkar <parag.lkml@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: BAR 14: can't assign mem (size 0x200000)
Message-ID: <20140329171903.GA10551@google.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
 <CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
 <CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
 <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
 <CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, linux-pci, linux-acpi]

On Sat, Mar 29, 2014 at 09:41:20AM -0700, Linus Torvalds wrote:
> On Sat, Mar 29, 2014 at 12:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >
> > Later during resuming, kernel try to assign resource 02:00.0 but it will fail
> > as parent bridge 00:1c.3 has no resource.
> > (Not sure how pci_configure_slot get called with this resume path).
> 
> I think that last comment is the most pertinent one: why does resume
> try to assign resources to PCI devices? It should be *restoring* them,
> not re-assigning any resources.
> 
> Parag, can you add a WARN_ON_ONCE() to that message, so that we see
> what the call chain is for it.

I think we likely get a Bus Check notification when resuming, so we're
probably in this path:

    acpi_hotplug_notify_cb
      acpi_hotplug_execute(acpi_device_hotplug, ...)
	acpi_device_hotplug
	  acpi_scan_bus_check
	    acpi_pci_root_scan_dependent        # .hotplug.scan_dependent
	      acpiphp_check_host_bridge
		acpiphp_check_bridge    
		  enable_slot
		    pcibios_resource_survey_bus
		      dev_printk("Allocating resources")

It seems like we ought to do the equivalent of a Bus Check from the
root at boot-time, even if we don't receive an explicit Bus Check
notification then (ACPI 5.0, sec 5.6.6, says "OSPM will typically
perform a full enumeration automatically at boot time, but after
system initialization it is the responsibility of the ACPI AML code to
notify OSPM whenever a re-enumeration operation is required"), but I
don't think we do, which makes the resume path different from the boot
path.

Parag, would you mind collecting an acpidump and attaching it to the
bugzilla below?

Is this a regression?  I guess you said that the message (and the sec-
latency change, which I don't think is applicable to PCIe anyway) are
the only ill effects you see, so it might not be too serious even if
it is.

I am concerned about the VT-d connection and the sec-latency change.
I wouldn't be surprised to find that the resume path doesn't restore
sec-latency, but I don't know why VT-d would affect the resource
allocation.  I guess it's possible that enabling VT-d might change
the ACPI namespace; maybe you could collect *two* acpidumps: one with
VT-d enabled and another with it disabled.

Let's continue the discussion in email, but I did open
https://bugzilla.kernel.org/show_bug.cgi?id=73141 as a place to archive
your logs.

Bjorn
