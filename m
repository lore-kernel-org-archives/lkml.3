Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaBJXUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:20:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBJXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:20:20 -0500
Message-ID: <52F95E90.3030402@oracle.com>
Date: Mon, 10 Feb 2014 18:19:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>, akpm@linux-foundation.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] mm: additional page lock debugging
References: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com> <20131230114317.GA8117@node.dhcp.inet.fi> <52C1A06B.4070605@oracle.com> <20131230224808.GA11674@node.dhcp.inet.fi> <52C2385A.8020608@oracle.com> <20131231162636.GD16438@laptop.programming.kicks-ass.net> <52C2F3DC.2020106@oracle.com> <20140106100408.GC31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106100408.GC31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This triggers two problems:
>>
>>   - lockdep complains about deadlock since we try to lock another page while one is already
>> locked. I can clear that by allowing page locks to nest within each other, but that seems
>> wrong and we'll miss actual deadlock cases.
>
> Right,.. I think we can cobble something together like requiring we
> always lock pages in pfn order or somesuch.
>

Sorry, I went ahead to dig into mm/lockdep based on your comments and noticed I forgot to reply
to this mail.

Getting them to lock in pfn order seems to be a bit of a mess since we need to keep the free
lists sorted. I didn't find a nice way of doing it without having to do insertion sort which slows
everything down.

>>   - We may leave back to userspace with pages still locked. This is valid behaviour but lockdep
>> doesn't like that.
>
> Where do we actually do this? BTW its not only lockdep not liking that,
> Linus was actually a big fan of that check.
>
> ISTR there being some filesystem freezer issues with that too, where the
> freeze ioctl would return to userspace with 'locks' held and that's
> cobbled around (or maybe gone by now -- who knows).
>
> My initial guess would be that this is AIO/DIO again, those two seem to
> be responsible for the majority of ugly around there.

Indeed, the block layer has multiple "violations". In the AIO case, we lock pages in one task
and leave back to userspace, and those pages get unlocked by a completion thread which runs at
some point later.

Right now I gave up on getting lockdep fully integrated in, and am trying to fix as many of these 
issues as possible by detecting trivial cases and fixing those. I feel that adding lockdep in at
this point is way more complex than what we need done. We don't really need lockdep to detect pretty
trivial cases of double locking on the very same lock...

When we got rid of everything we can easily spot, lockdep should move in to detect anything more
complex.

Thanks,
Sasha

