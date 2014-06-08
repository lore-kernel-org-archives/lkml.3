Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaFHRWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:22:33 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46943 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaFHRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6WoWrcVaZd9OoqaK9qBTY+vXQZqs40Hb2vZJ4Y8zjMXQ@mail.gmail.com>
References: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
 <CAErSpo6WoWrcVaZd9OoqaK9qBTY+vXQZqs40Hb2vZJ4Y8zjMXQ@mail.gmail.com>
From: Nikolay Amiantov <nikoamia@gmail.com>
Date: Sun, 8 Jun 2014 21:22:10 +0400
Message-ID: <CA+waHKVFvA=M0KBHw0p6z_Mbs7BiMBMJ3TDyP-qiDYDWBeUDuA@mail.gmail.com>
Subject: Re: What can change in ways Linux handles memory when all memory >4G
 is disabled? (x86)
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 8:19 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc linux-pci, linux-pm]
>
>
> I don't know what ACPI methods you're calling, but (as I'm sure you
> know) it's not guaranteed to be safe to call random methods because
> they can make arbitrary changes to the system.
Yes, I've tested this behaviour with bbswitch and nouveau's runpm
separately, because of this -- this problem is persisting without any
changes.
>
>
> I skimmed through [1], but I'm not sure I understood everything.
> Here's what I gleaned; please correct any mistaken impressions:
>
>   1) Suspend/resume is mentioned in [1], but the problem occurs even
> without any suspend/resume.

Yes, that's correct -- suspend/resume was mentioned because a lot of
people observe this bug after bbswitch module they are using disables
nvidia at boot and enables it again on suspend (I can't remember why
it does this). When this happens, on resume user observes black
screen, broken FS and so on.

>   2) The problem happens on a completely stock untainted upstream
> kernel even with no nvidia, nouveau, or i915 drivers loaded.
It depends on what you call "stock" -- something in kernel is needed
to trigger this behaviour, but I've tested it on ramdisk with only
acpi_call module loaded (which is non-stock, but only allows to do
arbitrary ACPI calls from userspace). This behaviour is same with
nouveau+i915, too (which can be called stock), and with bbswitch
(which can't be called so).
>   3) Disabling the nvidia device (02:00.0) by executing an ACPI method
> works fine, and the system works fine after the nvidia device is
> disabled.

Yes, the most popular "workaround" for this problem, giving you don't
care about nvidia and only want to lower power consumption, is to use
something like [1] (commented lines are calls how they are made in
Windows).

>   4) This ACPI method puts the nvidia device in D3cold state.

Right, as far as I understood.

>   5) Problems start when enabling the nvidia device by executing
> another ACPI method.

Again right, you can observe an example in [2].

>
> In the D3cold state, the PCI device is entirely powered off.  After it
> is re-enabled, e.g., by the ACPI method in 5) above, the device needs
> to be completely re-initialized.  Since you're executing the ACPI
> method "by hand," outside the context of the Linux power management
> system, there's nothing to re-initialize the device.
>
> This by itself shouldn't be a problem; the device should power up with
> its BARs zeroed out and disabled, bus mastering disabled, etc.
>
> BUT the kernel doesn't know about these power changes you're making,
> so some things will be broken.  For example, while the nvidia device
> is in D3cold, lspci will return garbage for that device.  After it
> returns to D0, lspci should work again, but now the state of the
> device (BAR assignments, interrupts, etc.) is different from what
> Linux thinks it is.
>
> If a driver does anything with the device after it returns to D0, I
> think things will break, because the PCI core already knows what
> resources are assigned to the device, but the device forgot them when
> it was powered off.  So the PCI core would happily enable the device
> but it will respond at the wrong addresses.

Thanks for the explanations! I don't really know much about PCI or
Linux PCI subsystem internals, only some general theory, including
memory I/O and power states. This doesn't, however, explain why does
this bug is observable even with nouveau's proper dynpm or bbswitch.
I've looked through the source of bbswitch [3], and, AFAIU, it differs
from raw calls in those ways:

1) It calls only _DSM ACPI routine and then disables the device by
issuing calls on lines 260-277 (it saves some state and puts device to
D3 from what I can tell, maybe it will tell more to you).
2) It doesn't use ACPI at all for enabling the card, only puts device
to D0 again, restores state and sets something (lines 292-296).

>
> But I think you said problems happen even without any driver for the
> nvidia device, so there's probably more going on.  This is a video
> device, and I wouldn't be surprised if there's some legacy VGA
> behavior that doesn't follow the usual PCI rules.
>
> Can you:
>
> 1) Collect complete "lspci -vvxxx" output from the whole system, with
> the nvidia card enabled.
> 2) Disable nvidia card.
> 3) Collect complete dmesg log.
> 4) Try "lspci -s02:00.0".  I expect this to show garbage if the nvidia
> card is powered off.

>From what I have understood, you have wanted me to do this with raw
ACPI calls, not with other methods, correct?

> 5) Enable nvidia card.
> 6) Try "lspci -vvxxx" again.  You mentioned changes to devices other
> than nvidia, which sounds suspicious.
> 7) Collect dmesg log again.  I don't expect changes here, because the
> kernel probably doesn't notice the power transition.

There are some problems with (5..7), because after nvidia is enabled
again, the system goes berserk with no way to do some output besides,
maybe, doing a screen photo (which I've used). I can do this with >4G
of memory disabled, however, which (as I've said) somehow puts
everything in order -- I have done it this way, too. dmesg log has no
relevant changes.

Again, for clarity: Testing has been made with 3.14.5 kernel with some
patches from Arch (bugfixes not yet in stable), BFQ, loaded acpi_call
module [4] and "memmap" option. I've used [1] and [2] to disable end
enable the card. This behaviour is reproducable with stock Arch
kernel, linux-lts and also with linux-next from month ago (I don't
have linux-next ready now, and I need a bugfix for bcache -- otherwise
dmesg is filled with backtraces, which is why I haven't used other
kernels for this).

Testing with disabled >=4G of mem:
1st lspci: http://bpaste.net/show/355530/
dmesg: http://bpaste.net/show/355531/
lspci -s: http://bpaste.net/show/355532/
2nd lspci: http://bpaste.net/show/355533/

Testing with enabled >=4G of mem:
1st lspci: http://bpaste.net/show/355613/
dmesg: http://bpaste.net/show/355619/
lspci -s: identical
2nd lspci: http://abbradar.net/abbradar/share/pub/nvidia-lspci/
dmesg log if riddled with various subsystems' errors (mostly iwlwifi,
e1000e, ide and so on), I haven't made photos because "less" binary
became corrupted.

BTW: Thanks for the answer!

Nikolay Amiantov.

[1]: http://bpaste.net/show/355364/
[2]: http://bpaste.net/show/355365/
[3]: https://github.com/Bumblebee-Project/bbswitch/blob/master/bbswitch.c
[4]: https://github.com/mkottman/acpi_call/

>
> Bjorn
>
