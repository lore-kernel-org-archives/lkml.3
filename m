Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbaFHEUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 00:20:11 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46698 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaFHEUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 00:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
References: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 7 Jun 2014 22:19:46 -0600
Message-ID: <CAErSpo6WoWrcVaZd9OoqaK9qBTY+vXQZqs40Hb2vZJ4Y8zjMXQ@mail.gmail.com>
Subject: Re: What can change in ways Linux handles memory when all memory >4G
 is disabled? (x86)
To: Nikolay Amiantov <nikoamia@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, linux-pm]

On Fri, Jun 6, 2014 at 6:06 PM, Nikolay Amiantov <nikoamia@gmail.com> wrote:
> Hello all,
>
> I'm trying to resolve a cryptic problem with Lenovo T440p (and with
> Dell XPS 15z, as it appears) and nvidia in my spare time. You can read
> more at [1]. Basically: when the user disables and then re-enables
> nvidia card (via ACPI, bbswitch or nouveau's dynpm) on new BIOS
> versions, something becomes really wrong. User sees fs, usb devices
> and network controllers faults of all kinds, system renders unusable
> and user can observe filesystem corruption after reboot. Nvidia
> drivers (or nouveau, or i915) can not even be loaded -- all that is
> needed to trigger a bug is to call several ACPI methods to disable and
> re-enable the card (e.g., via acpi-call module).

I don't know what ACPI methods you're calling, but (as I'm sure you
know) it's not guaranteed to be safe to call random methods because
they can make arbitrary changes to the system.

> I've attached a debugger to Windows kernel to catch ACPI calls for
> disabling and re-enabling NVIDIA card -- they don't really differ with
> what bbswitch and others use. Furthermore, the difference between ACPI
> DSDT tables in 1.14 (last good) and 1.16 (first broken) BIOSes are
> minimal, and loading table from 1.14 into system running 1.16 does not
> help. But -- all those devices are using memory I/O, so my current
> theory is that memory is somehow corrupted. There are also some
> changes in lspci output for nvidia [2].

I skimmed through [1], but I'm not sure I understood everything.
Here's what I gleaned; please correct any mistaken impressions:

  1) Suspend/resume is mentioned in [1], but the problem occurs even
without any suspend/resume.
  2) The problem happens on a completely stock untainted upstream
kernel even with no nvidia, nouveau, or i915 drivers loaded.
  3) Disabling the nvidia device (02:00.0) by executing an ACPI method
works fine, and the system works fine after the nvidia device is
disabled.
  4) This ACPI method puts the nvidia device in D3cold state.
  5) Problems start when enabling the nvidia device by executing
another ACPI method.

In the D3cold state, the PCI device is entirely powered off.  After it
is re-enabled, e.g., by the ACPI method in 5) above, the device needs
to be completely re-initialized.  Since you're executing the ACPI
method "by hand," outside the context of the Linux power management
system, there's nothing to re-initialize the device.

This by itself shouldn't be a problem; the device should power up with
its BARs zeroed out and disabled, bus mastering disabled, etc.

BUT the kernel doesn't know about these power changes you're making,
so some things will be broken.  For example, while the nvidia device
is in D3cold, lspci will return garbage for that device.  After it
returns to D0, lspci should work again, but now the state of the
device (BAR assignments, interrupts, etc.) is different from what
Linux thinks it is.

If a driver does anything with the device after it returns to D0, I
think things will break, because the PCI core already knows what
resources are assigned to the device, but the device forgot them when
it was powered off.  So the PCI core would happily enable the device
but it will respond at the wrong addresses.

But I think you said problems happen even without any driver for the
nvidia device, so there's probably more going on.  This is a video
device, and I wouldn't be surprised if there's some legacy VGA
behavior that doesn't follow the usual PCI rules.

Can you:

1) Collect complete "lspci -vvxxx" output from the whole system, with
the nvidia card enabled.
2) Disable nvidia card.
3) Collect complete dmesg log.
4) Try "lspci -s02:00.0".  I expect this to show garbage if the nvidia
card is powered off.
5) Enable nvidia card.
6) Try "lspci -vvxxx" again.  You mentioned changes to devices other
than nvidia, which sounds suspicious.
7) Collect dmesg log again.  I don't expect changes here, because the
kernel probably doesn't notice the power transition.

Bjorn

> I've played a bit with this theory in mind and found a very
> interesting thing -- when I reserve all memory upper than 4G with
> "memmap" kernel option ("memmap=99G$0x100000000"), everything works!
> Also, I've written a small utility that fills memory with zeros using
> /dev/mem and then checks it. I've checked reserved memory with it, and
> it appears that no memory in that region is corrupted at all, which is
> even more strange. I suspect that somehow when nvidia is enabled
> I/O-mapped memory regions are corrupted, and only when upper memory is
> not enabled. Also, memory map does not differ apart from missing last
> big chunk of memory with and without "memmap", and with Windows, too.
> If I enable even small chunk of "upper" memory (e.g.,
> 0x270000000-0x280000000), there are usual crashes.
>
> Long story short: I'm interested how memory management can differ when
> this "upper" memory regions are enabled?
>
> P.S.: This is my first time posting to LKML, if I've done something
> wrong, please tell!
>
> [1]: https://github.com/Bumblebee-Project/bbswitch/issues/78
> [2]: http://bpaste.net/show/350758/
>
> --
> Nikolay Amiantov.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
