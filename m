Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaAITOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:14:53 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44929 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaAITOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:14:44 -0500
Message-ID: <52CEF521.90009@lwfinger.net>
Date: Thu, 09 Jan 2014 13:14:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep problem
References: <52CC474A.7090207@lwfinger.net> <20140109162414.GA1719@redhat.com>
In-Reply-To: <20140109162414.GA1719@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 10:24 AM, Stanislaw Gruszka wrote:
> On Tue, Jan 07, 2014 at 12:28:26PM -0600, Larry Finger wrote:
>>    rtnl_mutex --> misc_mtx --> rfkill_global_mutex
>>
>>    Possible unsafe locking scenario:
>>
>>          CPU0                    CPU1
>>          ----                    ----
>>     lock(rfkill_global_mutex);
>>                                  lock(misc_mtx);
>>                                  lock(rfkill_global_mutex);
>>     lock(rtnl_mutex);
>>
>>   *** DEADLOCK ***
>
> There are 3 mutexes dependency. The deadlock can happen if on another
> cpu, let say CPU2, there will be sequence:
>
> lock(rtnl_mutex);
> lock(misc_mtx);
>
> Then on deadlock scenario:
> CPU0 waits for rtnl_mutex to unlock, keep rfkill_global_mutex locked
> CPU1 waits for rfkill_global_mutex to unlock, keep misc_mtx locked
> CPU2 waits for misc_mtx to unlock, keep rtnl_mutex locked.
>
> This dependency can be broken by moving b43_rng_init() outside from
> rtnl_mutex scope, like on below patch. IIUC b43 random number generator
> works only if we already started network connection, but this should
> not be a problem, as b43_rng_read() do not return any data if device
> is not prepared.
>
> You could also remove whole b43 rnd. Everyone know, that HW vendors
> are influenced by NSA and they random generators do not provide truly
> random numbers (just kidding ;-)

Well, I have no idea to what extent NSA affects the RNGs in computers; however, 
I do like having that additional source of entropy. :)

Your analysis was spot on, and I will be submitting a patch shortly with you as 
author. I'll give the reporter on b.k.o a chance to test it, but it removed the 
splat here.

Thanks,

Larry


