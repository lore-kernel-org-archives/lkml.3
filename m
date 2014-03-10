Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaCJRrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:47:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:50820 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaCJRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <531DF896.8010305@linux.intel.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <531DF549.2090403@linux.intel.com> <CALCETrV+3yCfOCJzRKN-woOyp2RF_=dW1V=9CwpYTUNGAiLoNQ@mail.gmail.com>
 <531DF896.8010305@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 10:46:48 -0700
Message-ID: <CALCETrVKfBpVHZcyccWRYM4rdOAETSQsxjiQuxn+0AeX78XiEw@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:38 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/10/2014 10:31 AM, Andy Lutomirski wrote:
>>>
>>>> For 64-bit, this is an entirely different story.  The vsyscall page is
>>>> stuck in the fixmap forever, although I want to add a way for
>>>> userspace to opt out.  The vvar page, hpet, etc could move into vmas,
>>>> though.  I kind of want to do that anyway to allow processes to turn
>>>> off the ability to read the clock.
>>>
>>> Wait... you want to do what?!
>>
>> This isn't even my idea:
>>
>> commit 8fb402bccf203ecca8f9e0202b8fd3c937dece6f
>> Author: Erik Bosman <ebn310@few.vu.nl>
>> Date:   Fri Apr 11 18:54:17 2008 +0200
>>
>>     generic, x86: add prctl commands PR_GET_TSC and PR_SET_TSC
>>
>>     This patch adds prctl commands that make it possible
>>     to deny the execution of timestamp counters in userspace.
>>     If this is not implemented on a specific architecture,
>>     prctl will return -EINVAL.
>>
>> Currently anything that tries to use the vdso will just crash if you
>> do that, and it fails to turn off direct HPET access.  Fixing this
>> might be nice, but the current vvar implementation makes it
>> impossible.  If you want to stick something in a seccomp sandbox and
>> make it very difficult for it to exploit timing side channels, then
>> this is important :)
>>
>
> Yes, we'd have to switch the vdso to using syscall access.  Doing that
> from inside a system call is... "interesting".

It's a little less interesting if it just involves changing a vma.
It's still tricky, though -- would each struct mm have its own struct
file for the vvar page?  Can this be done with some
vm_operations_struct magic?  There are possible races, too, though --
another thread could access the thing concurrently with a syscall.

It might be nice in general for there to be a /dev/vdso and for the
vdso to literally be a mapping of that device node.  I bet that CRIU
would appreciate this.  (The mmap flags would be a little odd, since
different pages have different protections.)

Anyway, this is totally off topic for the current issue :)

--Andy
