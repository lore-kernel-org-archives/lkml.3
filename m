Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3A0UkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 15:40:11 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:41773 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab3A0UkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 15:40:07 -0500
Date: Sun, 27 Jan 2013 21:39:54 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130127203954.GA22063@samfundet.no>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
 <20130127195714.GA11224@samfundet.no>
 <20130127203009.GG4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127203009.GG4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 27 Jan 2013 20:30:09 +0000 or thereabout, Al Viro wrote:
> On Sun, Jan 27, 2013 at 08:57:14PM +0100, Hans-Christian Egtvedt wrote:
>> Around Sun 27 Jan 2013 13:50:15 +0100 or thereabout, Matthias Brugger wrote:
>> > This patch adds dummy syscalls so that compiling
>> > for this architecture does not provoke warnings when
>> > checksyscalls.sh is called.
>> 
>> Does any of these syscalls take more than 5 arguments? If so, it is also
>> needed to do some stack handling. I would rather not add syscalls that cause
>> the kernel to misbehave.
> 
> BTW, it might make sense to teach SYSCALL_DEFINE6 to generate such a wrapper
> on avr32.  How about something along the lines of
> * SYSCALL_DEFINE6(foo, ...) generating (via asm volatile, right next to
> sys_foo())
> __sys_##foo:
>         pushm   lr
>         st.w    --sp, r3
> 	call	sys_##foo
>         sub     sp, -4
>         popm    pc
> * SYSCALL_DEFINE[0..5](foo, ...) generating
> 	SYSCALL_ALIAS(__sys_foo, sys_foo)
> * syscall_table.S beginning with
>         .section .rodata,"a",@progbits
>         .type   sys_call_table,@object
>         .global sys_call_table
>         .align  2
> #define SYS(name) __sys_##name
> sys_call_table:
>         SYS(restart_syscall)
> 	SYS(exit)
> 	SYS(fork)
> 	...
> 
> If you are OK with going that way, I could probably put together patches doing
> just that.  Note that for rt_sigsuspend/rt_sigreturn/sigaltstack the wrappers
> are not needed at all - they can just use current_pt_regs() in syscall body.
> IOW, all of syscall-stubs.S could be killed.

Nice, could you put together the preprocessor stuff in a patch? It would be
great to not having to write a re-occuring stub for each syscall that has 6+
arguments.

Thanks for looking at this.

-- 
mvh
Hans-Christian Egtvedt
