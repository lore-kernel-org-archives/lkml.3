Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaIKOO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:14:57 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:54300 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaIKOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:14:55 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Organization: D03
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
	<20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
	<alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
	<20140910140759.GC31903@thunk.org>
	<alpine.LNX.2.00.1409101625160.5523@pobox.suse.cz>
	<20140910152104.GS6549@mwanda>
	<alpine.LNX.2.00.1409101725340.5523@pobox.suse.cz>
X-Hashcash: 1:20:140911:rientjes@google.com::hwfXaVXZtuFVlfjY:0000000000000000000000000000000000000000000dVy
X-Hashcash: 1:20:140911:dan.carpenter@oracle.com::8zaBEDlJURSbTx3V:00000000000000000000000000000000000001WIX
X-Hashcash: 1:20:140911:penberg@kernel.org::SVnYtQDgdJ1qpljg:00000000000000000000000000000000000000000001pbi
X-Hashcash: 1:20:140911:linux-mm@kvack.org::q2H+6A4zT5X5bf9p:000000000000000000000000000000000000000000027S/
X-Hashcash: 1:20:140911:tytso@mit.edu::O7/9uOQImhj14LOe:00002u1W
X-Hashcash: 1:20:140911:akpm@linux-foundation.org::drREVqEvbR/IWO85:0000000000000000000000000000000000003KOd
X-Hashcash: 1:20:140911:linux-kernel@vger.kernel.org::IR37SSLVCLKY32T2:0000000000000000000000000000000006SK3
X-Hashcash: 1:20:140911:iamjoonsoo.kim@lge.com::ocirWd8Xx0rckZ8Q:0000000000000000000000000000000000000006peB
X-Hashcash: 1:20:140911:cl@linux.com::mT/FNuWM8iXw7vjr:0000094pj
X-Hashcash: 1:20:140911:jkosina@suse.cz::oC2oSmmfFORyJuyt:00AYBv
Date: Thu, 11 Sep 2014 16:14:52 +0200
In-Reply-To: <alpine.LNX.2.00.1409101725340.5523@pobox.suse.cz> (Jiri Kosina's
	message of "Wed, 10 Sep 2014 17:28:11 +0200 (CEST)")
Message-ID: <87oaumdz1f.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10 2014, Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 10 Sep 2014, Dan Carpenter wrote:
>
>> > BTW if we stretch this argument a little bit more, we should also kill the 
>> > ZERO_OR_NULL_PTR() check from kfree() and make it callers responsibility 
>> > to perform the checking only if applicable ... we are currently doing a 
>> > lot of pointless checking in cases where caller would be able to guarantee 
>> > that the pointer is going to be non-NULL.
>> 
>> What you're saying is that we should remove the ZERO_SIZE_PTR
>> completely.  ZERO_SIZE_PTR is a very useful idiom and also it's too late
>> to remove it because everything depends on it.
>
> I was just argumenting that if we care about single additional test in 
> this path, the ZERO_OR_NULL_PTR() should have never been added at the 
> first place, and the responsibility for checking should have been kept at 
> callers.

I think it makes a lot of sense to have the domain of kfree() be exactly
the codomain of kmalloc() and friends. That is, what is acceptable to
pass to kfree() is exactly the set of values that might be returned from
kmalloc() et al. Those include NULL and the very useful unique
zero-sized "object" ZERO_SIZE_PTR, but does not include any ERR_PTR().

Having every caller of kfree() check for NULL would bloat the code size
considerably, and it seems that these checks are being actively removed.

Rasmus
