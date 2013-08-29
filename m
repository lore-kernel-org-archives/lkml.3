Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3H2UwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:52:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61653 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3H2UwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130829204509.GA7995@rhlx01.hs-esslingen.de>
References: <20130828211312.GB18971@mtj.dyndns.org>
	<20130829204509.GA7995@rhlx01.hs-esslingen.de>
Date: Thu, 29 Aug 2013 13:52:19 -0700
Message-ID: <CAKU+Ga9Zpu_9i68H-j0nLai7rACwwtkqG2r4_4Tf8MHqBebGmw@mail.gmail.com>
Subject: Re: [PATCH] workqueue: defer to waiting stop_machine
From: Jamie Liu <jamieliu@google.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Just calling cond_resched() does appear to be the more general
solution, and is already on tj/wq/for-next as
b22ce2785d97423846206cceec4efee0c4afd980 "workqueue: cond_resched()
after processing each work item".

Thanks,
Jamie

On Thu, Aug 29, 2013 at 1:45 PM, Andreas Mohr <andi@lisas.de> wrote:
>> Isn't the problem that the kworker wouldn't yield to the higher
>> priority stopper task while a work item keeps requeueing itself if
>> preemption is not enabled?  If so, isn't the correct solution just
>> adding cond_resched() in the work item processing loop?  The analysis
>> and solution seem to have gone a bit stray....
>
> While I did not quite follow the very fine and detailed analysis,
> I had the same feeling about it.
>
> The previous solution seemed less preferable e.g. for two reasons,
> from a modularity/dependency POV:
> - required a very specific (code smell?) stop_machine handling dependency
>   in work queue code (machine stop handling arguably definitely
>   is a corner case, and thereby supposed to remain just that!)
> - new stop_machine_pending() helper is pretty bloated,
>   and called in a semi-hotpath to boot (since it's using && operators
>   rather than ||, seems like it would be called pretty much every time)
>
> Preemption checks being expected to be much more general and widespread
> thus seems like a much better fit.
>
>
> Or, to put it another way, could it be that that extra very specific
> stop_machine check was simply added since due to missing preemption checks
> we were busy-handling there and thus not getting back to standard handling areas
> where some *usual*, *hotpath/mainstream* stop_machine checks would have been made?
> If so, perhaps there actually are some other cases of wasteful stop_machine check
> code sites in the kernel where instead we could simply have a much cheaper
> reschedule done, thereby go back to hitting one central (and thus cache-hot)
> code site with stop_machine check etc.?
>
>
> Afraid of having stated the glaringly obvious ;),
>
> Andreas Mohr
