Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaIVPXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:23:39 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57928 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaIVPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaWS+nxBM0gdLo0Qv3-x4fVwT0ePTr20miZvnpJUMgQ-NQ@mail.gmail.com>
References: <CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
 <gh4mwcef0r.fsf@quad.gouders.net> <CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
 <ghoaukcx6b.fsf@quad.gouders.net> <CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
 <ghk358crbe.fsf@quad.gouders.net> <CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
 <20140913040716.GA28080@google.com> <gh8ulnn9yo.fsf@quad.gouders.net>
 <gh8uln71g1.fsf@lena.gouders.net> <20140919183943.GD19374@google.com>
 <ghvboit9qt.fsf@lena.gouders.net> <CAErSpo4Z1s7u08W6o+8Yxu7-QYN6YS9zt11=hH535YFYAwVKNw@mail.gmail.com>
 <CAMxnaaWS+nxBM0gdLo0Qv3-x4fVwT0ePTr20miZvnpJUMgQ-NQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Sep 2014 09:23:14 -0600
Message-ID: <CAErSpo4ppHnpRZEY5Rw-y3J7wgQ61tBKn+iiqav13-m2tfdDcA@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Dirk Gouders <dirk@gouders.net>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 8:53 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Mon, Sep 22, 2014 at 4:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Sep 20, 2014 at 12:41 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>>
>>>> On Sat, Sep 13, 2014 at 09:41:34PM +0200, Dirk Gouders wrote:
>>>>> So, I did some tests on the VX50 which probably wasn't the worst idea,
>>>>> because it behaves different than the test machine.
>>>>>
>>>>> Summary:
>>>>>
>>>>> 1) Bjorn's back pocket patch works on the VX50.
>>>>>
>>>>>    On the test machine it causes a trace, mount_root has to do with
>>>>>    it.  I tried to use netconsole but it complained the interface were
>>>>>    not ready.
>>>>
>>>> OK, that's good.  I put this revert patch in for-linus for v3.17.  I regard
>>>> this as a temporary fix, not the real solution.  My guess is the test
>>>> machine doesn't boot because you're missing a driver, so not related to the
>>>> revert patch.
>>>
>>> I assumed my limit-host-bridge-aperture-and-ignore-bridges-patch on top
>>> of your patch caused this, so I took a closer look.
>>>
>>> Your patch works fine with current rc5+ on the test machine -- with and
>>> without my additional patch.
>>
>> Great, thanks for testing that!
>>
>>> Other various today's test results (VX50) will be appended to bugzilla
>>> in a few moments.
>>
>> The Windows Server 2008 boot shows that Windows reconfigures the
>> 00:0e.0 bridge so it fits inside the [bus 00-07] aperture reported by
>> the host bridge _CRS, and the LSI FC adapter is not enumerated at all.
>> That's basically the same behavior that prompted your bug report.
>> This suggests that Windows does *not* reset the secondary bus when
>> changing the bridge configuration.
>>
>> For v3.17, I reverted 1820ffdccb9b ("PCI: Make sure bus number
>> resources stay within their parents bounds").  For the future, I think
>> we should do a quirk to fix the _CRS, similar to what Andreas has
>> posted, and apply 1820ffdccb9b again.
>>
>> But I think the quirk should be specific to this system and BIOS.  I
>> don't want to add a workaround that silently covers up Linux and BIOS
>> bugs.  The reason amd_bus.c exists is because Linux was not smart
>> enough to pay attention to _CRS.  Linux is now pretty good at that, so
>> the reason for amd_bus.c is mostly gone.  I don't want to add new
>> dependencies on amd_bus.c that will prevent us from phasing it out.
> Why not always trust amd_bus over _CRS? Is there a scenario in which
> amd_bus is wrong?

amd_bus.c requires ongoing maintenance to keep it working for new
processors and topologies.  The ACPI description of the platform is
the one the OEM intended, and it's the one that is tested.  There are
cases where the ACPI description omits things that amd_bus.c would
find, e.g., when the BIOS reserves hardware that it doesn't want the
OS to touch.

> Are these methods (like _CRS) meant to set limits for us, or are they
> simply used to report the configuration decisions made by the BIOS? So
> if _CRS says that the window is [00-07] would it be ok for us to
> simply increase it (possibly after reprogramming the registers in
> amd_bus)?

_CRS tells us how a device is configured.  _PRS tells us what other
settings are possible.  _SRS chooses other settings.  If BIOS supplies
_PRS and _SRS, we can change the settings.  But I've never seen _PRS
and _SRS for host bridges, and Linux doesn't support them for host
bridges today.

It would not be OK for us to use amd_bus.c to reprogram registers.
The rest of ACPI assumes that the bridge is configured per _CRS, and
it assumes that any changes are done via _SRS.  For example, there
could be AML that uses those assumptions.

I don't think a hybrid ACPI + native solution is really viable.
One-off bug workarounds are fine, but in the long run, I think we're
better off if we work from the same system description that Windows
does.  Otherwise we'll continually trip over unexpected things.

Bjorn
