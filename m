Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309Ab3DGBq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 21:46:26 -0400
Received: from blu0-omc1-s32.blu0.hotmail.com ([65.55.116.43]:47230 "EHLO
	blu0-omc1-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161183Ab3DGBqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 21:46:25 -0400
X-EIP: [bA4addESVgfbatQHhDR/JaCLdS0dK/UP]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP12E3F71748F21FF468EF5D97C40@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.bottomley@HansenPartnership.com>
In-Reply-To: <ab03985d-3cce-4fdf-94c0-286b2d97c81d@email.android.com>
Subject: Re: [PATCH] Add non-zero module sections to sysfs
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike> <87wqsgjm6i.fsf@rustcorp.com.au> <1365245524.4298.14.camel@dabdike.spectrum.wifi> <BLU0-SMTP23C8D54498C7DFACDF083B97DB0@phx.gbl> <ab03985d-3cce-4fdf-94c0-286b2d97c81d@email.android.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 6 Apr 2013 21:45:43 -0400
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org,
        corbet@lwn.net
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 07 Apr 2013 01:46:23.0208 (UTC) FILETIME=[B5843E80:01CE3331]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6-Apr-13, at 9:22 PM, James Bottomley wrote:

>
>
> John David Anglin <dave.anglin@bell.net> wrote:
>
>> On 6-Apr-13, at 6:52 AM, James Bottomley wrote:
>>
>>> On Sat, 2013-04-06 at 15:22 +1030, Rusty Russell wrote:
>>>>> The problem is our assumption that section names be unique.  This
>>>>> assumption is wrong.  The ELF spec says (version 1.1 page 1-15):
>> "An
>>>>> object file may have more than one section with the same name."
>>>>> We need
>>>>> to fix the kernel not to rely on a bogus assumption ... but we had
>>
>>>>> no
>>>>> idea how to do that in a way that preserved the backwards
>>>>> compatibility
>>>>> of sections subdirectory.
>>>>>
>>>>> I admit that 35dead4235e2b67da7275b4122fed37099c2f462 is a hack,
>>>>> but now
>>>>> the problem has got attention, can we fix it properly?
>>>>
>>>> Yep.  The original patch didn't go through me, or we would have had
>>
>>>> this
>>>> discussion back then...
>>>>
>>>> The use of section names in sysfs goes back to one Mr. Corbet.  Why
>>
>>>> did
>>>> he do it that way?  Because gdb's add-symbol-file makes the same
>>>> assumption.  So if we fixed the sysfs somehow, it still wouldn't be
>>>> useful, since there's no way to tell gdb :(
>>>>
>>>> The real answer don't use -ffunction-sections on modules: probably
>>>> not
>>>> as important as the rest of the kernel.  And the new shiny is
>>>> -flto anyway.
>>>>
>>>> And that leaves us with a PA-RISC specific issue, for which we
>> should
>>>> move the fix to PA-RISC.
>>>>
>>>> Thoughts?
>>>
>>> Well, we don't have much of a choice.  Our ELF stub jump on 32 bits
>>> is a
>>> PCREL17.  That means once a module size is over 128k there's a
>>> chance we
>>> might not be able to link it because the jump is too big for the
>>> instruction.  IPV6 is one such big module today, but I'm sure there
>>> are
>>> others.  The only way I know to fix this is to allow the linker to
>>> insert stubs between functions, so we only fail at linking if a
>> single
>>> function is >128k big.  The way to do this is -ffunction-sections,
>>> unless there's something else we could do (all we really need is a
>> way
>>> to ensure we can insert ELF stubs every 128k).
>>
>> There is now a config work around for this.  See:
>> http://www.spinics.net/lists/linux-parisc/msg04521.html
>
> The longcalls config option only works on pa2 doesn't it? Although  
> we could just deprecate pa1.


No, it works on pa1.1 but the calls are more efficient on pa2.  On  
linux with a flat space, they should be
about the same in terms of instruction count.  On HP-UX, an additional  
space register load is needed.
For calls within the same space, the be instruction is pretty  
efficient but we never implemented linker
support for it in binutils.  If I recall correctly, it works if the  
call is local to a module but not for global calls.
It does work in HP-UX.

Dave
--
John David Anglin	dave.anglin@bell.net



