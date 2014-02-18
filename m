Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaBRRov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:44:51 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:37536 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaBRRot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:44:49 -0500
MIME-Version: 1.0
In-Reply-To: <1392740258.18779.7732.camel@triegel.csb>
References: <1392321837.18779.3249.camel@triegel.csb>
	<20140214020144.GO4250@linux.vnet.ibm.com>
	<1392352981.18779.3800.camel@triegel.csb>
	<20140214172920.GQ4250@linux.vnet.ibm.com>
	<CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	<CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	<1392486310.18779.6447.camel@triegel.csb>
	<CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
Date: Tue, 18 Feb 2014 09:44:48 -0800
X-Google-Sender-Auth: N80HvWSe2TrmpJOzVUZ7SHnEThY
Message-ID: <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 8:17 AM, Torvald Riegel <triegel@redhat.com> wrote:
>>
>>   "Consume operation: no reads in the current thread dependent on the
>> value currently loaded can be reordered before this load"
>
> I can't remember seeing that language in the standard (ie, C or C++).
> Where is this from?

That's just for googling for explanations. I do have some old standard
draft, but that doesn't have any concise definitions anywhere that I
could find.

>> and it could make a compiler writer say that value speculation is
>> still valid, if you do it like this (with "ptr" being the atomic
>> variable):
>>
>>   value = ptr->val;
>
> I assume the load from ptr has mo_consume ordering?

Yes.

>> into
>>
>>   tmp = ptr;
>>   value = speculated.value;
>>   if (unlikely(tmp != &speculated))
>>     value = tmp->value;
>>
>> which is still bogus. The load of "ptr" does happen before the load of
>> "value = speculated->value" in the instruction stream, but it would
>> still result in the CPU possibly moving the value read before the
>> pointer read at least on ARM and power.
>
> And surprise, in the C/C++ model the load from ptr is sequenced-before
> the load from speculated, but there's no ordering constraint on the
> reads-from relation for the value load if you use mo_consume on the ptr
> load.  Thus, the transformed code has less ordering constraints than the
> original code, and we arrive at the same outcome.

Ok, good.

> The standard is clear on what's required.  I strongly suggest reading
> the formalization of the memory model by Batty et al.

Can you point to it? Because I can find a draft standard, and it sure
as hell does *not* contain any clarity of the model. It has a *lot* of
verbiage, but it's pretty much impossible to actually understand, even
for somebody who really understands memory ordering.

             Linus
