Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCJRMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:12:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56659 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaCJRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 10:12:17 -0700
Message-ID: <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 8:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mar 10, 2014 8:01 AM, "H. Peter Anvin" <hpa@linux.intel.com> wrote:
>>
>> I have mentioned in the past wanting to move the fixmap to the low part
>> of the kernel space, because the top isn't really fixed...
>
> How about the high part of the user address space, just above the stack?
> Leave a unmapped page in between, or something. The stack is already
> randomized, isn't it?

For the !compat_vdso case, I don't like it -- this will put the vdso
(which is executable) at a constant offset from the stack, which will
make it much easier to use the vdso to defeat ASLR.

For the compat_vdso case, this only works if the address is *not*
random, unless we're going to start giving each process its very own
relocated vdso.

>
> That would actually be preferable in a few ways, notably not having to mark
> page directories user accessible in the kennel space area.

Is that where the rabid pte dogs live?

We can already avoid making fixmap pages user-accessible in the
!compat_vdso case for 32-bit tasks -- the vdso lives in a couple of
more-or-less ordinary vmas.

For 64-bit, this is an entirely different story.  The vsyscall page is
stuck in the fixmap forever, although I want to add a way for
userspace to opt out.  The vvar page, hpet, etc could move into vmas,
though.  I kind of want to do that anyway to allow processes to turn
off the ability to read the clock.

--Andy
