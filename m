Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3BGGjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:39:42 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:50006 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3BGGje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:39:34 -0500
MIME-Version: 1.0
In-Reply-To: <1360214087.12062.21@driftwood>
References: <tip-2cde8ae169982ad1d1023ac628bb54053d0e9d4d@git.kernel.org>
	<1360214087.12062.21@driftwood>
Date: Wed, 6 Feb 2013 22:39:32 -0800
X-Google-Sender-Auth: HYn6ANJHr3CJk5fp7uHqYZH9b40
Message-ID: <CAE9FiQV9cAjH1b3rJvFqDaiaEiXaaiG50-Ap_tcvTMb_GV6o2w@mail.gmail.com>
Subject: Re: [tip:x86/mm2] x86: Add Crash kernel low reservation
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Landley <rob@landley.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 9:14 PM, Rob Landley <rob@landley.net> wrote:
> Yeah yeah, I'm behind on email...
>
>
> On 01/29/2013 07:51:25 PM, tip-bot for Yinghai Lu wrote:
>>
>> Commit-ID:  2cde8ae169982ad1d1023ac628bb54053d0e9d4d
>> Gitweb:
>> http://git.kernel.org/tip/2cde8ae169982ad1d1023ac628bb54053d0e9d4d
>> Author:     Yinghai Lu <yinghai@kernel.org>
>> AuthorDate: Thu, 24 Jan 2013 12:20:11 -0800
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Tue, 29 Jan 2013 15:31:59 -0800
>>
>> x86: Add Crash kernel low reservation
>>
>> During kdump kernel's booting stage, it need to find low ram for
>> swiotlb buffer when system does not support intel iommu/dmar remapping.
>>
>> kexed-tools is appending memmap=exactmap and range from /proc/iomem
>> with "Crash kernel", and that range is above 4G for 64bit after boot
>> protocol 2.12.
>>
>> We need to add another range in /proc/iomem like "Crash kernel low",
>> so kexec-tools could find that info and append to kdump kernel
>> command line.
>>
>> User could specify the size with crashkernel_low=XX[KMG].
>>
>> -v2: fix warning that is found by Fengguang's test robot.
>> -v3: move out get_mem_size change to another patch, to solve compiling
>>      warning that is found by Borislav Petkov <bp@alien8.de>
>> -v4: user must specify crashkernel_low if system does not support
>>      intel or amd iommu.
>
>
> I missed: why can we not autodetect the lack of support and DTRT?

We need to process crashkernel early, and at that time we can not find out if
we can get iommu initialized properly.

>
>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Link:
>> http://lkml.kernel.org/r/1359058816-7615-31-git-send-email-yinghai@kernel.org
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Rob Landley <rob@landley.net>
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> ---
>>  Documentation/kernel-parameters.txt |  3 +++
>>  arch/x86/kernel/setup.c             | 42
>> +++++++++++++++++++++++++++++++++++--
>>  include/linux/kexec.h               |  3 +++
>>  kernel/kexec.c                      | 34 +++++++++++++++++++++++++-----
>>  4 files changed, 75 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt
>> b/Documentation/kernel-parameters.txt
>> index 363e348..da0e077 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -594,6 +594,9 @@ bytes respectively. Such letter suffixes can also be
>> entirely omitted.
>>                         is selected automatically. Check
>>                         Documentation/kdump/kdump.txt for further details.
>>
>> +       crashkernel_low=size[KMG]
>> +                       [KNL, x86] parts under 4G.
>> +
>>         crashkernel=range1:size1[,range2:size2,...][@offset]
>>                         [KNL] Same as above, but depends on the memory
>>                         in the running system. The syntax of range is
>
>
> I don't understand this documentation.

Looks better if crashkernel_low is moved under crashkernel.

>
> The "parts under 4G." assumes you understand the context of this posting
> which isn't going into the docs. Above you say:
>
>
>> Try to reserve some under 4G if the normal "Crash kernel" is above 4G.
>
>
> Which is much clearer. Adding this in the middle also makes the "Same as
> above" slightly confusing (you have two different aboves...)
>
> The first version (crashkernel=onesize) strongly implies the reservation is
> physically contiguous. The comma separated version implies that there are
> discontiguous reservations, manually specified.
>
> So is crashkernel_low=size a separate reservation from crashkernel=size, or
> a modifier on the existing contiguous allocation? Do you still need a
> crashkernel= entry if you've got a crashkernel_low= entry? If you can (or
> are required to) specify both, is one a constraint on part of the other or
> it an addition (so it reserves crashkernel+crashkernel_low)? I seems
> unlikely "parts under 4G" means it's trying to make one contiguous
> reservation straddle the high/low boundary to put parts in each while still
> being contiguous...
>
> I have no idea from what you've added to kernel-parameters.txt.
>
> Looking at the code, I _think_ this adds an additional independent
> reservation. I.E. crashkernel=size says "allocate memory from anywhere",
> crashkernel_low=size says "allocate memory from low memory", and doing both
> allocates two chunks like the comma separated version.

comma separated version only allocate one piece, right?

The syntax is:

    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end]

    'start' is inclusive and 'end' is exclusive.

For example:

    crashkernel=512M-2G:64M,2G-:128M

This would mean:

    1) if the RAM is smaller than 512M, then don't reserve anything
       (this is the "rescue" case)
    2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
    3) if the RAM size is larger than 2G, then reserve 128M

>
> Oh well. It's not hugely important that I understand a subsystem I don't
> use, but having to look at the code to figure out what the documentation is
> saying makes me uncomfortable.

logic for crashkernel_low, if crashkernel allocate above 4G, and will continue
allocate ram under 4G as user specified with crashkernel_low.

Yinghai
