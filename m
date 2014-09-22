Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaIVOZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:25:45 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:38888 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaIVOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <ghvboit9qt.fsf@lena.gouders.net>
References: <CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
 <gh4mwcef0r.fsf@quad.gouders.net> <CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
 <ghoaukcx6b.fsf@quad.gouders.net> <CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
 <ghk358crbe.fsf@quad.gouders.net> <CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
 <20140913040716.GA28080@google.com> <gh8ulnn9yo.fsf@quad.gouders.net>
 <gh8uln71g1.fsf@lena.gouders.net> <20140919183943.GD19374@google.com> <ghvboit9qt.fsf@lena.gouders.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Sep 2014 08:25:19 -0600
Message-ID: <CAErSpo4Z1s7u08W6o+8Yxu7-QYN6YS9zt11=hH535YFYAwVKNw@mail.gmail.com>
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

On Sat, Sep 20, 2014 at 12:41 PM, Dirk Gouders <dirk@gouders.net> wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> On Sat, Sep 13, 2014 at 09:41:34PM +0200, Dirk Gouders wrote:
>>> So, I did some tests on the VX50 which probably wasn't the worst idea,
>>> because it behaves different than the test machine.
>>>
>>> Summary:
>>>
>>> 1) Bjorn's back pocket patch works on the VX50.
>>>
>>>    On the test machine it causes a trace, mount_root has to do with
>>>    it.  I tried to use netconsole but it complained the interface were
>>>    not ready.
>>
>> OK, that's good.  I put this revert patch in for-linus for v3.17.  I regard
>> this as a temporary fix, not the real solution.  My guess is the test
>> machine doesn't boot because you're missing a driver, so not related to the
>> revert patch.
>
> I assumed my limit-host-bridge-aperture-and-ignore-bridges-patch on top
> of your patch caused this, so I took a closer look.
>
> Your patch works fine with current rc5+ on the test machine -- with and
> without my additional patch.

Great, thanks for testing that!

> Other various today's test results (VX50) will be appended to bugzilla
> in a few moments.

The Windows Server 2008 boot shows that Windows reconfigures the
00:0e.0 bridge so it fits inside the [bus 00-07] aperture reported by
the host bridge _CRS, and the LSI FC adapter is not enumerated at all.
That's basically the same behavior that prompted your bug report.
This suggests that Windows does *not* reset the secondary bus when
changing the bridge configuration.

For v3.17, I reverted 1820ffdccb9b ("PCI: Make sure bus number
resources stay within their parents bounds").  For the future, I think
we should do a quirk to fix the _CRS, similar to what Andreas has
posted, and apply 1820ffdccb9b again.

But I think the quirk should be specific to this system and BIOS.  I
don't want to add a workaround that silently covers up Linux and BIOS
bugs.  The reason amd_bus.c exists is because Linux was not smart
enough to pay attention to _CRS.  Linux is now pretty good at that, so
the reason for amd_bus.c is mostly gone.  I don't want to add new
dependencies on amd_bus.c that will prevent us from phasing it out.

Bjorn
