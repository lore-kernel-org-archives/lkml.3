Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3ELRVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 13:21:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50582 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3ELRVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 13:21:02 -0400
Date: Sun, 12 May 2013 19:20:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130512172058.GB6205@pd.tnic>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <87hai8kwgh.fsf@nemi.mork.no>
 <20130512162717.GA6305@pd.tnic>
 <87ehdcuofr.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ehdcuofr.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:56:40PM +0200, Bjørn Mork wrote:
> Borislav Petkov <bp@alien8.de> writes:
> > On Sun, May 12, 2013 at 06:13:34PM +0200, Bjørn Mork wrote:
> >> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> >> index 6934238..2dcbf84 100644
> >> --- a/kernel/rcutree.c
> >> +++ b/kernel/rcutree.c
> >> @@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
> >>  {
> >>  	switch (action) {
> >>  	case PM_HIBERNATION_PREPARE:
> >> +	case PM_SUSPEND_PREPARE:
> >>  		rcu_expedited = 1;
> >>  		break;
> >> -	case PM_POST_RESTORE:
> >> +	case PM_POST_HIBERNATION:
> >> +	case PM_POST_SUSPEND:
> >>  		rcu_expedited = 0;
> >>  		break;
> >>  	default:
> >
> > If I'm reading Documentation/power/notifiers.txt correctly, we only need
> > PM_HIBERNATION_PREPARE when we go to sleep (whatever hibernation method
> > we use) and PM_POST_HIBERNATION when we restore.
> 
> Well, that's not the way I read it. And testing also supports that.
> 
> Adding the above to your patch makes restore from suspend use < 3
> seconds again.  Using only PM_HIBERNATION_PREPARE had no effect on the
> restore from suspend time, still measured at around 15 seconds on my
> laptop.

Hmm, that could be because suspend.c does PM_SUSPEND_PREPARE and
hibernate.c does PM_HIBERNATION_PREPARE. So the statement

"PM_HIBERNATION_PREPARE  The system is going to hibernate or suspend,"

is wrong.

Hi Rafael, it seems to me that if we need to do something for both sleep
methods, we have different notifier states and we have to add them both
if we want to do stuff for both, correct?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
