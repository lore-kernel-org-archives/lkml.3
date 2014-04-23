Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaDWGZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:25:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60545 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbaDWGZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:25:01 -0400
Message-ID: <53575C84.6080801@zytor.com>
Date: Tue, 22 Apr 2014 23:24:04 -0700
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
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>	<5355A9E9.9070102@zytor.com>	<CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>	<1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com>	<CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>	<a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com>	<CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>	<ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>	<CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>	<20140422112312.GB15882@pd.tnic>	<20140422144659.GF15882@pd.tnic>	<CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>	<53569467.1030809@zytor.com>	<CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>	<CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>	<CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com> <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gma!
 il.com>
In-Reply-To: <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:04 AM, Linus Torvalds wrote:
>
> The segment table is shared for a process. So you can have one thread
> doing a load_ldt() that invalidates a segment, while another thread is
> busy taking a page fault. The segment was valid at page fault time and
> is saved on the kernel stack, but by the time the page fault returns,
> it is no longer valid and the iretq will fault.
>
> Anyway, if done correctly, this whole espfix should be totally free
> for normal processes, since it should only trigger if SS is a LDT
> entry (bit #2 set in the segment descriptor). So the normal fast-path
> should just have a simple test for that.
>
> And if you have a SS that is a descriptor in the LDT, nobody cares
> about performance any more.
>

I just realized that with the LDT being a process-level object (unlike 
the GDT), we need to remove the filtering on the espfix hack, both for 
32-bit and 64-bit kernels.  Otherwise there is a race condition between 
executing the LAR instruction in the filter and the IRET, which could 
allow the leak to become manifest.

The "good" part is that I think the espfix hack is harmless even with a 
32/64-bit stack segment, although it has a substantial performance penalty.

Does anyone have any idea if there is a real use case for non-16-bit LDT 
segments used as the stack segment?  Does Wine use anything like that?

Very old NPTL Linux binaries use LDT segments, but only for data segments.

	-hpa


