Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaH2DJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:09:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaH2DJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:09:45 -0400
Message-ID: <53FFEEC0.4000304@redhat.com>
Date: Fri, 29 Aug 2014 11:08:48 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com>
In-Reply-To: <20140822074224.GB7372@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 03:42 PM, Ingo Molnar wrote:
> * Jason Wang <jasowang@redhat.com> wrote:
>
>> Polling could be done by either rx busy loop in process 
>> context or NAPI in softirq. [...]
> Note that this shows another reason why it's a bad idea to 
> query nr_running directly: depending on the softirq processing 
> method, a softirq might run:
>
>  - directly in process context
>  - in an idle thread's context
>  - or in a ksoftirqd context. 
>
> 'nr_running' will have different values in these cases, causing 
> assymetries in busy-poll handling!

Current rx busy polling code only works in process context, we can add
BUG or warnings to make sure the helper was only called in process context.
>
> Another class of assymetry is when there are other softirq bits 
> pending, beyond NET_RX (or NET_TX): a nr_running check misses 
> them.

Yes, but rx busy polling only works in process context and does not
disable bh, so it may be not an issue.
> The solution I outlined in the previous mail (using a 
> sched_expected_runtime() method) would be able to avoid most of 
> these artifacts.

It only take cares the remaining runnable time for current process, this
is a good hint for sk_busy_loop_end_time() which return the maximum time
a process could do busy polling. But this is not this patch needs. We
need check the state of other runnable process in current cpu to avoid
damaging the performance of other process.
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

