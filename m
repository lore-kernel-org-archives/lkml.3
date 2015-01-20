Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbbATKun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:50:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbbATKuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:50:37 -0500
Message-ID: <54BE32D2.90301@redhat.com>
Date: Tue, 20 Jan 2015 05:49:54 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Oleg Nesterov <oleg@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fabian Frederick <fabf@skynet.be>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] init/main.c: Simplify initcall_blacklisted()
References: <1421454312-30505-1-git-send-email-linux@rasmusvillemoes.dk> <20150119191924.GA19153@redhat.com> <87y4oyb6sc.fsf@rustcorp.com.au>
In-Reply-To: <87y4oyb6sc.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/19/2015 08:05 PM, Rusty Russell wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
>> On 01/17, Rasmus Villemoes wrote:
>>>
>>> Using kasprintf to get the function name makes us look up the name
>>> twice, along with all the vsnprintf overhead of parsing the format
>>> string etc. It also means there is an allocation failure case to deal
>>> with. Since symbol_string in vsprintf.c would anyway allocate an array
>>> of size KSYM_SYMBOL_LEN on the stack, that might as well be done up
>>> here.
>>>
>>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>> ---
>>>
>>> Notes:
>>>     I don't know how expensive it is to do the symbol lookup for each
>>>     initcall. It might be worthwhile adding an
>>>     
>>>       if (list_empty(&blacklisted_initcalls))
>>>         return false;
>>>     
>>>     at the very beginning of initcall_blacklisted(), since this is a debug
>>>     feature and the blacklist is indeed usually empty.
>>
>> If we want to optimize this... I am wondering if we can change
>> initcall_blacklist()
>>
>> 	-	entry->buf = alloc_bootmem(strlen(str_entry) + 1);
>> 	+	ebtry->fn = kallsyms_lookup_name(str_entry);
>>
>> and then change initcall_blacklisted() to just compare the pointers.
> 
> That would make far, far more sense.  It would fail for modules of
> course, but that might be OK.  Prarit, this was your code; does it
> matter?

It does actually matter to me.  I've been using it to blacklist modules at boot
as well ... and it works really well :)  So I'm okay with the original patch but
not the second suggested change.

P.

> 
> Cheers,
> Rusty.
> 
