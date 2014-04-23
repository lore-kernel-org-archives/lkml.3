Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbaDWPzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:55:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbaDWPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:54:58 -0400
Message-ID: <5357E214.6050501@zytor.com>
Date: Wed, 23 Apr 2014 08:53:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Andrew Lutomirski <amluto@gmail.com>,
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
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>	<CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>	<a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com>	<CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>	<ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com>	<CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>	<20140422112312.GB15882@pd.tnic>	<20140422144659.GF15882@pd.tnic>	<CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>	<53569467.1030809@zytor.com>	<CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>	<CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>	<CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>	<CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>	<CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>	<5356A3B6.5050901@zytor.com> <20140423105411.2e166dd8@alan.etchedpixels.co.uk>
In-Reply-To: <20140423105411.2e166dd8@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 02:54 AM, One Thousand Gnomes wrote:
>> Ideally the tests should be doable such that on a normal machine the
>> tests can be overlapped with the other things we have to do on that
>> path.  The exit branch will be strongly predicted in the negative
>> direction, so it shouldn't be a significant problem.
>>
>> Again, this is not the case in the current prototype.
> 
> Or you make sure that you switch to those code paths only after software
> has executed syscalls that make it possible it will use a 16bit ss. 
> 

Which, again, would introduce a race, I believe, at least if we have an
LDT at all (and since we only enter these code paths for LDT descriptors
in the first place, it is equivalent to the current code minus the filters.)

> The other question I have is - is there any reason we can't fix up the
> IRET to do a 32bit return into a vsyscall type userspace page which then
> does a long jump or retf to the right place ?

I did a writeup on this a while ago.  It does have the problem that you
need additional memory in userspace, which is per-thread and in the
right region of userspace; this pretty much means you have to muck about
with the user space stack when user space is running in weird modes.
This gets complex very quickly and does have some "footprint".
Furthermore, on some CPUs (not including any recent Intel CPUs) there is
still a way to leak bits [63:32].  I believe the in-kernel solution is
actually simpler.

	-hpa


