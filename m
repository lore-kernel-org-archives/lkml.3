Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab3GSRq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:46:29 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50146 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3GSRq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130712111121.GB3515@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz> <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz> <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz> <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Jul 2013 11:46:06 -0600
Message-ID: <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 5:11 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
>> 3945ABG.  I'm pretty sure the problem he's reporting is with the
>> 82573L.  Ping times are bad (~100msec) when ASPM is enabled, as
>> reported by lspci.
>
> Yep. Wired ethernet has the problems.
>
>> On Pavel's system, the FADT says we shouldn't enable OSPM control of
>> ASPM (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One
>> effect is that we don't blacklist the pre-1.1 82573L device, which I
>> think results in it being left with the BIOS configuration, which
>> apparently has ASPM enabled.  (Pavel, could you confirm the BIOS
>> config, e.g., with "pci=earlydump"?)
>
> Dump sent in another mail.

Thanks for the dmesg log.  It confirms that the BIOS left ASPM L1
enabled on your 82573L device.  The PCIe cap is at 0xe0 per previous
lspci output, and the Link Control register at 0xf0 contains 0x0142,
which means ASPM L1, Common Clock, and Clock PM are enabled.

> Ok, so we get copy of Windows, including the problem :-(.

Just to make sure I understand you correctly: I think you are saying
that the NIC has the same problem under Windows.

> Ok, so we have BIOS on x60 that sets up hardware in a way that does
> not work... and then tells us we must not do ASPM, so we don't fix it.
>
> One option would be "always disable ASPM, even if BIOS tells us it is
> not supported".

Yes.  We considered this route, but it didn't seem safe in general.
The problem is that the BIOS isn't actually telling us that ASPM is
not supported.  Rather, it is telling us that we "must not enable OSPM
ASPM control".  That means we can't touch ASPM control at all, whether
to enable or disable.  We have to assume the BIOS itself is managing
ASPM, and if the OS tries to manage ASPM it will cause conflicts.

> Other option would be "add explicit blacklist for x60, disable ASPM
> there.".

We *could* consider something like this, since its scope is limited.
But since the problem also occurs with Windows, it's pretty likely
that there's a BIOS update to fix it.  I notice on the X60 support
page that there are several versions newer than what you're running.

Bjorn
