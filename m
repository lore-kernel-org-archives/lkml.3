Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3EMLVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:21:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44437 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3EMLVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:21:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>, paulmck@linux.vnet.ibm.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time as with v3.9
Date: Mon, 13 May 2013 13:30:05 +0200
Message-ID: <136862945.66DBfZPmr6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130512172058.GB6205@pd.tnic>
References: <87r4hdjsu5.fsf@nemi.mork.no> <87ehdcuofr.fsf@nemi.mork.no> <20130512172058.GB6205@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 12, 2013 07:20:58 PM Borislav Petkov wrote:
> On Sun, May 12, 2013 at 06:56:40PM +0200, Bjørn Mork wrote:
> > Borislav Petkov <bp@alien8.de> writes:
> > > On Sun, May 12, 2013 at 06:13:34PM +0200, Bjørn Mork wrote:
> > >> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > >> index 6934238..2dcbf84 100644
> > >> --- a/kernel/rcutree.c
> > >> +++ b/kernel/rcutree.c
> > >> @@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
> > >>  {
> > >>  	switch (action) {
> > >>  	case PM_HIBERNATION_PREPARE:
> > >> +	case PM_SUSPEND_PREPARE:
> > >>  		rcu_expedited = 1;
> > >>  		break;
> > >> -	case PM_POST_RESTORE:
> > >> +	case PM_POST_HIBERNATION:
> > >> +	case PM_POST_SUSPEND:
> > >>  		rcu_expedited = 0;
> > >>  		break;
> > >>  	default:
> > >
> > > If I'm reading Documentation/power/notifiers.txt correctly, we only need
> > > PM_HIBERNATION_PREPARE when we go to sleep (whatever hibernation method
> > > we use) and PM_POST_HIBERNATION when we restore.
> > 
> > Well, that's not the way I read it. And testing also supports that.
> > 
> > Adding the above to your patch makes restore from suspend use < 3
> > seconds again.  Using only PM_HIBERNATION_PREPARE had no effect on the
> > restore from suspend time, still measured at around 15 seconds on my
> > laptop.
> 
> Hmm, that could be because suspend.c does PM_SUSPEND_PREPARE and
> hibernate.c does PM_HIBERNATION_PREPARE. So the statement
> 
> "PM_HIBERNATION_PREPARE  The system is going to hibernate or suspend,"
> 
> is wrong.

Yes, this is incorrect.  It should be "The system is going to hibernate".

> Hi Rafael, it seems to me that if we need to do something for both sleep
> methods, we have different notifier states and we have to add them both
> if we want to do stuff for both, correct?

Yes, that's correct.

The reason why is that hibernation does extra work between notifiers and
freezing drivers (also the "freezing" is not the same as "suspending").

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
