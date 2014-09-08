Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaIHTkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:40:04 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51849 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaIHTkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:40:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140908180357.GA6159@obsidianresearch.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
 <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com> <20140908180357.GA6159@obsidianresearch.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Sep 2014 13:39:40 -0600
Message-ID: <CAErSpo7QQMRFKSk4vQCkDeEQQXX87Gq5YAKR+P4bxxcqMSJeDw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[-cc Mike's old email address]

On Mon, Sep 8, 2014 at 12:03 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Sep 08, 2014 at 10:36:36AM -0600, Bjorn Helgaas wrote:
>
>> Presumably these devices have PCI BARs (since that's how dev->resource
>> got filled in), and we want to somehow ignore them, not assign
>> resources to them, and not allow drivers to use whatever is mapped by
>> the BARs.  But clearing out the struct resources isn't really safe by
>> itself.  The hardware BAR still contains some value, and may still be
>> enabled, which means that it may conflict with other devices.
>
> I've seen this pattern before in the old mvebu stuff.
>
> Essentially for that case the mvebu HW is a repurposed end port core,
> so when working as a root port it presents an end port config space
> (not a root port bridge config space). The BAR in that config space is
> not relevant, so the old mvebu used code like this to hide it from the
> PCI core. Otherwise the core will try to program it from the aperture,
> and the default BAR size is really big, so it runs out of space.

How does mvebu deal with this now?  I don't see anything similar in pci-mvebu.c.

If the BAR is still a functioning PCI BAR, i.e., it decodes address
space and potentially responds to accesses there, we really should pay
attention to it.  That doesn't mean we have to assign space to it, but
for example, we might want to make sure we have PCI_COMMAND_MEM turned
off.  If we just clear out the resource start/end/flags, the PCI core
doesn't have enough information to do that.

Bjorn
