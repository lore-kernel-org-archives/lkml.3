Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3FJL7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:59:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34910 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3FJL7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:59:50 -0400
Date: Mon, 10 Jun 2013 14:59:38 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610115938.GA12892@x220.ger.corp.intel.com>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610110423.GA8834@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, Jun 10, 2013, Pavel Machek wrote:
> > > root@amd:~# hciconfig hci0 up
> > > Can't init device hci0: Operation not supported (95)
> > > root@amd:~# hcitool inq
> > > Inquiring ...
> > > Inquiry failed.: No such device
> > > root@amd:~# 
> > 
> > Could you take logs of the HCI traffic that happens when you try this.
> > You can use the btmon tool from BlueZ for it. Based on a quick look at
> > the code it seems like this particular error could only come if one of
> > the HCI commands used for device initialization fails.
> 
> Where can I get btmon? I tried 
> 
> root@amd:~# apt-get install bluez-utils
> 
> but it is not there.

I can only speak from an upstream perspective (since I'm not familiar
with distro-specific packaging conventions), but btmon is what you'll
find in the monitor subdirectory of the bluez source tree.

> (Can I just add printk somewhere?)

If you want, the Bluetooth subsystem does support the dynamic debug
feature, so you could enable logs for hci_core.c and hci_event.c.
However, this will likely still not be enough and the HCI logs would
anyway be needed. One thing to note is that btmon is a quite new tool
which may not yet be packaged by your distro (it appeared in BlueZ 5,
released 6 months ago). An alternative which should work too is hcidump,
probably packed in a bluez-hcidump package on your distro.

> 
> > The Bluetooth HCI init sequence is constructed using only commands that
> > should be expected to work assuming the hardware follows the
> > specification, but occasionally we do encounter Bluetooth hardware that
> > is broken in one way or another and needs a work around to the sequence.
> > E.g. recently we added a couple of extra commands to read some new
> > parameters from the hardware, commands that are mandatory for hardware
> > beyond a specific version (something we check for), but could be that
> > the chip on the X60 doesn't support these.
> 
> I don't expect strace is enough?
> 
> set_thread_area({entry_number:-1 -> 6, base_addr:0xb7624b20,
> limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
> limit_in_pages:1, seg_not_present:0, useable:1}) = 0
> mprotect(0xb7766000, 8192, PROT_READ)   = 0
> mprotect(0xb77b2000, 4096, PROT_READ)   = 0
> munmap(0xb7782000, 76642)               = 0
> socket(PF_BLUETOOTH, SOCK_RAW, 1)       = 3
> ioctl(3, 0x800448d3, 0xb77cc420)        = 0
> ioctl(3, 0x400448c9, 0)                 = -1 EOPNOTSUPP (Operation not
> supported)
> write(2, "Can't init device hci0: Operatio"..., 53Can't init device
> hci0: Operation not supported (95)
> ) = 53
> exit_group(1)                           = ?

Nope, that still doesn't show anything new compared to what we already
know. The interesting part is what messages the kernel is exchanging
with the Bluetooth hardware and the only way the get a full
understanding of that is with btmon or hcidump.

Johan
