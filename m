Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3A2TLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:11:31 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:46871 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3A2TL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
	<CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
	<CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
	<CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
Date: Tue, 29 Jan 2013 12:11:28 -0700
Message-ID: <CAKocOOPsvh=jOXLahe6ukjpyjOOqt9tRdwELxv8i0_Vi1xqQkA@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 6:05 AM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> I was out sick for a few days and finally picked this bisect backup
>> again. I started at 3.7 tag instead of 3.8-rc1 that I did in the past
>> and also did bisect at drivers/gpu/drm/radeon instead. Here are the
>> results:
>>
>> 6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
>> commit 6253e4c75d96006c06b9ac8f417eba873de2497b
>> Author: Alex Deucher <alexander.deucher@amd.com>
>> Date:   Wed Dec 12 14:30:32 2012 -0500
>>
>>     drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
>>
>>     Along the same lines of what was done for evergreen+
>>     in the last kernel.
>>
>>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>
>> git bisect log attached.
>>
>
> Try the attached patch.  I think it should fix the issue.  I just applied a similar patch for newer asics.
>
> Alex
>

I reverted 6253e4c75d96006c06b9ac8f417eba873de2497b and DMAR faults
went away. Undid the revert and applied your new patch. DMAR faults
are back again.


[   25.158653] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   25.158715] radeon 0000:01:00.0: WB enabled
[   25.158719] radeon 0000:01:00.0: fence driver on ring 0 use gpu
addr 0x0000000008000c00 and cpu addr 0xffff88002f143c00
[   25.158721] radeon 0000:01:00.0: fence driver on ring 3 use gpu
addr 0x0000000008000c0c and cpu addr 0xffff88002f143c0c

A few observations and questions about r600_startup() code sequence:

I notice DMAR faults right after

[drm] Loading RV620 Microcode message which is from
r600_init_microcode(). This routine does a series of
request_firmware() calls. btw. don't see release_firmware() calls in
regular code path, only from error legs in r600_init_microcode().

However, this routine doesn't do any loading yet. When this routine
returns, I am assuming request_firmware() step isn't complete yet
based on my reading request_firmware() interface. At this point
r600_startup() keeps chugging along, and does r600_mc_program() which
in turn calls rv515_mc_stop() which was changed with the
6253e4c75d96006c06b9ac8f417eba873de2497b commit.

I am thinking the changes somehow eliminated a wait or delay that used
be there for request_firmware() step to complete (?)

I can see from dmesg that the faults occur right after:

r600_init_microcode(rdev);

and stop before r600_pcie_gart_enable()

-- Shuah
