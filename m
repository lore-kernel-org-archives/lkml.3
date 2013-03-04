Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3CDAbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:31:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58046 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3CDAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:31:31 -0500
Date: Sun, 03 Mar 2013 19:31:27 -0500 (EST)
Message-Id: <20130303.193127.656411242317130530.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: samuel@sortiz.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        peter@hurleysoftware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ircomm: release tty before sleeping potentially
 indefintely
From: David Miller <davem@davemloft.net>
In-Reply-To: <5133DA12.8020907@oracle.com>
References: <1362350153-26225-1-git-send-email-sasha.levin@oracle.com>
	<20130303.174739.1195645942179862011.davem@davemloft.net>
	<5133DA12.8020907@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 03 Mar 2013 16:31:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Sun, 03 Mar 2013 18:17:38 -0500

> On 03/03/2013 05:47 PM, David Miller wrote:
>> From: Sasha Levin <sasha.levin@oracle.com>
>> Date: Sun,  3 Mar 2013 17:35:53 -0500
>> 
>>> ircomm_tty_block_til_ready would hold tty lock while blocking. Since the sleep
>>> might take a long time we can prevent other processes from accessing the tty,
>>> causing hung tasks and a dead tty.
>>>
>>> Diagnosed-by: Peter Hurley <peter@hurleysoftware.com>
>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> 
>> But then you invalidate all of the tty state tests made under
>> the lock at the beginning of this function, before enterring
>> the loop.  If you drop the lock, those pieces of state could
>> change.
>> 
>> I'm not applying this.
> 
> I'm unsure. A similar patch was applied back in 2010 that does the same thing
> to a bunch of drivers, including the core tty code (e142a31da "tty: release
> BTM while sleeping in block_til_ready").
> 
> This IR code looks very much like tty_port_block_til_ready() where it was
> okay to do that change, so I should be the same with ircomm_tty_block_til_ready.

That assumes that the other changes don't have the same bug.

Releasing locks are dangerous, because it invalidates the context in
which all previous tests of state have been performed.  Anything can
happen to the TTY once you drop that lock.
