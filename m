Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3CLCzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:55:46 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:61618 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3CLCzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:55:45 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 22:55:44 EDT
Date: Tue, 12 Mar 2013 03:49:32 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lubomir Rintel <lubo.rintel@gooddata.com>
Subject: Re: [PATCH] mv643xx_eth: Fix a possible deadlock upon ifdown
Message-ID: <20130312024932.GF850@wantstofly.org>
References: <1357308422-19639-1-git-send-email-lkundrak@v3.sk>
 <20130104202509.GX27530@wantstofly.org>
 <5130E5A5.90303@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5130E5A5.90303@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 06:30:13PM +0100, Alexander Holler wrote:

> >>From: Lubomir Rintel <lubo.rintel@gooddata.com>
> >>
> >>=================================
> >>[ INFO: inconsistent lock state ]
> >>3.7.0-6.luboskovo.fc19.armv5tel.kirkwood #1 Tainted: G        W
> >>---------------------------------
> >>inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> >>NetworkManager/337 [HC0[0]:SC0[0]:HE1:SE1] takes:
> >>  (_xmit_ETHER#2){+.?...}, at: [<bf07adfc>] txq_reclaim+0x54/0x264 [mv643xx_eth]
> 
> I get the same annoying warning when the MTU gets changed (through dhcp).

That is actually an issue.


> >Maybe I'm not reading it right, but I doubt that this is an actual
> >deadlock or that the patch is needed.
> >
> >txq_reclaim() indeed doesn't disable BHs, but that's because it's
> >always called in BH context.  Almost always -- the only exception is
> >txq_deinit(), called from ->ndo_stop(), but by that time we've
> >already napi_disable()'d and netif_carrier_off()'d and free_irq()'d.
> 
> Agreed. I've just read me through that too and don't think a
> deadlock is possible.
> 
> >How to explain that to lockdep, though, I don't know.
> 
> The patch helps with that. ;)

It fixes a bug (the MTU change thing) and a non-bug (the lockdep
warning) at the expense of slowing down the much more common path,
and I don't like it for that reason.

Can you make a __txq_reclaim() which is basically txq_reclaim()
without grabbing the tx queue lock, and then move the lock grabbing
to the caller?

E.g. make __txq_reclaim() have two callers, txq_reclaim() and
txq_reclaim_bh(), and then use the appropriate wrapper depending on
the context.  (tx queue lock but no BH disable when called from
mv643xx_eth_poll(), tx queue lock plus BH disable for MTU change,
and no locking at all when called from ->ndo_stop().  Something
like that.)
