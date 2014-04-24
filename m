Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaDXWcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:32:16 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61233 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaDXWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <53598F2F.1030306@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com>
 <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com> <53598F2F.1030306@linux.intel.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Thu, 24 Apr 2014 15:31:54 -0700
Message-ID: <CAObL_7H0omGZTW2jRa+cZdaKM1y8z2Uh5mPZqW4AX4Qgea8Ydw@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: comex <comexk@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 3:24 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 04/23/2014 09:53 PM, Andrew Lutomirski wrote:
>>>
>>> - The user can put arbitrary data in registers before returning to the
>>> LDT in order to get it saved at a known address accessible from the
>>> kernel.  With SMAP and KASLR this might otherwise be difficult.
>>
>> For one thing, this only matters on Haswell.  Otherwise the user can
>> put arbitrary data in userspace.
>>
>> On Haswell, the HPET fixmap is currently a much simpler vector that
>> can do much the same thing, as long as you're willing to wait for the
>> HPET counter to contain some particular value.  I have patches that
>> will fix that as a side effect.
>>
>> Would it pay to randomize the location of the espfix area?  Another
>> somewhat silly idea is to add some random offset to the CPU number mod
>> NR_CPUS so that at attacker won't know which ministack is which.
>
> Since we store the espfix stack location explicitly, as long as the
> scrambling happens in the initialization code that's fine.  However, we
> don't want to reduce locality lest we massively blow up the memory
> requirements.

I was imagining just randomizing a couple of high bits so the whole
espfix area moves as a unit.

>
> We could XOR with a random constant with no penalty at all.  Only
> problem is that this happens early, so the entropy system is not yet
> available.  Fine if we have RDRAND, but...

How many people have SMAP and not RDRAND?  I think this is a complete
nonissue for non-SMAP systems.

>> Peter, is this idea completely nuts?  The only exceptions that can
>> happen there are NMI, MCE, #DB, #SS, and #GP.  The first four use IST,
>> so they won't double-fault.
>
> It is completely nuts, but sometimes completely nuts is actually useful.
>  It is more complexity, to be sure, but it doesn't seem completely out
> of the realm of reason, and avoids having to unwind the ministack except
> in the normally-fatal #DF handler.  #DFs are documented as not
> recoverable, but we might be able to do something here.
>
> The only real disadvantage I see is the need for more bookkeeping
> metadata.  Basically the bitmask in espfix_64.c now needs to turn into
> an array, plus we need a second percpu variable.  Given that if
> CONFIG_NR_CPUS=8192 the array has 128 entries I think we can survive that.

Doing something in #DF needs percpu data?  What am I missing?

--Andy
