Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbaDVRah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:30:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52313 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489AbaDVRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:30:34 -0400
Message-ID: <5356A70A.5090907@zytor.com>
Date: Tue, 22 Apr 2014 10:29:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <amluto@gmail.com>
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
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>	<CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>	<a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com>	<CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>	<ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>	<CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>	<20140422112312.GB15882@pd.tnic>	<20140422144659.GF15882@pd.tnic>	<CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>	<53569467.1030809@zytor.com>	<CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>	<CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>	<CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>	<CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>	<CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com> <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com>
In-Reply-To: <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:19 AM, Linus Torvalds wrote:
> On Tue, Apr 22, 2014 at 10:11 AM, Andrew Lutomirski <amluto@gmail.com> wrote:
>>
>>>
>>> Anyway, if done correctly, this whole espfix should be totally free
>>> for normal processes, since it should only trigger if SS is a LDT
>>> entry (bit #2 set in the segment descriptor). So the normal fast-path
>>> should just have a simple test for that.
>>
>> How?  Doesn't something still need to check whether SS is funny before
>> doing iret?
> 
> Just test bit #2. Don't do anything else if it's clear, because you
> should be done. You don't need to do anything special if it's clear,
> because I don't *think* we have any 16-bit data segments in the GDT on
> x86-64.
> 

And we don't (neither do we on i386, and we depend on that invariance.)

Hence:

 irq_return:
+	/*
+	 * Are we returning to the LDT?  Note: in 64-bit mode
+	 * SS:RSP on the exception stack is always valid.
+	 */
+	testb $4,(SS-RIP)(%rsp)
+	jnz irq_return_ldt
+
+irq_return_iret:
 	INTERRUPT_RETURN
-	_ASM_EXTABLE(irq_return, bad_iret)
+	_ASM_EXTABLE(irq_return_iret, bad_iret)


That is the whole impact of the IRET path.

If using IST for #GP won't cause trouble (ISTs don't nest, so we need to
make sure there is absolutely no way we could end up nested) then the
rest of the fixup code can go away and we kill the common path
exception-handling overhead; the only new overhead is the IST
indirection for #GP, which isn't a performance-critical fault (good
thing, because untangling #GP faults is a major effort.)

	-hpa

