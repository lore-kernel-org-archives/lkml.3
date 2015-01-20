Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbbATBrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 20:47:46 -0500
Received: from ozlabs.org ([103.22.144.67]:40920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbATBrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 20:47:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Prarit Bhargava <prarit@redhat.com>, Fabian Frederick <fabf@skynet.be>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] init/main.c: Simplify initcall_blacklisted()
In-Reply-To: <20150119191924.GA19153@redhat.com>
References: <1421454312-30505-1-git-send-email-linux@rasmusvillemoes.dk> <20150119191924.GA19153@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 11:35:39 +1030
Message-ID: <87y4oyb6sc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:
> On 01/17, Rasmus Villemoes wrote:
>>
>> Using kasprintf to get the function name makes us look up the name
>> twice, along with all the vsnprintf overhead of parsing the format
>> string etc. It also means there is an allocation failure case to deal
>> with. Since symbol_string in vsprintf.c would anyway allocate an array
>> of size KSYM_SYMBOL_LEN on the stack, that might as well be done up
>> here.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>> 
>> Notes:
>>     I don't know how expensive it is to do the symbol lookup for each
>>     initcall. It might be worthwhile adding an
>>     
>>       if (list_empty(&blacklisted_initcalls))
>>         return false;
>>     
>>     at the very beginning of initcall_blacklisted(), since this is a debug
>>     feature and the blacklist is indeed usually empty.
>
> If we want to optimize this... I am wondering if we can change
> initcall_blacklist()
>
> 	-	entry->buf = alloc_bootmem(strlen(str_entry) + 1);
> 	+	ebtry->fn = kallsyms_lookup_name(str_entry);
>
> and then change initcall_blacklisted() to just compare the pointers.

That would make far, far more sense.  It would fail for modules of
course, but that might be OK.  Prarit, this was your code; does it
matter?

Cheers,
Rusty.
