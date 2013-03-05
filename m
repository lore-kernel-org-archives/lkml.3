Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3CEUyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:54:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54215 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab3CEUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:53:05 -0500
Date: Tue, 05 Mar 2013 15:53:00 -0500 (EST)
Message-Id: <20130305.155300.1299712636968046625.davem@davemloft.net>
To: peter@hurleysoftware.com
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362516424.18799.81.camel@thor.lan>
References: <51364B31.1010808@suse.cz>
	<20130305.150338.470704111422696046.davem@davemloft.net>
	<1362516424.18799.81.camel@thor.lan>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 12:53:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>
Date: Tue, 05 Mar 2013 15:47:04 -0500

> On Tue, 2013-03-05 at 15:03 -0500, David Miller wrote:
>> From: Jiri Slaby <jslaby@suse.cz>
>> Date: Tue, 05 Mar 2013 20:44:49 +0100
>> 
>> > Hi, I must admit I don't understand. I now checked both of them and they
>> > call uart_handle_sysrq_char unconditionally, or?
>> 
>> Nope, in the sunsab.c receive function, we used to handle the SYSRQ
>> stuff before break checking when TTY is NULL, now we don't.
> 
> Hi David,
> 
> SysRq is signalled first by a BRK condition, then followed by the input
> character indicating which SysRq function to perform.
> 
> sunsab.c: receive_char() is behaving as you would expect.
> 
> First, a BRK status is indicated so uart_handle_break() records a
> timestamp. If the next input is received within 5 sec. of that
> timestamp, the character received is interpreted as a SysRq function --
> handled by uart_handle_sysrq_char().
> 
> Are you observing that SysRq processing is not occurring with this
> driver when only a console exists, or are you hypothesizing that this is
> possible?

Before we go down this road we need to first address the fact that
non-trivial semantic changes we made to these functions without any
of that being documented.

And it was done to a large swath of serial and TTY drivers.

The author of these changes doesn't even grok that receive interrupts
for these devices can be enabled even if TTY is NULL.
