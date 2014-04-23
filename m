Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaDWRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:25:57 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:41307 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaDWRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <5357F572.1030804@zytor.com>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
 <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
 <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic>
 <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
 <53569467.1030809@zytor.com> <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
 <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
 <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
 <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>
 <CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>
 <5356A3B6.5050901@zytor.com> <20140423105411.2e166dd8@alan.etchedpixels.co.uk>
 <5357E214.6050501@zytor.com> <CAObL_7FePDB5EtZNKSbkc19maR3pH31tZSK-k+mcaFrKttYN3w@mail.gmail.com>
 <5357F572.1030804@zytor.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Wed, 23 Apr 2014 10:25:34 -0700
Message-ID: <CAObL_7HN0S_zuqi=NSJARaV8HAQz=zQXAvBiE8QsiFQ0VxpO8Q@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Wed, Apr 23, 2014 at 10:16 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/23/2014 10:08 AM, Andrew Lutomirski wrote:
>>
>> The only way I can see to trigger the race is with sigreturn, but it's
>> still there.  Sigh.
>>
>
> I don't see why sigreturn needs to be involved... all you need is
> modify_ldt() on one CPU while the other is in the middle of an IRET
> return.  Small window, so hard to hit, but still.
>

If you set the flag as soon as anyone calls modify_ldt, before any
descriptor is installed, then I don't think this can happen.  But
there's still sigreturn, and I don't think this is worth all the
complexity to save a single branch on #GP.

>> 2. I've often pondered changing the way we return *to* CPL 0 to bypass
>> iret entirely.  It could be something like:
>>
>> SS
>> RSP
>> EFLAGS
>> CS
>> RIP
>>
>> push 16($rsp)
>> popfq [does this need to force rex.w somehow?]
>> ret $64
>
> When you say return to CPL 0 you mean intra-kernel return?  That isn't
> really the problem here, though.  I think this will also break the
> kernel debugger since it will have the wrong behavior for TF and RF.

I do mean intra-kernel.  And yes, this has nothing to do with espfix,
but it would make write_msr_safe fail more quickly :)

--Andy
