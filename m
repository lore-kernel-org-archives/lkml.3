Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3CELIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:08:37 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:34686 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3CELIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:08:36 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 06:08:35 EST
Message-ID: <5135D072.8070101@suse.cz>
Date: Tue, 05 Mar 2013 12:01:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
References: <20130301.164711.326215889038834651.davem@davemloft.net> <20130301.170056.382924644594872197.davem@davemloft.net>
In-Reply-To: <20130301.170056.382924644594872197.davem@davemloft.net>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 11:00 PM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 01 Mar 2013 16:47:11 -0500 (EST)
> 
>>
>> I'm getting these non-stop right when the hypervisor console registers
>> on sparc64, and the machine won't boot up properly.  This is with
>> Linus's current tree.
> 
> As a quick addendum I'm looking at all of these tty_insert_flip_char()
> conversions and I'm extremely disappointed.
> 
> Let's just look at just two of the sparc drivers converted in commit
> 92a19f9cec9a80ad93c06e115822deb729e2c6ad, namely sunhv.c and sunsab.c.
> 
> The changes to the uart_handle_sysrq_char() call sites are handled
> completely differently in these two drivers, in nearly identical
> situations.  How can this be correct?
> 
> In the sunhv.c case the uart_handle_sysrq_char() call is preserved
> but the guarding test is changed from:
> 
> 	if (tty == NULL)
> 
> into
> 
> 	if (port->start == NULL)
> 
> Whereas in the sunsab.c case, the entire guarding test as well as
> the uart_handle_sysrq_char() invocation itself are both
> completly removed.
> 
> How in the world can that be right?
> 
> Either the receive_chars() method's invocations of
> uart_handle_sysrq_char() should be retained, or this sysrq processing
> is handled now elsewhere and in which case that should be documented
> clearly and in detail in the commit log message.

Ok, uart_handle_sysrq_char is still there, in both of them. But since we
do not care about the tty pointer in those routines any more, the tty ==
NULL test is removed along with its body. I didn't considered that so
critical to document that in the commit log. I thought it's obvious.

All those "if (port->state == NULL)"'s are mostly wrong. Look for
example to subsab's receive_chars and transmit_chars. One checks that,
one dereferences that immediately OTOH. Yes, serial_core should ensure
the interrupts are off by the time port->state is NULL (by calling
driver's ->shutdown). I will remove the test from receive_chars too
which will make the code cleaner.

I left that "if (port->start == NULL)" in sunhv in place because it
behaves completely differently. It checks port->start on all paths prior
dereferencing it. And it does not stop interrupts on ->shutdown.

thanks,
-- 
js
suse labs
