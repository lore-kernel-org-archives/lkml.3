Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaLSWFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:05:31 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:45683 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752650AbaLSWF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:05:29 -0500
Message-ID: <5494A0DF.10905@upv.es>
Date: Fri, 19 Dec 2014 23:04:15 +0100
From: Hector Marco <hecmargi@upv.es>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es> <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es> <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
In-Reply-To: <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



El 12/12/14 a las 18:17, Andy Lutomirski escribió:
> On Dec 12, 2014 8:33 AM, "Hector Marco" <hecmargi@upv.es> wrote:
>>
>> Hello,
>>
>> I agree. I don't think a new randomization mode will be needed, just fix
>> the current randomize_va_space=2. Said other way: fixing the offset2lib
>> will not break any current program and so, no need to add additional
>> configuration options. May be we shall wait for some inputs
>> from the list (may be we are missing something).
>>
>>
>> Regarding to VDSO, definitively, is not randomized enough in 64bits.
>> Brute force attacks would be pretty fast even from the network.
>> I have identified the bug and seems quite easy to fix it.
>>
>> On 32bit systems, this is not a issue because it is mapped in the
>> mmap area. In order to fix the VDSO on 64bit, the following
>> considerations shall
>> be discussed:
>>
>>
>> Performance:
>>      It seems (reading the kernel comments) that the random allocation
>>      algorithm tries to place the VDSO in the same PTE than the stack.
>
> The comment is wrong.  It means PTE table.
>
>>      But since the permissions of the stack and the VDSO are different
>>      it seems that are getting right the opposite.
>
> Permissions have page granularity, so this isn't a problem.
>
>>
>>      Effectively VDSO shall be correctly randomized because it contains
>>      enough useful exploitable stuff.
>>
>>      I think that the possible solution is follow the x86_32 approach
>>      which consist on map the VDSO in the mmap area.
>>
>>      It would be better fix VDSO in a different patch ? I can send a
>>      patch which fixes the VDSO on 64 bit.
>>
>
> What are the considerations for 64-bit memory layout?  I haven't
> touched it because I don't want to break userspace, but I don't know
> what to be careful about.
>
> --Andy

I don't think that mapping the VDSO in the mmap area breaks the
userspace. Actually, this is already happening with the current
implementation. You can see it by running:

setarch x86_64 -R cat /proc/self/maps


Do this break the userspace in some way ?


Regarding the solution to the offset2lib it seems that placing the
executable in a different memory region area could increase the
number of pages for the pages table (because it is more spread).
We should consider this before fixing the current implementation
(randomize_va_space=2).

I guess that the current implementation places the PIE executable in
the mmap base area jointly with the libraries in an attempt to reduce
the size of the page table.

Therefore, I can fix the current implementation (maintaining the
randomize_va_space=2) by moving the PIE executable from the mmap base
area to another one for x86*, ARM* and MIPS (as s390 and PowerPC do).
But we shall agree that this increment in the page table is not a
issue. Otherwise, the randomize_va_space=3 shall be considered.


Hector Marco.

>
>>
>>
>> Regards,
>> Hector Marco.
