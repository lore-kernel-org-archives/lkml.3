Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaDVSRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:17:33 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:65521 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDVSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <5356AF9F.4010301@zytor.com>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
	<ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>
	<CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
	<20140422112312.GB15882@pd.tnic>
	<20140422144659.GF15882@pd.tnic>
	<CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
	<53569467.1030809@zytor.com>
	<CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
	<CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
	<CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
	<CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>
	<CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>
	<CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com>
	<5356A70A.5090907@zytor.com>
	<CAObL_7GJypym8JhUmdszDTKJVuLW9wSjbbZK4AZ3Jk304GK6tQ@mail.gmail.com>
	<CAMzpN2hpX=XHFrTKxV1hsngNX4Pmuh9FxjAqeSeQHhEBKza1DA@mail.gmail.com>
	<5356AF9F.4010301@zytor.com>
Date: Tue, 22 Apr 2014 14:17:29 -0400
Message-ID: <CAMzpN2gkCPZoAKCgXa8tNZYFCuiPd6GWg9yhTBSSA=F43WLv1A@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Lutomirski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/22/2014 11:03 AM, Brian Gerst wrote:
>>
>> Maybe make the #GP handler check what the previous stack was at the start:
>> 1) If we came from userspace, switch to the top of the process stack.
>> 2) If the previous stack was not the espfix stack, switch back to that stack.
>> 3) Switch to the top of the process stack (espfix case)
>>
>> This leaves the IST available for any recursive faults.
>>
>
> Do you actually know what the IST is?  If so, you should realize the
> above is nonsense.
>
> The *hardware* switches stack on an exception; if the vector is set up
> as an IST, then we *always* switch to the IST stack, unconditionally.
> If the vector is not, then we switch to the process stack if we came
> from userspace.
>
> That is the entry condition that we have to deal with.  The fact that
> the switch to the IST is unconditional is what makes ISTs hard to deal with.

Right, that is why you switch away from the IST as soon as possible,
copying the data that is already pushed there to another stack so it
won't be overwritten by a recursive fault.
