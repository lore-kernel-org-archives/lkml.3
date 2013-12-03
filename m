Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3LCXtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:49:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49565 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab3LCXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:49:01 -0500
Message-ID: <529E6DA3.5060705@zytor.com>
Date: Tue, 03 Dec 2013 15:47:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
 page directly
References: <20131129200532.GA13561@redhat.com>	<alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>	<CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>	<20131203184909.GA17571@redhat.com>	<CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>	<529E2F0C.8070405@zytor.com>	<20131203200147.GB19083@redhat.com>	<529E3D4C.9070403@zytor.com>	<20131203203826.GA24812@redhat.com>	<e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>	<20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
In-Reply-To: <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 02:01 PM, Linus Torvalds wrote:
> On Tue, Dec 3, 2013 at 12:54 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> So do you think the patch I sent is wrong? Why?
> 
> I think the TLB shootdown should guarantee that it's ok on other
> CPU's, since that's basically what we do on mmap.
> 

I think that is true for other CPUs; however, there are definitely CPUs
out there (which Linux supports) for which you have to synchronize the I
and D sides "manually" after writing code through memory, at least
through the CPU.  That is at least one reason why MIPS has a
cacheflush() system call, for example.

> But looking closer at this, I think I see why the old code did what it
> did. I think it's breaking shared mmap pages on purpose rather than
> dirtying them. Which is probably the right thing to do.
> 

In other words, treating them as MAP_PRIVATE?  Wouldn't it be better to
throw an error if we can't honor the semantics of the mapping that we
are using?

	-hpa

