Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbaDVRUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:20:48 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49569 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbaDVRUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <5356A248.5060605@zytor.com>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
 <5355A9E9.9070102@zytor.com> <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
 <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com> <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>
 <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
 <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic>
 <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
 <53569467.1030809@zytor.com> <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
 <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
 <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com> <5356A248.5060605@zytor.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 22 Apr 2014 10:20:23 -0700
Message-ID: <CAObL_7GTqixGjZZd2mtuTp+kpJ8uNtmiYUniTHnLd8=8Lj4m-w@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:09 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> As for Andy's questions:
>
>> What happens on the IST entries?  If I've read your patch right,
>> you're still switching back to the normal stack, which looks
>> questionable.
>
> No, in that case %rsp won't point into the espfix region, and the switch
> will be bypassed.  We will resume back into the espfix region on IRET,
> which is actually required e.g. if we take an NMI in the middle of the
> espfix setup.

Aha.  I misread that.  Would it be worth adding a comment along the lines of

/* Check whether we are running on the espfix stack.  This is
different from checking whether we faulted from the espfix stack,
since an ist exception will have switched us off of the espfix stack.
*/

>
>> Also, if you want to same some register abuse on each exception entry,
>> could you check the saved RIP instead of the current RSP?  I.e. use
>> the test instruction with offset(%rsp)?  Maybe there are multiple
>> possible values, though, and just testing some bits doesn't help.
>
> I don't see how that would work.

It won't, given the above.  I misunderstood what you were checking.

It still seems to me that only #GP needs this special handling.  The
IST entries should never run on the espfix stack, and #MC, #DB, #NM,
and #SS (I missed that one earlier) use IST.

Would it ever make sense to make #GP use IST as well?  That might
allow espfix_adjust_stack to be removed entirely.  I don't know how
much other fiddling would be needed to make that work.

--Andy
