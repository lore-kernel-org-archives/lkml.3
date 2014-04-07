Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaDGTS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:18:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaDGTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:18:57 -0400
Date: Mon, 07 Apr 2014 15:18:54 -0400 (EDT)
Message-Id: <20140407.151854.411047851818388937.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sasha.levin@oracle.com, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] decnet: fix possible NULL deref in dnet_select_source()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396821554.12330.51.camel@edumazet-glaptop2.roam.corp.google.com>
References: <5341A3C1.9060101@oracle.com>
	<1396821554.12330.51.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 06 Apr 2014 14:59:14 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> dnet_select_source() should make sure dn_ptr is not NULL.
> 
> While looking at this decnet code, I believe I found a device
> reference leak, lets fix it as well.
>  
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> It seems this bug is very old, no recent change is involved.

The callers work hard to ensure this.

Analyzing all call sites:

1) __dn_fib_res_prefsrc() uses the FIB entry device pointer, we should not
   be adding FIB entries pointing to devices which do not have their
   decnet private initialized yet.

2) dn_route_output_slow()

   The paths leading to the dnet_select_address() call(s) check if
   dev_out->dn_ptr is not NULL, except when using loopback.

In some other paths the device comes from neigh->dev, from which the
'neigh' was looked up in dn_neigh_table.  There should not be neighbour
entries in this table pointing to devices which do not have their
decnet private setup yet.

And in the loopback case, it is the decnet stack's responsibility to
make sure ->dn_ptr is setup properly, else it should fail the module
load and stack initialization.

I think there is some core fundamental issue here, and just adding
a NULL check to dnet_select_source() is just papering around the issue.

Please look closer at the stack trace, this code, and my analysis
above to figure out what's really going on so we can fix this properly.

Thanks.
