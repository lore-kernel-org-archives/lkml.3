Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaCHOMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 09:12:42 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:49923 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCHOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:12:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140307204021.GA9822@google.com>
References: <1391886379.2669.11.camel@x41> <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
 <1391890927.1882.5.camel@x41> <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
 <1394185698.5608.5.camel@x41> <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 8 Mar 2014 07:12:19 -0700
Message-ID: <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
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

On Fri, Mar 7, 2014 at 1:40 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> It seems quite possible that I broke pci_bus_alloc_resource(), which could
> cause an allocation failure like this.
>
> If you have a chance to try it, here's a debug patch against v3.14-rc5.  It
> should apply cleanly to 96702be56037.  If you can try it, please attach the
> dmesg log to the bugzilla.

Paul verified that I *did* break this.  More details in the bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=71691

The problem is basically that I used resource_size() to figure out
whether there's any available space.  resource_size() is res->end -
res->start + 1, so applying it to [mem 0x00000000-0xffffffff] returns
zero in a kernel 32-bit resource addresses, i.e., with
CONFIG_PHYS_ADDR_T_64BIT=n.

Paul, I assume you have CONFIG_PHYS_ADDR_T_64BIT=n (which is perfectly
legal); let me know if otherwise.

  pci_bus 0000:00: pci_bus_alloc_from_region: alloc [mem 0x00000000]
size 0x1000 from bus region [0x00000000-0xffffffff]
  pci_bus 0000:00: pci_bus_alloc_from_region: [mem
0x00000000-0xffffffff]: no space (avail [mem 0x00000000-0xffffffff])

Bjorn
