Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaHKK0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:26:18 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:43426 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaHKK0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:26:16 -0400
Message-ID: <53E89A36.80104@mentor.com>
Date: Mon, 11 Aug 2014 15:55:58 +0530
From: Deepak <deepak_das@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] net: Replace del_timer() with del_timer_sync()
References: <53E31A47.9000407@mentor.com> ,<1407394542.11943.21.camel@edumazet-glaptop2.roam.corp.google.com>  <38E11AEFEB035045A1BA4C1177FBFC424A89BEBE@EU-MBX-03.mgc.mentorg.com> <1407430083.11943.37.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1407430083.11943.37.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2014 10:26:07.0292 (UTC) FILETIME=[A98117C0:01CFB54E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the clarification Eric.
I re-analysed the code and found that sk_stop_timer() is called under 
lock_sock(sk)/bh_lock_sock(sk) so we can not replace del_timer() with 
del_timer_sync() here and will lead to dead-lock as you suggested .

Thanks,
Deepak Das

On Thursday 07 August 2014 10:18 PM, Eric Dumazet wrote:
> On Thu, 2014-08-07 at 15:15 +0000, Das, Deepak wrote:
>
> Please do not top post on netdev, thanks.
>
>> I apologies for not explaining the scenario previously.
>>
>> sk_stop_timer() is used to stop the tcp timers with expiry callback
>> tcp_write_timer(), tcp_delack_timer(), tcp_keepalive_timer(), ...
>> del_timer() is used to stop the the timer in sk_stop_timer(), which
>> might return a non-zero result even if one of these timer handler functions
>> (tcp_write_timer(), tcp_delack_timer(), tcp_keepalive_timer(), ...)
>> is already executing on another processor.
>>
>> Following is the possible scenario :-
>> on CPU #0: sk_stop_timer() decrements the sk->sk_refcnt if del_timer(timer)
>> returns non-zero.
>>
>> on CPU #1: If a timer handler callback runs then it also calls sock_put(sk)
>> which decrements sk->sk_refcnt and if the sk_refcnt becomes zero it frees the
>> structure sock pointed to by sk.
>>
>> if the sk->sk_refcnt decrements twice then that will cause a mismatch in the
>> number of "puts" and "holds" resulting in a malfunction of the sk->sk_refcnt mechanism.
> Not at all.
>
> There is no mismatch, sk_refcnt is decremented once in all cases.
>
> I believe you misunderstood del_timer_sync() / del_timer() behaviors and
> differences.
>
> In the case you describe, del_timer() should return 0, and timer
> function will call sock_put() to decrement socket refcount.
>
> The problem' of del_timer() is the following :
>
> When/If it returns 0, another cpu _might_ be running the timer, we have
> no guarantee timer function is completed.
>
> For sockets, we do not care, because the active timer owns a refcount on
> the socket. When timer is finally completed, refcount will be released.
>
>> The solution is to use del_timer_sync() instead of del_timer()
>> because del_timer_sync() will wait for timer handler functions to
>> complete execution.
> Except that some sk_stop_timer() callers hold the socket lock, so the
> timer will deadlock trying to acquire it.
>
>> yes, we are facing some memory corruption issues due to access of already released
>> struct sock in our environment. Our memory corruption issue looks like memory locations
>> being decremented which could be consistent with a rogue decrement of a reference counter.
> Is 'Your environment' some out of tree module or is it part of standard
> linux kernel ?
>
>> similar suggestion is also made by Dean Jenkins in rfcomm_dlc_clear_timer() and accepted by Marcel.
>> http://www.spinics.net/lists/linux-bluetooth/msg51132.html
> Fix might be good in this case, but the changelog is completely bogus.
>
>
>

