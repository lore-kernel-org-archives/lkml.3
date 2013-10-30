Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3J3QXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:23:51 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54942 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3J3QXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <5270C47C.5040206@intel.com>
References: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
 <1381493941-4650-6-git-send-email-tianyu.lan@intel.com> <20131016235541.GD17866@google.com>
 <525F7F0F.5010306@intel.com> <CAErSpo7P+n5c2uUoodT=LOjE3UH3LBcjifbj8reXzAeWydsoLA@mail.gmail.com>
 <52612D1C.4070701@intel.com> <20131023223904.GA18454@google.com>
 <526BF37E.8040801@intel.com> <CAErSpo50_JQEhGOK6mcnaj36f6Fhgp3VcHKSmziC6JB_Ycu0Xg@mail.gmail.com>
 <5270C47C.5040206@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 Oct 2013 10:23:26 -0600
Message-ID: <CAErSpo5ye_Y=b7476cFuDi7-hW4bJzm+D99cTek+wNkWefs4DQ@mail.gmail.com>
Subject: Re: [Resend PATCH 5/5] IA64/PCI/ACPI: Rework PCI root bridge ACPI
 resource conversion
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Yoknis, Mike" <mike.yoknis@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 2:34 AM, Lan Tianyu <tianyu.lan@intel.com> wrote:
> On 2013年10月29日 01:32, Bjorn Helgaas wrote:
>>
>> On Sat, Oct 26, 2013 at 10:53 AM, Lan Tianyu <tianyu.lan@intel.com> wrote:
>>>
>>> On 10/24/2013 06:39 AM, Bjorn Helgaas wrote:
>>>>
>>>> On Fri, Oct 18, 2013 at 08:44:12PM +0800, Lan Tianyu wrote:
>>>>>
>>>>>
>>>>> On 10/18/2013 04:33 AM, Bjorn Helgaas wrote:
>>
>>
>>>>>> I wonder if it would make sense to make
>>>>>> acpi_dev_resource_address_space() ignore addr.translation_offset for
>>>>>> IO resources.  Or maybe ignore it if the _TTP (type translation) bit
>>>>>> is set?
>>>>>
>>>>>
>>>>>
>>>>> I wonder why current code doesn't check _TTP? The code in the
>>>>> add_io_space() seems to think _TTP is always set, right?
>>>>
>>>>
>>>> I think it's an oversight, and you should fix it.  I suggest that you
>>>> ignore the _TRA value when _TTP is set.  Obviously this only applies
>>>> to I/O port resources, since _TTP is only defined in the I/O Resource
>>>> Flag (Table 6-185 in ACPI 5.0 spec).
>>>
>>>
>>> _TTP is also defined in the Memory Resource flag, Please have a look at
>>> Table 6-184 in the ACPI 5.0 Spec.
>>
>>
>> Yes, you're right.  That would be for a host bridge that converts I/O
>> on the primary (upstream) side of the bridge to memory on the PCI
>> side.  I've never seen such a bridge, and I can't really imagine why
>> anybody would do that.  But I guess you should be able to safely
>> ignore _TRA when _TTP is set in either a MEM or IO descriptor, because
>> the same reasoning should apply to both.
>>
>>> I am not sure how to deal with _TTP unsetting io resource? _TTP unsetting
>>> mean the resource is IO on the primary side and also IO on the secondary
>>> side.
>>
>>
>> If _TTP is not set, I guess you would apply _TRA.  That's what you
>> already do for MEM descriptors, and think you should just do the same
>> for IO descriptors.  I would guess that having _TTP = 0 and _TRA != 0
>> is rare for IO descriptors, but I suppose it could happen.
>
>
> Yes, my concern is for the IO resource case of _TTP=0 and _TRA !=0. The
> only reason for this case I think of is that the IO resource offsets on
> the prime bus and second bus are different. In this case, we still need
> to pass _TRA to new_space() and the finial resource->start still should be
> acpi_resource->min + offset returned by add_io_space(), right?

No, I don't think so.  If the "phys_base" argument to new_space() is
non-zero, it is the base of an MMIO region that needs to be
ioremapped.  This is handling the _TTP=1 case, where the MMIO region
is translated by the bridge into an IO region on PCI.

If _TTP=0, the region is IO on both the upstream and downstream sides
of the host bridge, and we don't want to ioremap a new MMIO region for
it.  It might be part of the "legacy I/O port space," but that's
already covered elsewhere.

I don't think we need to add special handling for the _TTP=0 and _TRA
!= 0 case because I don't think it exists in the field.  If and when
it *does* exist, we'll know what to do.  In the meantime, it should
look just like the MEM path.

> If yes, I think _TRA can't be applied to IO resource in the
> acpi_dev_resource_address_space() regardless of the value of _TTP.
>
> BTW, Translation Sparse(_TRS) is only meaningful if _TTP is set.(Table
> 6-185). The add_io_space() doesn't check _TTP when set sparse. So this
> should be corrected?

Sure, I'm OK with this.  It's possible we could trip over a BIOS bug
where _TRS=1 but _TTP=0, but I think the risk is low because only
large ia64 boxes would use this, and there aren't very many of those.

Bjorn
