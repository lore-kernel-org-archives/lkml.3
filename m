Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbaH1BHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:07:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaH1BHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:07:06 -0400
Date: Wed, 27 Aug 2014 18:07:03 -0700 (PDT)
Message-Id: <20140827.180703.431737353995283706.davem@davemloft.net>
To: bernat.ada@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] ipv6: sit: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140826134632.GA1473@ada>
References: <20140826134632.GA1473@ada>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Aug 2014 18:07:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Date: Tue, 26 Aug 2014 16:46:32 +0300

> According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
> "3.   The referenced data structure has already been exposed to readers either
> at compile time or via rcu_assign_pointer() -and-
>  a.   You have not made -any- reader-visible changes to this structure since
> then".
> 
> This case fulfills the conditions above because between the rtnl_dereference()
> call and the rcu_assign_pointer() call there is no update of that value.
> Therefore, this patch makes the replacement.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (...,
> (
>  rtnl_dereference(...)
> |
>  rcu_dereference_protected(...)
> ) )
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

These changes are not correct.

We need the memory barrier added by rcu_assign_pointer(), which occurs
before the assignment, otherwise the RCU pointer update might be visible
before the stores that initialize the rest of the structure in question.

I'm not applying any of these patches, sorry.
