Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3CEVod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:44:33 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50608 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CEVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:44:32 -0500
Message-ID: <1362519863.18799.119.camel@thor.lan>
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 16:44:23 -0500
In-Reply-To: <20130305.155300.1299712636968046625.davem@davemloft.net>
References: <51364B31.1010808@suse.cz>
	 <20130305.150338.470704111422696046.davem@davemloft.net>
	 <1362516424.18799.81.camel@thor.lan>
	 <20130305.155300.1299712636968046625.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 15:53 -0500, David Miller wrote:
> From: Peter Hurley <peter@hurleysoftware.com>
> Date: Tue, 05 Mar 2013 15:47:04 -0500
> 
> > On Tue, 2013-03-05 at 15:03 -0500, David Miller wrote:
> >> From: Jiri Slaby <jslaby@suse.cz>
> >> Date: Tue, 05 Mar 2013 20:44:49 +0100
> >> 
> >> > Hi, I must admit I don't understand. I now checked both of them and they
> >> > call uart_handle_sysrq_char unconditionally, or?
> >> 
> >> Nope, in the sunsab.c receive function, we used to handle the SYSRQ
> >> stuff before break checking when TTY is NULL, now we don't.
> > 
> > Hi David,
> > 
> > SysRq is signalled first by a BRK condition, then followed by the input
> > character indicating which SysRq function to perform.
> > 
> > sunsab.c: receive_char() is behaving as you would expect.
> > 
> > First, a BRK status is indicated so uart_handle_break() records a
> > timestamp. If the next input is received within 5 sec. of that
> > timestamp, the character received is interpreted as a SysRq function --
> > handled by uart_handle_sysrq_char().
> > 
> > Are you observing that SysRq processing is not occurring with this
> > driver when only a console exists, or are you hypothesizing that this is
> > possible?
> 
> Before we go down this road we need to first address the fact that
> non-trivial semantic changes we made to these functions without any
> of that being documented.

Agreed. I had my surprise moments back in January on linux-next (partly
my own fault for being away over the holidays).

And it is not my intention to camouflage or distract from the issues:
the change to sunsab.c may indeed affect the way SysRq is handled, and
that's what prompted my question.

> And it was done to a large swath of serial and TTY drivers.
> 
> The author of these changes doesn't even grok that receive interrupts
> for these devices can be enabled even if TTY is NULL.

I guarantee Jiri groks that, since he authored these patches with that
very concern in mind (despite his momentary confusion).

The whole motivation behind this series is to have tty (and by
extension, console) drivers __always__ drive input if they have some,
without checking if tty == NULL. All the input is buffered anyway.

[BTW, that's why you were seeing that "tty == NULL" WARN earlier. That
message uncovered an entire class of hangs, oops, and access-after-free
errors. But now that drivers push input all the time, it's pointless.
Those hangs, oops and accesses-after-free are still happening though.]

By ignoring the tty lifetime, a whole collection of race conditions that
tty drivers were not handling properly go away.

Plus, since the actual handling of any input was scheduled anyway, the
mechanism for 'holding a tty reference while scheduling the push' was
pointless. The instant the reference was dropped the tty could go away
before flush_to_ldisc() might even run.

Now, it could be that other problems show up as a result of these
changes, not just with respect to the Sun drivers, but rather,
unforeseen consequences. I think we should address those that come up,
unless we discover this was a bad idea.

Regards,
Peter Hurley

[As an aside, in this driver we've been referencing, it's unclear that
SysRq worked before this change with just the console -- I mean if tty
== NULL, how could uart_handle_break() indicate the SysRq status pending
so that uart_handle_sysrq_char() would actually do anything?]


