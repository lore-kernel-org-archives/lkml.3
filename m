Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3BJOXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:23:32 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:59873 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3BJOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:23:30 -0500
Message-ID: <1360506199.3461.5.camel@thor.lan>
Subject: Re: [Bisected] [-next-20130204] usb/hcd:  irq 18: nobody cared
From: Peter Hurley <peter@hurleysoftware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Date: Sun, 10 Feb 2013 09:23:19 -0500
In-Reply-To: <1360466060.3703.15.camel@thor.lan>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	 <1360466060.3703.15.camel@thor.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-09 at 22:14 -0500, Peter Hurley wrote:
> On Tue, 2013-02-05 at 15:26 -0500, Alan Stern wrote:
> > On Tue, 5 Feb 2013, Peter Hurley wrote:
> > 
> > > With -next-20130204:
> > > 
> > > [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
> > > [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
> > > [   33.855582] Call Trace:
> > > [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
> > > [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
> > > [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
> > > [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
> > > [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
> > > [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
> > > [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
> > > [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
> > > [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
> > > [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
> > > [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
> > > [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
> > > [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
> > > [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
> > > [   33.855660] handlers:
> > > [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
> > > [   33.855667] Disabling IRQ #18
> > > 
> > > From earlier in the boot log:
> > > [    1.297020] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> > > [    1.297032] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> > > [    1.297040] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> > > [    1.297076] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
> > > [    1.297213] hub 4-0:1.0: USB hub found
> > > [    1.297221] hub 4-0:1.0: 2 ports detected
> > > 
> > > lsusb:
> > > ...
> > > Bus 004 Device 002: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
> > > Bus 004 Device 003: ID 046d:c52b Logitech, Inc. Unifying Receiver
> 
> [...]
> 
> > If the suggestion above doesn't work out, bisection may be the best way
> > to find the answer.
> 
> This bad irq bisected to:
> 
> 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4 is the first bad commit
> commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Mon Jan 21 13:20:52 2013 -0800
> 
>     PCI: Put pci_dev in device tree as early as possible
>     
>     We want to put pci_dev structs in the device tree as soon as possible so
>     for_each_pci_dev() iteration will not miss them, but driver attachment
>     needs to be delayed until after pci_assign_unassigned_resources() to make
>     sure all devices have resources assigned first.
>     
>     This patch moves device registering from pci_bus_add_devices() to
>     pci_device_add(), which happens earlier, leaving driver attachment in
>     pci_bus_add_devices().
>     
>     It also removes unattached child bus handling in pci_bus_add_devices().
>     That's not needed because child bus via pci_add_new_bus() is already
>     in parent bus children list.
>     
>     [bhelgaas: changelog]
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> :040000 040000 0540c98d04d00de24b4e12fa750f6cd26c5addd2 2e24946cb7165a4028b7efb0a622271cc3990005 M	drivers
> 
> All is fine if I revert these 2 commits:
> 
> 40064ac PCI: Remove unused "rc" in virtfn_add_bus()
> 4f53509 (HEAD, refs/bisect/bad) PCI: Put pci_dev in device tree as early as possible
> 
> Any ideas how these are causing the USB HCD core / hid-logitech-dj
> driver to drop interrupts?

https://bugzilla.kernel.org/show_bug.cgi?id=53561

Maybe this is some interaction with all the new ACPI code and fixes
written in those 8 days.

peter@thor:~/src/kernels/next$ git log --oneline next-20130125..next-20130204 | grep -i acpi
65d6ce7 Merge remote-tracking branch 'acpi/next'
0d50e8c Merge branch 'acpi-pm-next' into linux-next
be6d286 PCI: acpiphp: Remove dead code for PCI host bridge hotplug
4b794a0 Merge branch 'acpi-assorted' into linux-next
bd3e4a3 Merge branch 'acpi-cleanup' into linux-next
02df734 ACPI / dock: Fix acpi_bus_get_device() check in drivers/acpi/dock.c
7217dac Merge branch 'acpi-lpss' into linux-next
4bede3f Merge branch 'acpi-pm' into linux-next
cc0755b Merge branch 'acpica' into linux-next
308b10d Merge branch 'acpi-scan' into linux-next
2ca344e PCI: acpiphp: Create companion ACPI devices before creating PCI devices
741220e cpufreq: Make acpi-cpufreq link first
c40a451 acpi-cpufreq: Do not load on K8
b378549 ACPI / PM: Do not power manage devices in unknown initial states
cfc5755 PNPACPI: Fix acpi_bus_get_device() check in drivers/pnp/pnpacpi/core.c
dde3bb4 ACPI / PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
456de89 ACPI / scan: Clean up acpi_bus_get_parent()
0613e1f ACPI / scan: Fix acpi_bus_get_device() check in acpi_match_device()
141a297 ACPI / platform: Use struct acpi_scan_handler for creating devices
4daeaf6 ACPI / PCI: Make PCI IRQ link driver use struct acpi_scan_handler
00c43b9 ACPI / PCI: Make PCI root driver use struct acpi_scan_handler
ca589f9 ACPI / scan: Introduce struct acpi_scan_handler
3b2ab2b Revert "usb: Register usb port's acpi power resources"
8b4e2fa Merge branch 'acpi-lpss' into acpi-cleanup
64e94e7 Merge branch 'acpi-scan' into acpi-cleanup
2c0d4fe ACPI / scan: Make scanning of fixed devices follow the general scheme
8a78cf7 Merge branch 'acpi-pm' into acpi-cleanup
0d1c28a gpiolib-acpi: Add ACPI5 event model support to gpio.
65ab96f ACPI / PM: Fix /proc/acpi/wakeup for devices w/o bus or parent
c511cc1 ACPI / scan: Make namespace scanning and trimming mutually exclusive
fb45579 Merge branch 'pci/acpi-scan2' into next
09212fd ACPI: Drop device start operation that is not used
51fac83 ACPI: Remove useless type argument of driver .remove() operation
cc38e51 Merge branch 'acpi-scan' into acpi-cleanup
5baa1be ACPI: fix obsolete comment in custom_method.c
ca4e713 ACPI / thermal: Use mode to enable/disable kernel thermal processing
7e3cf24 ACPI thermal: remove unnecessary newline from exception message
c628423 ACPI sysfs: remove unnecessary newline from exception
bf6787e ACPI video: remove unnecessary newline from error messages
208f6cc ACPI: SRAT: report non-volatile memory in debug
33f767d ACPI: Rework acpi_get_child() to be more efficient
bfee26d ACPI / scan: Make it clear that acpi_bus_trim() cannot fail
d59f53b PCI: acpiphp: Keep driver loaded even if no slots found
121b090 PCI/ACPI: Print info if host bridge notify handler installation fails
668192b PCI: acpiphp: Move host bridge hotplug to pci_root.c
92d8aff PCI/ACPI: acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work()
660b111 ACPI / PM: Fix consistency check for power resources during resume
18a3870 ACPI / PM: Expose lists of device power resources to user space
1f96a96 PCI: acpiphp: Add is_hotplug_bridge detection
a276660 Merge branch 'acpi-scan' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm into pci/acpi-scan2
88bb965 usb: Register usb port's acpi power resources
2171953 ACPICA: Update version to 20130117
378bb8b ACPICA: Update predefined info table for _MLS method
5e30a96 ACPICA: Remove some extraneous newlines in ACPI_ERROR type calls
d9652b4 ACPICA: iASL/Disassembler: Add option to ignore NOOP opcodes/operators
48ffb94 ACPICA: AcpiGetSleepTypeData: Allow \_Sx to return either 1 or 2 integers
25f044e ACPICA: Update ACPICA copyrights to 2013
586ce51 ACPICA: Update predefined info table
afd51a0 x86/acpi: Use __pa_symbol instead of __pa on C visible symbols

Regards,
Peter Hurley

