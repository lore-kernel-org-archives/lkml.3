Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3HSLDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:03:03 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:30413 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3HSLDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:03:01 -0400
Message-ID: <5211FAB3.7080400@huawei.com>
Date: Mon, 19 Aug 2013 19:00:03 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>, Thomas Graf <tgraf@suug.ch>
Subject: Re: 3.11-rc6 genetlink locking fix offends lockdep
References: <alpine.LNX.2.00.1308182143370.906@eggly.anvils> <1376899214.14734.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1376899214.14734.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/19 16:00, Johannes Berg wrote:
> 
>> 3.11-rc6's commit 58ad436fcf49 ("genetlink: fix family dump race")
>> gives me the lockdep trace below at startup.
> 
> Hmm. Yes, I see now how this happens, not sure why I didn't run into it.
> 
> The problem is that genl_family_rcv_msg() is called with the genl_lock
> held, and then calls netlink_dump_start() with it held, creating a
> genl_lock->cb_mutex dependency, but obviously the dump continuation is
> the other way around.
> 
> We could use the semaphore instead, I believe, but I don't really
> understand the mutex vs. semaphore well enough to be sure that's
> correct.
> 
> johannes
> 
it is useless, the logic need to modify or otherwise it will still call lockdep trace.
maybe i could send a patch for it, if you wish.

> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index f85f8a2..6cfa646 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -792,7 +792,7 @@ static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
>  	bool need_locking = chains_to_skip || fams_to_skip;
>  
>  	if (need_locking)
> -		genl_lock();
> +		down_read(&cb_lock);
>  
>  	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
>  		n = 0;
> @@ -815,7 +815,7 @@ errout:
>  	cb->args[1] = n;
>  
>  	if (need_locking)
> -		genl_unlock();
> +		up_read(&cb_lock);
>  
>  	return skb->len;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


