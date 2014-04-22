Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394AbaDVRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:10:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52096 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbaDVRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:10:24 -0400
Message-ID: <5356A248.5060605@zytor.com>
Date: Tue, 22 Apr 2014 10:09:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Lutomirski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com> <5355A9E9.9070102@zytor.com> <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com> <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com> <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com> <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com> <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com> <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic> <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com> <53569467.1030809@zytor.com> <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com> <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com> <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
In-Reply-To: <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:00 AM, Andrew Lutomirski wrote:
>>
>> Yes, you can very much trigger GP deliberately.
>>
>> The way to do it is to just make an invalid segment descriptor on the
>> iret stack. Or make it a valid 16-bit one, but make it a code segment
>> for the stack pointer, or read-only, or whatever. All of which is
>> trivial to do with a sigretun system call. But you can do it other
>> ways too - enter with a SS that is valid, but do a load_ldt() system
>> call that makes it invalid, so that by the time you exit it is no
>> longer valid etc.
>>
>> There's a reason we mark that "iretq" as taking faults with that
>>
>>         _ASM_EXTABLE(native_iret, bad_iret)
>>
>> and that "bad_iret" creates a GP fault.
>>
>> And that's a lot of kernel stack. The whole initial GP fault path,
>> which goes to the C code that finds the exception table etc. See
>> do_general_protection_fault() and fixup_exception().
> 
> My point is that it may be safe to remove the special espfix fixup
> from #PF, which is probably the most performance-critical piece here,
> aside from iret itself.
> 

It *might* even be plausible to do full manual sanitization, so that the
IRET cannot fault, but I have to admit to that being somewhat daunting,
especially given the thread/process distinction.  I wasn't actually sure
about the status of the LDT on the thread vs process scale (the GDT is
per-CPU, but has some entries that are context-switched per *thread*,
but I hadn't looked at the LDT recently.)

As for Andy's questions:

> What happens on the IST entries?  If I've read your patch right,
> you're still switching back to the normal stack, which looks
> questionable.

No, in that case %rsp won't point into the espfix region, and the switch
will be bypassed.  We will resume back into the espfix region on IRET,
which is actually required e.g. if we take an NMI in the middle of the
espfix setup.

> Also, if you want to same some register abuse on each exception entry,
> could you check the saved RIP instead of the current RSP?  I.e. use
> the test instruction with offset(%rsp)?  Maybe there are multiple
> possible values, though, and just testing some bits doesn't help.

I don't see how that would work.

	-hpa

