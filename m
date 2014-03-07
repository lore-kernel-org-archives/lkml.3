Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaCGUdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:33:33 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48954 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaCGUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:33:32 -0500
MIME-Version: 1.0
In-Reply-To: <1394137532.2682.5.camel@x41>
References: <1391886379.2669.11.camel@x41> <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
 <1391890927.1882.5.camel@x41> <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com> <1394137532.2682.5.camel@x41>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Mar 2014 13:33:11 -0700
Message-ID: <CAErSpo7_oSXoze+33yPce0tmUuwOEYK_XBkMrQ+H3vC=hiLfAg@mail.gmail.com>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset flushing
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 1:25 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Bjorn Helgaas schreef op ma 10-02-2014 om 14:33 [-0700]:
>> Can you open a kernel.org bugzilla report and attach complete dmesg
>> logs of the working and broken kernels to it?  There might be more
>> useful resource-related messages from the PCI core.
>
> That took me quite a bit longer than I hoped, but I finally opened a
> report at
> https://bugzilla.kernel.org/show_bug.cgi?id=71611 .
>
> Note that the dmesg's are identical (up to that error). Are you still
> interested?

Thanks for attaching the dmesg log.  I also attached the iomem
contents you previously posted.

This is likely a tangent from the AGP issue, but I don't understand
this iomem diff between v3.13.2 and v3.14-rc1:

  -80000000-801fffff : PCI Bus 0000:02
  -80200000-8027ffff : 0000:00:02.1

The first line is a bridge window to [bus 02], and the second is an
MMIO region for one of your AGP devices (00:02.0 is VGA and 00:02.1
seems to be some related device).

The bridge to [bus 02] is 00:1c.0, and your dmesg shows:

  pci 0000:00:1c.0: PCI bridge to [bus 02]
  pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
  pci 0000:00:1c.0:   bridge window [mem 0xa0100000-0xa01fffff]

The [mem 0xa0100000-0xa01fffff] window appears in the dmesg log and in
both iomem captures; that makes good sense.  The 80000000-801fffff
window is in only the v3.13.2 iomem, and it *should* appear in the
v3.13.2 dmesg log but apparently doesn't?

Likewise, the 00:02.1 resource appears only in the v3.13.2 iomem, and
it should also be mentioned in the v3.13.2 dmesg log.  The v3.14-rc5
dmesg log shows an unassigned resource there:

  pci 0000:00:02.1: reg 0x10: [mem 0x00000000-0x0007ffff]

and says we were unable to assign anything.  But apparently v3.13.2
*did* assign something, and the dmesg log should show that.

Bjorn
