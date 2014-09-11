Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaIKUsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:48:17 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:42622 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaIKUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <ghppf15236.fsf@quad.gouders.net>
References: <ghiol53r9u.fsf@lena.gouders.net> <CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
 <ghwq9k3m6z.fsf@lena.gouders.net> <CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
 <ghioku5l29.fsf@lena.gouders.net> <CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
 <CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com> <ghppf15236.fsf@quad.gouders.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Sep 2014 14:42:47 -0600
Message-ID: <CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
To: Dirk Gouders <dirk@gouders.net>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 2:33 PM, Dirk Gouders <dirk@gouders.net> wrote:
> What I was currently trying was to construct a test-environment so that
> I do not need to do tests and diagnosis on a busy machine.
>
> I noticed that this problem seems to start with the narrow Root
> Bridge window (00-07) but every other machine that I had a look at,
> starts with (00-ff), so those will not trigger my problem.
>
> I thought I could perhaps try to shrink the window in
> acpi_pci_root_add() to trigger the problem and that kind of works: it
> triggers it but not exactly the same way, because it basically ends at
> this code in pci_scan_bridge():
>
>         if (max >= bus->busn_res.end) {
>                 dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
>                          max, &bus->busn_res, pass);
>                 goto out;
>         }
>
> If this could work but I am just missing a small detail, I would be
> glad to hear about it and do the first tests this way.  If it is
> complete nonsense, I will just use the machine that triggers the problem
> for the tests.

I was about to suggest the same thing.  If the problem is related to
the bus number change, we should be able to force that to happen on a
different machine.  Your approach sounds good, so I'm guessing we just
need a tweak.

I would first double-check that the PCI adapters are identical,
including the firmware on the card.  Can you also include your patch
and the resulting dmesg (with debug enabled as before)?

Is the test machine itself similar to the failing one?  Do they have
the same BIOS version?  From [1], it looks like you already have the
latest BIOS on the failing machine.  It's interesting that the notes
for your version mention "Fixed a PCI Bus Number re-allocation error."

Bjorn

[1] http://www.tyan.com/support_download_bios.aspx?model=B.VX50B4985-E
