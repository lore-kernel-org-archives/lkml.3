Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3ELQ1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:27:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45178 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3ELQ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:27:19 -0400
Date: Sun, 12 May 2013 18:27:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130512162717.GA6305@pd.tnic>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <87hai8kwgh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87hai8kwgh.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:13:34PM +0200, Bjørn Mork wrote:
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 6934238..2dcbf84 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
>  {
>  	switch (action) {
>  	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
>  		rcu_expedited = 1;
>  		break;
> -	case PM_POST_RESTORE:
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
>  		rcu_expedited = 0;
>  		break;
>  	default:

If I'm reading Documentation/power/notifiers.txt correctly, we only need
PM_HIBERNATION_PREPARE when we go to sleep (whatever hibernation method
we use) and PM_POST_HIBERNATION when we restore.

I don't think it matters for expediting RCU grace periods whether
we had an error during resume or not and I'd basically want to set
rcu_expedited to 0 unconditionally when resuming..

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
