Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422683AbaD3SbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:31:13 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37162 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbaD3SbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+96t-AgFj6cy1L1cOLM54nkiiWnpiqWgFemBaP80cR6Q@mail.gmail.com>
References: <53554CDA.1060806@mentor.com> <5357EABB.3070400@zytor.com>
 <5357F310.8090600@mentor.com> <CAGXu5jKqvmn++UvaYxnN+QRxezv9W4E64ZaAbfTvVJmmyi9L6Q@mail.gmail.com>
 <CALCETrXze8cL8yr82E8VzoSm59DD04SGNC5AxYj9mS4+M8-uPg@mail.gmail.com> <CAGXu5j+96t-AgFj6cy1L1cOLM54nkiiWnpiqWgFemBaP80cR6Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 30 Apr 2014 11:30:50 -0700
Message-ID: <CALCETrV3remZK=MgNH83rsgMfmikfGXZj0-x1z0v4MrNAy8=Hg@mail.gmail.com>
Subject: Re: randomized placement of x86_64 vdso
To: Kees Cook <keescook@google.com>
Cc: Nathan Lynch <Nathan_Lynch@mentor.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:13 AM, Kees Cook <keescook@google.com> wrote:
> On Wed, Apr 30, 2014 at 10:52 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Wed, Apr 30, 2014 at 10:47 AM, Kees Cook <keescook@google.com> wrote:
>>> On Wed, Apr 23, 2014 at 10:06 AM, Nathan Lynch <Nathan_Lynch@mentor.com> wrote:
>>>> On 04/23/2014 11:30 AM, H. Peter Anvin wrote:
>>>>> On 04/21/2014 09:52 AM, Nathan Lynch wrote:
>>>>>> Hi x86/vdso people,
>>>>>>
>>>>>> I've been working on adding a vDSO to 32-bit ARM, and Kees suggested I
>>>>>> look at x86_64's algorithm for placing the vDSO at a randomized offset
>>>>>> above the stack VMA.  I found that when the stack top occupies the
>>>>>> last slot in the PTE (is that the right term?), the vdso_addr routine
>>>>>> returns an address below mm->start_stack, equivalent to
>>>>>> (mm->start_stack & PAGE_MASK).  For instance if mm->start_stack is
>>>>>> 0x7fff3ffffc96, vdso_addr returns 0x7fff3ffff000.
>>>>>>
>>>>>> Since the address returned is always already occupied by the stack,
>>>>>> get_unmapped_area detects the collision and falls back to
>>>>>> vm_unmapped_area.  This results in the vdso being placed in the
>>>>>> address space next to libraries etc.  While this is generally
>>>>>> unnoticeable and doesn't break anything, it does mean that the vdso is
>>>>>> placed below the stack when there is actually room above the stack.
>>>>>> To me it also seems uncomfortably close to placing the vdso in the way
>>>>>> of downward expansion of the stack.
>>>>>>
>>>>>> I don't have a patch because I'm not sure what the algorithm should
>>>>>> be, but thought I would bring it up as vdso_addr doesn't seem to be
>>>>>> behaving as intended in all cases.
>>>>>>
>>>>>
>>>>> If the stack occupies the last possible page, how can you say there is
>>>>> "space above the stack"?
>>>>
>>>> Sorry for being unclear.  I probably am getting terminology wrong.  What
>>>> I'm trying to express is that if the stack top is in the last page of
>>>> its last-level page table (which may be the last possible page, but
>>>> that's not really the interesting case), vdso_addr returns an address
>>>> below mm->start_stack.
>>>
>>> It seems like this is avoidable, then? From your example, it seems
>>> like we lose the separated randomization in this case, but we don't
>>> need to? Do you have a suggestion for what could be done to fix this?
>>
>> I don't understand why the vDSO should be special here.  Either the
>> standard logic for randomizing the placement of DSOs is good, in which
>> case it should be good for the vDSO too, or I think we should fix it
>> for everything.
>
> The issue is specific to the vdso randomizing-near-the-stack code;
> regular mmap randomization is operating correctly. The reason for
> randomizing stack, vdso, and mmap separately is to avoid correlation
> of leaked offsets in one to the other regions.

I understand why the offset from the stack to the vDSO should be
randomized, and why the offset from the stack to, say, glibc should be
randomized.  What I don't get is why the offset from glibc to the vDSO
should be randomized but the offset from glibc to openssl should be
deterministic.  Or am I misunderstanding?

--Andy
