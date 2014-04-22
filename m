Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbaDVSAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:00:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52591 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbaDVSAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:00:12 -0400
Message-ID: <5356ADF9.5030401@zytor.com>
Date: Tue, 22 Apr 2014 10:59:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Lutomirski <amluto@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com> <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com> <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic> <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com> <53569467.1030809@zytor.com> <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com> <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com> <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com> <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com> <CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com> <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com> <5356A70A.5090907@zytor.com> <CAObL_7GJypym8JhUmdszDTKJVuLW9wSjbbZK4AZ3Jk304GK6tQ@mail.gmail.com>
In-Reply-To: <CAObL_7GJypym8JhUmdszDTKJVuLW9wSjbbZK4AZ3Jk304GK6tQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:46 AM, Andrew Lutomirski wrote:
>>
>> That is the whole impact of the IRET path.
>>
>> If using IST for #GP won't cause trouble (ISTs don't nest, so we need to
>> make sure there is absolutely no way we could end up nested) then the
>> rest of the fixup code can go away and we kill the common path
>> exception-handling overhead; the only new overhead is the IST
>> indirection for #GP, which isn't a performance-critical fault (good
>> thing, because untangling #GP faults is a major effort.)
> 
> I'd be a bit nervous about read_msr_safe and friends.  Also, what
> happens if userspace triggers a #GP and the signal stack setup causes
> a page fault?
> 

Yes, #GPs inside the kernel could be a real problem.  MSRs generally
don't trigger #SS.  The second scenario shouldn't be a problem, the #PF
will be delivered on the currently active stack.

On the other hand, doing the espfix fixup only for #GP might be an
alternative, as long as we can convince ourselves that it really is the
only fault that could possibly be delivered on the espfix path.

	-hpa


