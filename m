Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaICPyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:54:39 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:49705 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaICPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <ghwq9k3m6z.fsf@lena.gouders.net>
References: <ghiol53r9u.fsf@lena.gouders.net> <CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
 <ghwq9k3m6z.fsf@lena.gouders.net>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Wed, 3 Sep 2014 17:54:17 +0200
Message-ID: <CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
To: Dirk Gouders <dirk@gouders.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 2:47 PM, Dirk Gouders <dirk@gouders.net> wrote:
> Andreas Noever <andreas.noever@gmail.com> writes:
>
>> On Wed, Sep 3, 2014 at 12:57 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>> On a Tyan VX50 (B4985) I ran into problems when updating the kernel: the
>>> PCI FC Adapter is no longer recognized.
>>
>> Can you provide the output of lspci -vvv and the output of dmesg from
>> a working boot? Which card is the one that is not recognized?
>
> Sure, the card that disappeared is:
>
> 0a:00.0 Fibre Channel: LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter (rev 02)

As far as I can tell the following is happening:
The root bus resource window (advertised by the bios?) is to small:
pci_bus 0000:00: root bus resource [bus 00-07]
Previously we didn't really care. There is a resource conflict but we
ignored it:
pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07]
(conflicts with (null) [bus 00-07])
With the patch we mark the bridge as broken and reassign the bus to 06:
pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
pci 0000:00:0e.0: PCI bridge to [bus 06-07]
pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
pci_bus 0000:06: busn_res: [bus 06-07] end is updated to 06

We still scan for children but nothing shows up ("PCI bridge to" is
from pci_scan_child_bus -> pcibios_fixup_bus -> pci_read_bridge_base,
after pci_scan_slot). I have no idea why the device does not respond.
