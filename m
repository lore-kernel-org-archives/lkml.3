Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3GZTjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:39:20 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:51618 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3GZTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
References: <1374821475-3196-1-git-send-email-rui.y.wang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Jul 2013 13:38:53 -0600
Message-ID: <CAErSpo653opkF_ROupSOYoP21LGwm023430Pyj_thbFeDXRq9w@mail.gmail.com>
Subject: Re: [RFC 0/3] IO Hook: Method for emulating h/w events
To: Rui Wang <ruiv.wang@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, chaohong.guo@intel.com,
        Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <rui.y.wang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-acpi]

On Fri, Jul 26, 2013 at 12:51 AM, Rui Wang <ruiv.wang@gmail.com> wrote:
> Hi Bjorn,
>
> This was originally the method I used to test hotplug on Intel SDV machines
> which are not capable of doing hotplug. I would like to present it here in
> case it interests the community, then it can be made available to a wider
> range of developers who are working on hotplug.
>
> I used it to generate desired ACPI events, PCI interrupts, and more. So
> things like CPU hotplug, IOH hotplug, memory hotplug, PCI native hotplug,
> PCI AER injection can be emulated and tested easily.
>
> The best thing is that, it doesn't require any modification to those drivers
> involved. It works with whatever hardware events that the user can imagine.
> Further development in user-space using scripts may help simplify the usage
> model and add more software-defined logic on hardware.
>
> Because it modifies the heart of all h/w access functions, I used Jump Label
> to reduce the performance penalty to effectively zero.

This is a cool idea.

I don't know if you want to merge this upstream, or if it's just a "I
found this useful; here it is in case it's useful to you" sort of
thing.  So the comments below are only relevant if you want to try to
merge it upstream.

I wouldn't really want all the gunk in drivers/pci/access.c.  Most of
it isn't related to PCI, and some of it is even x86-specific.  It'd be
nicer if you could factor it out so just the generic PCI-related
things go in drivers/pci.

It appears to be implemented only for x86.  The MMIO & I/O port parts
are x86-specific, but the PCI config stuff should work on any arch.

I don't know whether it's worth supporting as a module.  It seems like
a development aid where building in statically would probably be fine.
 If it didn't have to work as a module, you wouldn't have to export
any symbols.

> I tested the performance by repeatedly running lspci, which calls into the
> pci access functions. There's no added overhead observed.
>
> Regards,
> Rui Wang
> Intel Open Source Technology Center
>
> Rui Wang (3):
>   IO Hook: core functions and Register Override
>   IO Hook: kernel interface to manage the hook
>   IO Hook: sysfs interface to emulate h/w events
>
>  Documentation/PCI/iohook.txt      |  290 +++++++++++++++++
>  arch/x86/Kconfig                  |    7 +
>  arch/x86/boot/compressed/Makefile |    1 +
>  arch/x86/include/asm/io.h         |   58 ++++-
>  arch/x86/vdso/Makefile            |    2 +
>  drivers/misc/Kconfig              |    1 +
>  drivers/misc/Makefile             |    1 +
>  drivers/misc/iohook/Kconfig       |    5 +
>  drivers/misc/iohook/Makefile      |    1 +
>  drivers/misc/iohook/iohook.c      |  503 +++++++++++++++++++++++++++++
>  drivers/pci/access.c              |  630 +++++++++++++++++++++++++++++++++++++
>  include/linux/reg_ovrd.h          |   55 ++++
>  12 files changed, 1552 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/PCI/iohook.txt
>  create mode 100644 drivers/misc/iohook/Kconfig
>  create mode 100644 drivers/misc/iohook/Makefile
>  create mode 100644 drivers/misc/iohook/iohook.c
>  create mode 100644 include/linux/reg_ovrd.h
>
> --
> 1.7.5.4
>
