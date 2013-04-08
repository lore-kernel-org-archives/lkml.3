Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666Ab3DHTYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:24:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761523Ab3DHTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:24:54 -0400
Date: Mon, 08 Apr 2013 15:24:49 -0400 (EDT)
Message-Id: <20130408.152449.169732563685022388.davem@davemloft.net>
To: sam@ravnborg.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        peterz@infradead.org, magnus.damm@gmail.com
Subject: Re: [PATCH] sparc: Use generic idle loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130408171035.GA27264@merkur.ravnborg.org>
References: <20130401090620.GA24861@merkur.ravnborg.org>
	<5162B92E.6020703@linux.vnet.ibm.com>
	<20130408171035.GA27264@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 12:24:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 8 Apr 2013 19:10:35 +0200

> I think not.
> local_irq_disable writes 0 to the PIL register,
> whereas the above code set the IE (Interrupt enable) bit to 0.
> 
> So the implementations differs - and I think there is a good
> reason for being so.
> 
> But this is the part where I refer to that I am fooling around
> in code that I do not understand.
> I re-checked the SPARC V9 manual - but I did not within a few minutes
> reading understand what is the difference between the twoo.

Device interrupts arrive first as high-priority interrupt packets
that are serviced by traps which are enabled only if PSTATE.IE is
set.

These trap handlers reschedule the interrupt quickly into a PIL
levelled interrupt, whose delivery is covered by (%pil & PSTATE.IE)

The sun4v sleeping code requires that we have PSTATE.IE clear over
the cpu sleep hypervisor call.

