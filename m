Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3LJC33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3LJC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:29:27 -0500
Date: Mon, 9 Dec 2013 21:29:19 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Hurley <peter@hurleysoftware.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Karl Dahlke <eklhad@comcast.net>
Subject: Re: [PATCH 3.12] Broken terminal due to echo bufferring
In-Reply-To: <52A659DD.2030904@hurleysoftware.com>
Message-ID: <alpine.LRH.2.02.1312092103290.11182@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <52A5E531.9010909@hurleysoftware.com> <alpine.LRH.2.02.1312091645400.9569@file01.intranet.prod.int.rdu2.redhat.com> <52A659DD.2030904@hurleysoftware.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Dec 2013, Peter Hurley wrote:

> On 12/09/2013 05:18 PM, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 9 Dec 2013, Peter Hurley wrote:
> > 
> > > On 12/08/2013 09:55 PM, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > I discovered that kernel 3.12 has broken terminal handling.
> > > > 
> > > > I created this program to show the problem:
> > > > #include <stdio.h>
> > > > #include <unistd.h>
> > > > 
> > > > int main(void)
> > > > {
> > > >           int c;
> > > >           while ((c = getchar()) != EOF) {
> > > >                   if (c == '\n') write(1, "prompt>", 7);
> > > >           }
> > > >           return 0;
> > > > }
> > > > 
> > > > Each time the user presses enter, the program prints "prompt>".
> > > > Normally,
> > > > when you press enter, you should see:
> > > > 
> > > > prompt>
> > > > prompt>
> > > > prompt>
> > > > prompt>_
> > > > 
> > > > However, with kernel 3.12.4, you occasionally see
> > > > 
> > > > prompt>
> > > > prompt>
> > > > prompt>prompt>
> > > > _
> > > > 
> > > > This bug happens randomly, it is timing-dependent. I am using
> > > > single-core
> > > > 600MHz processor with preemptible kernel, the bug may or may not happen
> > > > on
> > > > other computers.
> > > > 
> > > > This bug is caused by Peter Hurley's echo buffering patches
> > > > (cbfd0340ae1993378fd47179db949e050e16e697). The patches change n_tty.c
> > > > so
> > > > that it accumulates echoed characters and sends them out in a batch.
> > > > Something like this happens:
> > > > 
> > > > * The user presses enter
> > > > * n_tty.c adds '\n' to the echo buffer using echo_char_raw
> > > > * n_tty.c adds '\n' to the input queue using put_tty_queue
> > > > * A process is switched
> > > > * Userspace reads '\n' from the terminal input queue
> > > > * Userspace writes the string "prompt>" to the terminal
> > > > * A process is switched back
> > > > * The echo buffer is flushed
> > > > * '\n' from the echo buffer is printed.
> > > > 
> > > > 
> > > > Echo bufferring is fundamentally wrong idea - you must make sure that
> > > > you
> > > > flush the echo buffer BEFORE you add a character to input queue and
> > > > BEFORE
> > > > you send any signal on behalf of that character. If you delay echo, you
> > > > are breaking behavior of various programs because the program output
> > > > will
> > > > be interleaved with the echoed characters.
> > > 
> > > There is nothing fundamentally broken with buffering echoes; it's just
> > > that
> > > there is a bug wrt when to process the echoes (ie, when to force the
> > > output).
> > > 
> > > In the example you provided, the write() should cause the echoes to flush
> > > but doesn't because the commit marker hasn't been advanced.
> > > 
> > > The commit marker wasn't advanced _yet_ because there is a race window
> > > between
> > > the reader being woken as a result of the newline and the flush_echoes()
> > > which happens with every received input.
> > > 
> > > Either closing the race window or advancing the commit marker prior to
> > > write() output will fix the problem; right now, I'm looking at which is
> > > least
> > > painful.
> > > 
> > > Regards,
> > > Peter Hurley
> > 
> > I still think you should drop this.
> > 
> > 
> > The user types on the keyboard so slowly, that lock contention doesn't
> > matter. Specialized programs that use terminal to transmit bulk data don't
> > use cooked mode and echo. So I don't really see any use case where
> > something depends on performance of echoed characters.
> > 
> > 
> > Those patches just complicate the code for no benefit.
> > 
> > 
> > When you read a variable that may be asynchronously modified, you need
> > ACCESS_ONCE - for example you need this in process_echoes when accessing
> > the variables outside the lock:
> > if (ACCESS_ONCE(ldata->echo_commit) == ACCESS_ONCE(ldata->echo_tail))
> 
> Not necessarily. Stale values in an SMP environment may not be a problem;
> in this case, a possibly stale echo_tail simply means that the output_lock
> will be obtained unnecessarily (which is cheaper every-so-often than
> contending
> over the echo_tail cache line every write, especially on x86 where there is
> no problem).

Note that a single lock doesn't imply memory barrier:
	read(variable_1);
	spin_lock(lock);
	spin_unlock(lock);
	read(variable_2);
may be reordered to
	spin_lock(lock);
	read(variable_2);
	read(variable_1);
	spin_unlock(lock);

Two lock do imply a memory barrier. Surely, you can argue that the system 
takes at least two locks between reading the input queue and writing to 
the output to compensate for the missing memory barrier. But depending on 
such guarantees is dirty.

What happens if I write the equivalent of the above program that reads 
'\n' and writes "prompt>" in the kernel space? Will there still be two 
locks between those operations? Will there be two locks always in the 
future?


Also note, that you need ACCESS_ONCE if the variable may change. The 
compiler may assume during optimizations that the variables that are read 
don't change.

The compiler may even generate something like this when you read variable 
"v":
	movl	v, %eax
	cmpl	v, %eax
	jne	nowhere
- of course it doesn't actually generate this code, but legally it could.
ACCESS_ONCE is there to prevent this assumption.


I suggest that you change commit_echoes to always write the buffer and 
flush it with tty->ops->flush_chars(tty). And then, you can drop 
process_echoes from n_tty_write. And then, there will be no asynchronous 
access to the buffer pointers.

> Similarly, so many fences had to be passed to get to the echo_commit load
> from userspace that performing a load-acquire here and store-release in
> commit_echoes would be ridiculously superfluous.
> 
> > Anyway accessing variables that may change without locks or barriers is
> > generally bad idea and it is hard to verify it. Terminal layer is not
> > performance-sensitive part of the kernel, so it isn't justified to use
> > such dirty tricks.
> > 
> > 
> > Another problem: what about this in process_echoes and flush_echoes?
> > if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
> > 	return;
> > - so if the user turns off echo, echoes are not performed. But the buffer
> > is not flushed. So when the user turns on echo again, previously buffered
> > characters will be echoed. That is wrong.
> 
> The check for !L_ECHO pre-dates my patches; it might be wrong but userspace
> may have come to rely on this behavior. That said, feel free to submit a fix
> for that, if you think it's broken.

We should just clear the buffer on !L_ECHO. Or maybe (once we get rid of 
the asynchronous buffer access) do not test here for L_ECHO at all - if 
L_ECHO isn't set, then nothing is appended to the buffer. Consequently we 
don't have to check for L_ECHO when we are flushing the buffer.

> Regards,
> Peter Hurley

Mikulas
