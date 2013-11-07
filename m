Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3KGTC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:02:59 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50275 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3KGTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:02:55 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com>
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>
	<52603CD6.6080507@linux.intel.com>
	<CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com>
Date: Thu, 7 Nov 2013 11:02:53 -0800
Message-ID: <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com>
Subject: Re: Corrupted low memory in v3.9+
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 1:39 PM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Oct 17, 2013 at 12:39 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> On 10/17/2013 11:57 AM, Olof Johansson wrote:
>>>
>>> And the low memory checker never even ran before, since it had nothing
>>> to check. Earlier the lower reserved region would be included in the
>>> e820-reserved area if I read the code correctly, and now it's just
>>> marked reserved by the memblock code.
>>>
>>> I guess it could be argued either way whether this is a regression or
>>> not; but at the end of the day we now have systems where this warning
>>> pops when it didn't use to. :(
>>>
>>
>> I'm wondering if this is a problem with the low memory checker (the
>> residual value of which I have to admit to being skeptical of) or
>> something else.
>
> There's a chance that it's a valid trip of the low-memory checker,
> i.e. that we do have a bios (or more likely smm), that stomps on that
> memory -- it was never checked for in the past and definitely not
> warned about. I'm not sure if that was intentional behavior or not (to
> not check this area), I lack history on the topic.
>
>> Could you boot the box with "debug memblock=debug" and earlyprintk
>> turned on and send the boot output?
>
> Ah, yes, I did verify that the first 64K were indeed set aside as
> reserved by doing just that:
>
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x7c750000 reserved size = 0xb05000
> [    0.000000]  memory.cnt  = 0x6
> [    0.000000]  memory[0x0] [0x00000000010000-0x0000000009ffff], 0x90000 bytes
> [    0.000000]  memory[0x1] [0x00000000100000-0x00000000efffff], 0xe00000 bytes
> [    0.000000]  memory[0x2] [0x00000001000000-0x0000001fffffff],
> 0x1f000000 bytes
> [    0.000000]  memory[0x3] [0x00000020200000-0x0000003fffffff],
> 0x1fe00000 bytes
> [    0.000000]  memory[0x4] [0x00000040200000-0x0000007c6bffff],
> 0x3c4c0000 bytes
> [    0.000000]  memory[0x5] [0x00000100000000-0x000001005fffff], 0x600000 bytes
> [    0.000000]  reserved.cnt  = 0x2
> [    0.000000]  reserved[0x0] [0x0000000009f000-0x000000000fffff], 0x61000 bytes
> [    0.000000]  reserved[0x1] [0x00000001000000-0x00000001aa3fff],
> 0xaa4000 bytes
> [    0.000000] memblock_reserve: [0x00000000099000-0x0000000009f000]
> reserve_real_mode+0x61/0x87
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] reserving inaccessible SNB gfx pages
> [    0.000000] memblock_reserve: [0x00000000000000-0x00000000100000]
> setup_arch+0xa2d/0xa41
> [...]
>
> Unfortunately x86 doesn't keep the memblock structures around, so
> there's no way to verify after booting in debugfs, but based on the
> above it should have been reserved properly.

*prod*

So, got a preference on solution for this? The warning seems harmless
but still annoying to get used to ignoring false positives, etc.

Disable the low memory checker by default? Hide it behind a debug
option (runtime or build time)?


-Olof
