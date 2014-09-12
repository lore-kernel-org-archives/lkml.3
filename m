Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaILUih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:38:37 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52685 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaILUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <ghbnqkeh9k.fsf@quad.gouders.net>
References: <ghiol53r9u.fsf@lena.gouders.net> <CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
 <ghwq9k3m6z.fsf@lena.gouders.net> <CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
 <ghioku5l29.fsf@lena.gouders.net> <CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
 <CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
 <ghppf15236.fsf@quad.gouders.net> <CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
 <ghd2b1svdw.fsf@quad.gouders.net> <CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
 <ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net> <ghbnqkeh9k.fsf@quad.gouders.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 12 Sep 2014 14:38:12 -0600
Message-ID: <CAErSpo7knOrXNqimWXP0t7eGWYZhEhy1=i6358pBtk9Nd5RO8g@mail.gmail.com>
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

On Fri, Sep 12, 2014 at 2:05 PM, Dirk Gouders <dirk@gouders.net> wrote:
> ...
> Yinghai,
>
> I now applied your patches and tested them:
>
> echo 1 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable
> echo 0 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable
>
> The FC Adapter did not show up, this is the dmesg output (I also tested
> with 0b.0):
>
> [  143.294168] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 18
> [  148.284456] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 8
> [  304.065942] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 18
> [  309.035278] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 8
>
> So, probably my test environment does not work as expected and I have to
> test it on the failing machine.

I think you probably did reproduce the problem, it's just that it
wasn't fixed by bouncing the link.  What if you try the following:

    DEV=00:0a.0
    setpci -s$DEV BRIDGE_CONTROL.W=0x0040
    sleep 1
    setpci -s$DEV BRIDGE_CONTROL.W=0x0000
    sleep 1
    echo 1 > /sys/bus/pci/rescan

Thanks to your patch, we reconfigured the secondary bus number of
bridge 00:0a.0.  The commands above should reset the FC device behind
that bridge.  I suspect it will then respond when we rescan that bus.

Bjorn
