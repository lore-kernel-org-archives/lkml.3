Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaCJWDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:03:35 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47491 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCJWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140310225342.Horde.61HLMn9MRz49_0n_vS9HYQ1@webmail.your-server.de>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <1394481804.980.9.camel@wall-e.seibold.net> <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
 <20140310222528.Horde.tMG70UcHgBuz9DV3W9_aaA1@webmail.your-server.de>
 <CA+55aFygdFWCVzsSNT6v-8Mnsq8rrFwz0d1ydOLRthv4JsBaBQ@mail.gmail.com> <20140310225342.Horde.61HLMn9MRz49_0n_vS9HYQ1@webmail.your-server.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 15:03:12 -0700
Message-ID: <CALCETrUpVYrUfn=cDGtrxg3pDBonVmiK59iAZL1nQxCV0v3wmA@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: Stefani Seibold <stefani@seibold.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 2:53 PM,  <stefani@seibold.net> wrote:
> Zitat von Linus Torvalds <torvalds@linux-foundation.org>:
>
>> On Mon, Mar 10, 2014 at 2:25 PM,  <stefani@seibold.net> wrote:
>>>
>>>
>>> This was discovered by me.
>>
>>
>> Sorry for the misattribution.
>>
>>> But this is not a real solution, at least when vcpu function support
>>> will be added, then the code size will exceed the page size. Reserving
>>> two pages for the VDSO is a good option.
>>
>>
>> Quite frankly, there is no way in hell I will take a patch like that
>> for 3.14 any more, and I would argue against it for stable.
>>
>> Now, if this problem never happens with current kernels (because it's
>> purely due to the patch in -tip), then I don't much care.
>>
>> That said, I don't understand why we are even adding new features like
>> this to 32-bit mode in the first place, so if that patch is the sole
>> source of all this headache, then why not just throw the patch away?
>>
>
> The patch is working. And for this current issue there is a solution i
> already
> announced.
>
> A dual VDSO: a one page sized VDSO for the compat mode which has only the
> syscall
> code and on multi page sized VDSO which is mapped into user space for the
> non compat
> mode.
>
> This will work and has no side effects.

IMO this is dumb.  I can think of two sensible solutions:

1. Get rid of compat vdso and replace it with no vdso at all.  This is
compatible with everything and requires almost no code :)

2. Fix compat vdso.  Give it as much space as needed, make the address
dynamic, and relocate it to the right place.

I see no legitimate reason to further increase the number of 32-bit
vdso images.  Three is already ridiculous, and adding more is IMO
hideous.

#1 is actually a serious proposal.  To do it right, I think we should
rename the config option to CONFIG_BROKEN_GLIBC_VDSO, default it to n,
and make the help text clarify that this only affects certain
non-released glibc versions and that anyone building a new kernel is
highly unlikely to be affected.  Then make vdso=2 act just like
vdso=0.  CONFIG_BROKEN_GLIBC_VDSO just changes the default from vdso=1
to vdso=0.

Damn it, the number of users who (a) have a buggy copy of glibc, (b)
are using new kernels, and (c) are using CONFIG_COMPAT_VDSO as opposed
to, say, vdso=2 is probably very close to zero.  (These users will
have issues until they fix their config.)

The number of users who (a) have a buggy copy of glibc, (b) are using
new kernels, and (c) have cpus that derive significant benefit from
using a vdso instead of int 80 and care at all is probably also very
close to zero.

The maintenance burden of this piece of shite is empirically quite far
from zero.

--Andy
