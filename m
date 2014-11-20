Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaKTBQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 20:16:48 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:44879 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaKTBQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8gzquS-RnjxO3aax8=TNcrm42zK_udpOMdzxSjTbcQg@mail.gmail.com>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge> <alpine.DEB.2.11.1411200002330.3909@nanos>
 <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
 <alpine.DEB.2.11.1411200059410.3909@nanos> <CALCETrXwjPKcCA6t=wjyKWZbREKFTF9E-n9eRa0C39R5O8Q0PQ@mail.gmail.com>
 <CA+55aFxi5mNNXFH20AwrgOVsT1HyuU1a63VYm6m+j0jSVr4dGQ@mail.gmail.com>
 <CALCETrU2Ag1LNveFq88q54wCxCPLi5onCNZzkOD0A_N3x_x6Tw@mail.gmail.com> <CA+55aFy8gzquS-RnjxO3aax8=TNcrm42zK_udpOMdzxSjTbcQg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 17:16:24 -0800
Message-ID: <CALCETrWyVtSQigP=mqoDiw5An4nSdXtig5dJCvTgF1onCJ3o1Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 5:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 4:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I thought so for a while, too, but now I disagree.  On PGE hardware,
>> it seems entirely possible that the new stack would be in the TLB even
>> if it's not visible via cr3.  Then, as soon as the TLB entry expires,
>> we double-fault.
>
> Ahh. Good point.
>
>> I don't want vmalloc to avoid low-order allocations -- I want it to
>> have guard pages.  The fact that a user-triggerable stack overflow is
>> basically root right now and doesn't reliably OOPS scares me.
>
> Well, if you do that, you would have to make the double-fault handler
> aware of the stack issue anyway, and then you could just do teh same
> PGD repopulation that a page fault does and return (for the case where
> you didn't overflow the stack, just had the page tables unpopulated -
> obviously an actual stack overflow should do something more drastic).

And you were calling me crazy? :)

We could be restarting just about anything if that happens.  Except
that if we double-faulted on a trap gate entry instead of an interrupt
gate entry, then we can't restart, and, unless we can somehow decode
the error code usefully (it's woefully undocumented), int 0x80 and
int3 might be impossible to handle correctly if it double-faults.  And
please don't suggest moving int 0x80 to an IST stack :)

The SDM specifically says that you must not try to recover after a
double-fault.  We do, however, recover from a double-fault in the
specific case of an iret failure during espfix64 processing (and I
even have a nice test case for it), but I think that hpa had a long
conversation with one of the microcode architects before he was okay
with that.

--Andy
