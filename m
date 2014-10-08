Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaJHUDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:03:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaJHUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:03:05 -0400
Date: Wed, 08 Oct 2014 16:03:01 -0400 (EDT)
Message-Id: <20141008.160301.394010995208640934.davem@davemloft.net>
To: christophe.leroy@c-s.fr
Cc: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: fs_enet: Remove non NAPI RX and add NAPI for
 TX
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141007130454.13EF21AB266@localhost.localdomain>
References: <20141007130454.13EF21AB266@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 13:03:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Tue,  7 Oct 2014 15:04:53 +0200 (CEST)

> When using a MPC8xx as a router, 'perf' shows a significant time spent in 
> fs_enet_interrupt() and fs_enet_start_xmit().
> 'perf annotate' shows that the time spent in fs_enet_start_xmit is indeed spent
> between spin_unlock_irqrestore() and the following instruction, hence in
> interrupt handling. This is due to the TX complete interrupt that fires after
> each transmitted packet.
> This patchset first remove all non NAPI handling as NAPI has become the only
> mode for RX, then adds NAPI for handling TX complete.
> This improves NAT TCP throughput by 21% on MPC885 with FEC.
> 
> Tested on MPC885 with FEC.
> 
> [PATCH 1/2] net: fs_enet: Remove non NAPI RX
> [PATCH 2/2] net: fs_enet: Add NAPI TX
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Series applied, thanks.

Any particular reason you didn't just put the TX reclaim calls into
the existing NAPI handler?

That's what other drivers do, because TX reclaim can make SKBs
available for RX packet receive on the local cpu.  So generally you
have one NAPI context that first does any pending TX reclaim, then
polls the RX ring for new packets.

