Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3BNJwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:52:25 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63171 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab3BNJwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <1360825669.1727.337.camel@jesse>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<1360810114.1727.306.camel@jesse>
	<CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
	<1360825669.1727.337.camel@jesse>
Date: Thu, 14 Feb 2013 18:52:20 +0900
Message-ID: <CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to
 support fat_fallocate())
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Bartlett <abartlet@samba.org>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
>> >
>> > Thanks,
>> Hi Andrew.
>>
>> First, Thanks for your interest !
>> A mismatch between inode size and reserved blocks can be either due to
>> pre-allocation (after our changes) or due to corruption (sudden unplug
>> of media etc).
>> We don’t think it is right to include only read only support (i.e.
>> without fallocate support) for such files because if such files are
>> encountered it only means that the file is corrupted, as there is no
>> current method to check if the issue is due to pre-allocation.
>> If it is to be included in the kernel, then the whole patch has to go
>> in.
>
> I don't see why that is the case.
If we consider that there is no FALLOCATE support, then the condition
of file size and blocks not matching can be only possible in case of
corruption, right?

>
>> But then again, since the FAT specifications do not accommodate
>> for pre-allocation, then it is up to OGAWA to decide if this is
>> acceptable.
>> In any case, the patch will definitely break backward compatibility
>> (on an older fat driver without fallocate support) and also in case
>> for the two variants for the same kernel versions and only one has
>> FALLOCATE enabled, in such cases also, the behavior will assume
>> corruption in one case.
>
> I agree that the sudden unplug is a concern, but why not make the
> filesystem more robust against that inevitable occurrence?  If the
> blocks appear to be allocated to the file, why not use them?
We also agree that there should be pre-allocation feature on FAT, and
we had shared the scenarios where this could be required for a TV/
recorder.
But there are certain drawbacks which were raised by OGAWA with
respect to compatibility and we also tend to agree on them.
There could possibly be an issue where we are unable to distinguish
between pre-allocation and corruption. Perhaps we could set a status
bit on the file to indicate whether the file has pre-allocated blocks.
This will make it clear whether the allocation is genuine through the
FAT Fallocate request or is a result of corruption. Depending on the
status of the flag - the decision can be made regard to reading
blocks.
But, the main issue in this will be storing this bit in on-disk
directory entry for that file. From the feature and usability point of
view, we should have fallocate on FAT too.

But it needs initial ACK from OGAWA to continue to work on this so
that we can figure out the proper solution to move forward.
>
> That is, while it is hard to predict the many different ways a
> filesystem can be corrupted, what would go wrong if we did use these
> clusters?  Do you fear that they might also be allocated to someone
> else?
>
> That would, if I understand correctly just mean that that more broken,
> not quite valid USB thumb drives and other FAT filesystems work equally
> well on Windows and Linux, without administrative privileges.  (Given
> that running fsck requires root, and isn't trivially available to normal
> users in Linux, and I presume is similarly privileged in windows).
>
> What I'm doing is suggesting re-purposing your patch, from preallocation
> to robustness.  In this light, do you think this worth pushing forward?
The patch’s main aim was to reserve space. If the work that you
propose only aims to enable reads in case of corrupt files using size
mismatch as a criteria, then we think it would not be a good idea.

Thanks :-)
>
> We can later address if there is any safe way to preallocate files on
> FAT as a different question, hoping that this means it will 'just work'
> on a broader range of other Linux hosts, just as it is claimed to 'just
> work' on Windows.
>
> Thanks,
>
> Andrew Bartlett
>
> --
> Andrew Bartlett                                http://samba.org/~abartlet/
> Authentication Developer, Samba Team           http://samba.org
>
>
>
