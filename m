Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCJRxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:53:21 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42267 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaCJRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <531DFAF0.9070806@linux.intel.com>
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net>
 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
 <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
 <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <531DF549.2090403@linux.intel.com> <CALCETrV+3yCfOCJzRKN-woOyp2RF_=dW1V=9CwpYTUNGAiLoNQ@mail.gmail.com>
 <531DF896.8010305@linux.intel.com> <CALCETrVKfBpVHZcyccWRYM4rdOAETSQsxjiQuxn+0AeX78XiEw@mail.gmail.com>
 <531DFAF0.9070806@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Mar 2014 10:52:58 -0700
Message-ID: <CALCETrVkTtt5H9-0_mODcGyaLTusBfANkoANo+wKB4JAwjxU2g@mail.gmail.com>
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

On Mon, Mar 10, 2014 at 10:48 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/10/2014 10:46 AM, Andy Lutomirski wrote:
>>>
>>> Yes, we'd have to switch the vdso to using syscall access.  Doing that
>>> from inside a system call is... "interesting".
>>
>> It's a little less interesting if it just involves changing a vma.
>> It's still tricky, though -- would each struct mm have its own struct
>> file for the vvar page?  Can this be done with some
>> vm_operations_struct magic?  There are possible races, too, though --
>> another thread could access the thing concurrently with a syscall.
>>
>
> Hint: where is your RIP?  Where is the RIP of other processes?
>

Whoa there, I'm not suggesting anything nearly that crazy :)

I'm suggesting changing out the vvar page *for that process*, which is
not executable.  The actual vdso code already supports this -- from
userspace's point of view it's the same thing as 'echo acpi_pm >
/sys/devices/system/clocksource/clocksource0/current_clocksource',
except that if the actual clocksource is HPET, the hpet page will be
switched out (presumably with a zero page) while being read.

Other processes are totally irrelevant, unless they share the same
struct mm.  (This is why the vvar page can't be in the fixmap for this
to work.)

--Andy
