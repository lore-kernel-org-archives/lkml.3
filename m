Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaILJBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:01:31 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41937 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaILJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:01:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RFC 1/2] lib: string: Remove duplicated function
Organization: D03
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
	<1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
	<20140911152241.22ce7f1ebecef7ce7e01b112@linux-foundation.org>
X-Hashcash: 1:20:140912:ak@linux.intel.com::PghHT6Kl/ESBk/9w:00000000000000000000000000000000000000000000HGU
X-Hashcash: 1:20:140912:linux-kernel@vger.kernel.org::5uJqo5igtiOaIVni:0000000000000000000000000000000001RMG
X-Hashcash: 1:20:140912:dan.carpenter@oracle.com::8/ItIgjkserP804T:00000000000000000000000000000000000001zJh
X-Hashcash: 1:20:140912:hpa@linux.intel.com::WgL2vOCnrMsNtllP:0000000000000000000000000000000000000000002ppk
X-Hashcash: 1:20:140912:akpm@linux-foundation.org::Rs5a91ZjQNpA4vKQ:0000000000000000000000000000000000003d/h
X-Hashcash: 1:20:140912:grant.likely@linaro.org::A7EuDIABJh49xKPh:000000000000000000000000000000000000005vWM
Date: Fri, 12 Sep 2014 11:01:17 +0200
In-Reply-To: <20140911152241.22ce7f1ebecef7ce7e01b112@linux-foundation.org>
	(Andrew Morton's message of "Thu, 11 Sep 2014 15:22:41 -0700")
Message-ID: <87d2b1jjqa.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12 2014, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Aug 2014 09:36:01 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> lib/string.c contains two functions, strnicmp and strncasecmp, which
>> do roughly the same thing, namely compare two strings
>> case-insensitively up to a given bound. They have slightly different
>> implementations, but the only important difference is that strncasecmp
>> doesn't handle len==0 appropriately; it effectively becomes strcasecmp
>> in that case. strnicmp correctly says that two strings are always
>> equal in their first 0 characters.
>> 
>> strncasecmp is the POSIX name for this functionality. So rename the
>> non-broken function to the standard name. To minimize the impact on
>> the rest of the kernel (and since both are exported to modules), make
>> strnicmp a wrapper for strncasecmp.
>
> I guess it's safe to assume that nobody was depending on the
> strncasecmp() bug.

Hm, I thought so as well, but decided to double check. I found one minor
issue; maybe Tejun can tell if my analysis is correct.

In drivers/ata/libata-core.c, ata_parse_force_one(), it is not
immediately clear to me that val cannot end up being the empty
string. With the buggy strncasecmp, the continue branch is always
followed (since fp->name is not empty); however, with strncasecmp with
the correct semantics, the empty string is obviously a prefix of every
fp->name. So even though the comment says that "1.5" is an ok
abbreviation of "1.5Gbps", I don't think the intention was to allow ""
to be an abbreviation of everything. Anyway, the worst that can happen
seems to be that "ambigious value" [sic] becomes the *reason instead
of "unknown value".

I may have overlooked similar issues; my checking was basically "is the
length parameter an explicit non-zero number or strlen() of some static
data in some table (where I assume empty strings do not lurk)".

> Yes, please prepare the strnicmp()->strncasecmp() patches and let's get
> them merged up.  After a kernel release or two we can zap the
> back-compat wrapper.

Will do. Is there a fixed SHA1 I can refer to in the commit logs?

> And it isn't just "out of tree modules" that we should be concerned
> about - we'll commonly find that "to be in tree" code is using
> interfaces which we're trying to alter or remove, so it takes a cycle
> or two to get everything propagated.  Most of this code can be found in
> linux-next.

Would it make sense to add a checkpatch warning to ensure new users
are not introduced, and then remove it when the wrapper is also removed?

Thanks,
Rasmus
