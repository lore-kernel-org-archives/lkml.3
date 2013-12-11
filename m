Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3LKQ3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:29:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3LKQ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:29:31 -0500
Date: Wed, 11 Dec 2013 11:29:21 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Hurley <peter@hurleysoftware.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Karl Dahlke <eklhad@comcast.net>
Subject: Re: [PATCH 3.12] Broken terminal due to echo bufferring
In-Reply-To: <52A72680.3070500@hurleysoftware.com>
Message-ID: <alpine.LRH.2.02.1312111032270.14261@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <52A5E531.9010909@hurleysoftware.com> <alpine.LRH.2.02.1312091645400.9569@file01.intranet.prod.int.rdu2.redhat.com> <52A659DD.2030904@hurleysoftware.com>
 <alpine.LRH.2.02.1312092103290.11182@file01.intranet.prod.int.rdu2.redhat.com> <52A72680.3070500@hurleysoftware.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Dec 2013, Peter Hurley wrote:

> On 12/09/2013 09:29 PM, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 9 Dec 2013, Peter Hurley wrote:
> > 
> > > On 12/09/2013 05:18 PM, Mikulas Patocka wrote:
> > > > 
> > > > I still think you should drop this.
> > > > 
> > > > 
> > > > The user types on the keyboard so slowly, that lock contention doesn't
> > > > matter. Specialized programs that use terminal to transmit bulk data
> > > > don't
> > > > use cooked mode and echo. So I don't really see any use case where
> > > > something depends on performance of echoed characters.
> > > > 
> > > > 
> > > > Those patches just complicate the code for no benefit.
> > > > 
> > > > 
> > > > When you read a variable that may be asynchronously modified, you need
> > > > ACCESS_ONCE - for example you need this in process_echoes when accessing
> > > > the variables outside the lock:
> > > > if (ACCESS_ONCE(ldata->echo_commit) == ACCESS_ONCE(ldata->echo_tail))
> > > 
> > > Not necessarily. Stale values in an SMP environment may not be a problem;
> > > in this case, a possibly stale echo_tail simply means that the output_lock
> > > will be obtained unnecessarily (which is cheaper every-so-often than
> > > contending
> > > over the echo_tail cache line every write, especially on x86 where there
> > > is
> > > no problem).
> > 
> > Note that a single lock doesn't imply memory barrier:
> > 	read(variable_1);
> > 	spin_lock(lock);
> > 	spin_unlock(lock);
> > 	read(variable_2);
> > may be reordered to
> > 	spin_lock(lock);
> > 	read(variable_2);
> > 	read(variable_1);
> > 	spin_unlock(lock);
> > 
> > Two lock do imply a memory barrier. Surely, you can argue that the system
> > takes at least two locks between reading the input queue and writing to
> > the output to compensate for the missing memory barrier. But depending on
> > such guarantees is dirty.
> 
> To escape from n_tty_read() alone requires passing through (at a minimum)
> 1. UNLOCK rwsem
> 2. LOCK wq
> 3. UNLOCK wq
> 4. UNLOCK read serialization

Sure, but you should just add the barriers if they are needed, don't rely 
on others doing barriers for you. Besides, there is another rw-semaphore 
implementation that doesn't have any barrier guarantees 
(include/linux/percpu-rwsem.h).

> > Also note, that you need ACCESS_ONCE if the variable may change. The
> > compiler may assume during optimizations that the variables that are read
> > don't change.
> 
> Lots of (many? most?) kernel variables change asynchronously and are still
> read without ACCESS_ONCE();  consider how waitqueue_active() works.

So they should be read with ACCESS_ONCE().

> > The compiler may even generate something like this when you read variable
> > "v":
> > 	movl	v, %eax
> > 	cmpl	v, %eax
> > 	jne	nowhere
> > - of course it doesn't actually generate this code, but legally it could.
> > ACCESS_ONCE is there to prevent this assumption.
> 
> Not in this case. The compiler could not possibly prove the loads
> are unnecessary: n_tty_write() is a globally visible call target.
> (Besides, the load can't be optimized out because of the LOCK rwsem.)

The compiler may assume that the variables that it is reading don't 
change. Usually it doesn't use this assumption (that why omitting 
ACCESS_ONCE in most cases doesn't result in any observable wrongdoing), 
but nonetheless, the compiler may use this assumption.

For example, if the compiler proves that action1() and action2() don't 
change the variable, it may transform this piece of code:
	if (variable) {
		action1();
		action2();
		action3();
	} else {
		action2();
	}
into this piece of code:
	if (variable)
		action1();
	action2();
	if (variable)
		action3();

- obviously, if the variable changes asynchronously, it results in 
unintended bahavior.

> > I suggest that you change commit_echoes to always write the buffer and
> > flush it with tty->ops->flush_chars(tty). And then, you can drop
> > process_echoes from n_tty_write. And then, there will be no asynchronous
> > access to the buffer pointers.
> 
> process_echoes() cannot be dropped from n_tty_write() because, even without
> block commits, the driver's output buffer may be full and unable to accept
> more input. That's why the echo buffer exists.

Let me ask you this question:

Does the function __process_echoes (in 3.12) or process_echoes (in 3.11) 
guarantee that the echo buffer is emptied and all characters in the buffer 
are sent to the terminal?

- if it has this guarantee, then you don't need to call that function in 
n_tty_write. It is just enough to call it before adding the character to 
the input queue.

- if it doesn't have this guarantee, then then the code is already buggy:
suppose for example this race condition:
1. the user presses enter
2. '\n' is added to the echo buffer
3. the echo buffer is not flushed because tty_write_room returns zero
4. the program reads '\n' from the input buffer
5. the program writes the string "prompt>" to the terminal
6. n_tty_write calls process_echoes, it still doesn't echo anything 
   because tty_write_room returns zero
7. the terminal driver makes some progress and makes some room in its 
   buffer so that tty_write_room no longer returns zero
8. n_tty_write writes the string "prompt>" while '\n' is still sitting in 
   the echo buffer

Another problem - if __process_echoes doesn't flush the echo buffer, who 
does flush it afterwards? You need to spawn a workqueue that waits on 
tty->write_wait and flushes the echo buffer when the terminal drivers 
makes some room.

> > > > Another problem: what about this in process_echoes and flush_echoes?
> > > > if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
> > > > 	return;
> > > > - so if the user turns off echo, echoes are not performed. But the
> > > > buffer
> > > > is not flushed. So when the user turns on echo again, previously
> > > > buffered
> > > > characters will be echoed. That is wrong.
> > > 
> > > The check for !L_ECHO pre-dates my patches; it might be wrong but
> > > userspace
> > > may have come to rely on this behavior. That said, feel free to submit a
> > > fix
> > > for that, if you think it's broken.
> > 
> > We should just clear the buffer on !L_ECHO. Or maybe (once we get rid of
> > the asynchronous buffer access) do not test here for L_ECHO at all - if
> > L_ECHO isn't set, then nothing is appended to the buffer. Consequently we
> > don't have to check for L_ECHO when we are flushing the buffer.
> 
> Discarding the echo buffer with L_ECHO -> !L_ECHO changes will almost 
> certainly break something. I considered attempting to push the echo 
> buffer when that change happens in n_tty_set_termios() but simply 
> haven't gotten to it for testing; and that still wouldn't get rid of the 
> need to check if echoes need to be pushed when !L_ECHO.

If there is !L_ECHO, than no characters are added to the echo buffer. 
Then, you test L_ECHO again, when flushing the echo buffer.

So I think there's a race condition:
1. L_ECHO is on
2. the user types some characters, they are added to the echo buffer
3. the program turns L_ECHO off
4. process_echoes and flush_echoes see that L_ECHO is off, so they don't 
   flush the buffer - but the buffer still contains the characters
5. some time passes
6. the program turns L_ECHO on
7. the characters typed in step 2. are still in the buffer and they are 
   echoed now - this is WRONG - the characters typed in step 2. should be
   either echoed immediatelly or not echoed at all

The kernel 3.11 doesn't have this bug (it doesn't check for L_ECHO in 
process_echoes).

> Regards,
> Peter Hurley

Mikulas
