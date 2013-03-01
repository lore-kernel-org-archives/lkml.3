Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3CAWA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:00:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33646 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3CAWA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:00:58 -0500
Date: Fri, 01 Mar 2013 17:00:56 -0500 (EST)
Message-Id: <20130301.170056.382924644594872197.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130301.164711.326215889038834651.davem@davemloft.net>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Mar 2013 14:01:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 01 Mar 2013 16:47:11 -0500 (EST)

> 
> I'm getting these non-stop right when the hypervisor console registers
> on sparc64, and the machine won't boot up properly.  This is with
> Linus's current tree.

As a quick addendum I'm looking at all of these tty_insert_flip_char()
conversions and I'm extremely disappointed.

Let's just look at just two of the sparc drivers converted in commit
92a19f9cec9a80ad93c06e115822deb729e2c6ad, namely sunhv.c and sunsab.c.

The changes to the uart_handle_sysrq_char() call sites are handled
completely differently in these two drivers, in nearly identical
situations.  How can this be correct?

In the sunhv.c case the uart_handle_sysrq_char() call is preserved
but the guarding test is changed from:

	if (tty == NULL)

into

	if (port->start == NULL)

Whereas in the sunsab.c case, the entire guarding test as well as
the uart_handle_sysrq_char() invocation itself are both
completly removed.

How in the world can that be right?

Either the receive_chars() method's invocations of
uart_handle_sysrq_char() should be retained, or this sysrq processing
is handled now elsewhere and in which case that should be documented
clearly and in detail in the commit log message.
