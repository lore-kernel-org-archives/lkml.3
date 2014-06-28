Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaF1GVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:21:22 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37658 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaF1GVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <1403926333.5113.12.camel@marge.simpson.net>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
 <1403873856.5827.56.camel@marge.simpson.net> <20140627100157.6b0143a5@gandalf.local.home>
 <1403890493.5830.33.camel@marge.simpson.net> <20140627135415.7246e87e@gandalf.local.home>
 <1403892474.5830.41.camel@marge.simpson.net> <20140627141903.16817c28@gandalf.local.home>
 <CANGgnMZrx1s5AomG-L_F74215RE1uJOekTjYmLX0voG4NgakTg@mail.gmail.com> <1403926333.5113.12.camel@marge.simpson.net>
From: Austin Schuh <austin@peloton-tech.com>
Date: Fri, 27 Jun 2014 23:20:59 -0700
Message-ID: <CANGgnMbJ9f4gSz0HbtnCLosYHKyfXwhMt-svUQbBe_d9bv2LGQ@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 8:32 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Fri, 2014-06-27 at 18:18 -0700, Austin Schuh wrote:
>
>> It would be more context switches, but I wonder if we could kick the
>> workqueue logic completely out of the scheduler into a thread.  Have
>> the scheduler increment/decrement an atomic pool counter, and wake up
>> the monitoring thread to spawn new threads when needed?  That would
>> get rid of the recursive pool lock problem, and should reduce
>> scheduler latency if we would need to spawn a new thread.
>
> I was wondering the same thing, and not only for workqueue, but also the
> plug pulling.  It's kind of a wart to have that stuff sitting in the
> hear of the scheduler in the first place, would be nice if it just went
> away.  When a task can't help itself, you _could_ wake a proxy do that
> for you.  Trouble is, I can imagine that being a heck of a lot of
> context switches with some loads.. and who's gonna help the helper when
> he blocks while trying to help?
>
> -Mike

For workqueues, as long as the helper doesn't block on a lock which
requires the work queue to be freed up, it will eventually become
unblocked and make progress.  The helper _should_ only need the pool
lock, which will wake the helper back up when it is available again.
Nothing should go to sleep in an un-recoverable way with the work pool
lock held.

To drop the extra context switch, you could have a minimum of 2 worker
threads around at all times, and have the management thread start the
work and delegate to the next management thread.  That thread would
then wait for the first thread to block, spawn a new thread, and then
start the next piece of work.  Definitely a bit more complicated.

Austin
