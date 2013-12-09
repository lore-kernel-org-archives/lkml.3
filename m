Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585Ab3LIWSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:18:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3LIWSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:18:53 -0500
Date: Mon, 9 Dec 2013 17:18:38 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Hurley <peter@hurleysoftware.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Karl Dahlke <eklhad@comcast.net>
Subject: Re: [PATCH 3.12] Broken terminal due to echo bufferring
In-Reply-To: <52A5E531.9010909@hurleysoftware.com>
Message-ID: <alpine.LRH.2.02.1312091645400.9569@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <52A5E531.9010909@hurleysoftware.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Dec 2013, Peter Hurley wrote:

> On 12/08/2013 09:55 PM, Mikulas Patocka wrote:
> > Hi
> > 
> > I discovered that kernel 3.12 has broken terminal handling.
> > 
> > I created this program to show the problem:
> > #include <stdio.h>
> > #include <unistd.h>
> > 
> > int main(void)
> > {
> >          int c;
> >          while ((c = getchar()) != EOF) {
> >                  if (c == '\n') write(1, "prompt>", 7);
> >          }
> >          return 0;
> > }
> > 
> > Each time the user presses enter, the program prints "prompt>". Normally,
> > when you press enter, you should see:
> > 
> > prompt>
> > prompt>
> > prompt>
> > prompt>_
> > 
> > However, with kernel 3.12.4, you occasionally see
> > 
> > prompt>
> > prompt>
> > prompt>prompt>
> > _
> > 
> > This bug happens randomly, it is timing-dependent. I am using single-core
> > 600MHz processor with preemptible kernel, the bug may or may not happen on
> > other computers.
> > 
> > This bug is caused by Peter Hurley's echo buffering patches
> > (cbfd0340ae1993378fd47179db949e050e16e697). The patches change n_tty.c so
> > that it accumulates echoed characters and sends them out in a batch.
> > Something like this happens:
> > 
> > * The user presses enter
> > * n_tty.c adds '\n' to the echo buffer using echo_char_raw
> > * n_tty.c adds '\n' to the input queue using put_tty_queue
> > * A process is switched
> > * Userspace reads '\n' from the terminal input queue
> > * Userspace writes the string "prompt>" to the terminal
> > * A process is switched back
> > * The echo buffer is flushed
> > * '\n' from the echo buffer is printed.
> > 
> > 
> > Echo bufferring is fundamentally wrong idea - you must make sure that you
> > flush the echo buffer BEFORE you add a character to input queue and BEFORE
> > you send any signal on behalf of that character. If you delay echo, you
> > are breaking behavior of various programs because the program output will
> > be interleaved with the echoed characters.
> 
> There is nothing fundamentally broken with buffering echoes; it's just that
> there is a bug wrt when to process the echoes (ie, when to force the output).
> 
> In the example you provided, the write() should cause the echoes to flush
> but doesn't because the commit marker hasn't been advanced.
> 
> The commit marker wasn't advanced _yet_ because there is a race window between
> the reader being woken as a result of the newline and the flush_echoes()
> which happens with every received input.
> 
> Either closing the race window or advancing the commit marker prior to
> write() output will fix the problem; right now, I'm looking at which is least
> painful.
> 
> Regards,
> Peter Hurley

I still think you should drop this.


The user types on the keyboard so slowly, that lock contention doesn't 
matter. Specialized programs that use terminal to transmit bulk data don't 
use cooked mode and echo. So I don't really see any use case where 
something depends on performance of echoed characters.


Those patches just complicate the code for no benefit.


When you read a variable that may be asynchronously modified, you need 
ACCESS_ONCE - for example you need this in process_echoes when accessing 
the variables outside the lock:
if (ACCESS_ONCE(ldata->echo_commit) == ACCESS_ONCE(ldata->echo_tail))

Anyway accessing variables that may change without locks or barriers is 
generally bad idea and it is hard to verify it. Terminal layer is not 
performance-sensitive part of the kernel, so it isn't justified to use 
such dirty tricks.


Another problem: what about this in process_echoes and flush_echoes?
if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
	return;
- so if the user turns off echo, echoes are not performed. But the buffer 
is not flushed. So when the user turns on echo again, previously buffered 
characters will be echoed. That is wrong.


Mikulas
