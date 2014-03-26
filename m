Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaCZUKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:10:40 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57641 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075AbaCZUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:10:38 -0400
Message-ID: <53333438.3070107@hurleysoftware.com>
Date: Wed, 26 Mar 2014 16:10:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] [RFC] serial_core: Avoid NULL pointer dereference
 in uart_close()
References: <1395061859-15295-1-git-send-email-geert@linux-m68k.org>	<1395061859-15295-2-git-send-email-geert@linux-m68k.org>	<532CA142.8060705@hurleysoftware.com> <CAMuHMdWZw-_+RVe0RuwfR+smuiDY9HpMq7H9=rseP_XLGytU0A@mail.gmail.com>
In-Reply-To: <CAMuHMdWZw-_+RVe0RuwfR+smuiDY9HpMq7H9=rseP_XLGytU0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 02:58 PM, Geert Uytterhoeven wrote:
> Hi Peter,
>
> Thanks for your comments!

Not a problem; just wanted to save you some time and frustration :)

> On Fri, Mar 21, 2014 at 9:29 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> On 03/17/2014 09:10 AM, Geert Uytterhoeven wrote:
>>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>> When unbinding a serial driver that's being used as a serial console,
>>> the kernel may crash with a NULL pointer dereference in a uart_*()
>>> function
>>> called from uart_close () (e.g. uart_flush_buffer() or
>>> uart_chars_in_buffer()).
>>>
>>> To fix this, let uart_close() check for port->count == 0. If this is the
>>> case, bail out early. Else tty_port_close_start() will make the port
>>> counts inconsistent, printing out warnings like
>>>
>>>       tty_port_close_start: tty->count = 1 port count = 0.
>>>
>>> and
>>>
>>>       tty_port_close_start: count = -1
>>
>> As you noted in the patch comments below, the tty core always closes
>> a failed open.
>>
>> So the reason for the port->count mismatch is because tty_port_close_start()
>> only handles the tty hangup condition -- all other failed opens are assumed
>> to carry a port->count.
>>
>> A similar mismatch will occur if the mutex_lock in uart_open() is
>> interrupted.
>>
>> This means that the port->count mismatch can occur even if port->count != 0;
>> so the bug here is that uart_open() and uart_close() don't agree on
>> who does what cleanup under what error conditions.
>>
>> So with respect to the port count mismatches, the conditions need careful
>> auditing and fixing, separate from the tty console teardown problem.
>
> Indeed. Currently uart_open() always decrements port->count again
> in any error condition, which is clearly wrong.

I started looking at this problem only to realize that the
tty_hung_up_p() condition in uart_open() can't actually happen.

Which has lead me to a bunch of cleanups and fixes that I'm still
working on. It's just slow going because tty code audit takes
forever with legacy intentions that no longer apply and some of
the bit-rotting tty drivers that I doubt even run.

>>> and once uport == NULL, it will also crash.
>>
>> Ok, but so will basically every serial core function after
>> uart_remove_one_port() assigns state->uart_port = NULL
>>
>> IOW, uart_close() is not the only serial core function that could be
>> using state->uart_port after uart_remove_one_port() finishes.
>>
>>> Also fix the related crash in pr_debug() by checking for a non-NULL uport
>>> first.
>>
>> So my point is that checking for NULL state->uart_port is simply not the
>> fix,
>> here or anywhere else.
>>
>> AFAICT, either reference-counting the uart_port structure or RCU
>> are the only viable solutions to safe ll driver uart_port removal.
>
> I gave it a quick try, but failed. It seems the driver needs some big surgery
> to fix this.

I figured that would be true.
What are the circumstances of device removal in your case?

Regards,
Peter Hurley

