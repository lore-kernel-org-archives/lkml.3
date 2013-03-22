Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636Ab3CVJNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:13:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab3CVJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:13:19 -0400
Date: Fri, 22 Mar 2013 10:13:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Parag Warudkar <parag.lkml@gmail.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        senthilb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k : Fix ieee80211 work while going to suspend
Message-ID: <20130322091342.GB1496@redhat.com>
References: <CAOULuOb0_40EX+6A_HM8eJN7kj9J4WhO9UhZbUUqng1Sfy_SQg@mail.gmail.com>
 <20130318191340.GA28919@tuxdriver.com>
 <20130318210308.GD32416@pogo>
 <20130321114219.GB1459@redhat.com>
 <20130321193331.GB32416@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321193331.GB32416@pogo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:33:31PM -0700, Luis R. Rodriguez wrote:
> So when does this work get called?
> 
> Given the trace this is hit when the timer rx_poll_timer runs,
> which in turn calls ath_rx_poll() to schedule hw_check_work work.
> The rx_poll_timer however was originally only set at the end of
> the routine that hw_check_work sets off but also at other entry
> points (ath_start_rx_poll() callers). Once ath_start_rx_poll()
> gets called though we can go on looping as follows:
> 
> work			timer			work
> hw_check_work	-->	rx_poll_timer	-->	hw_check_work
>
> At suspend time we do this though:
> 
> ath_cancel_work(sc);                                                    
> del_timer_sync(&sc->rx_poll_timer);  
>  
> +	del_timer_sync(&sc->rx_poll_timer);
>  	ath_cancel_work(sc);
>  	ath_stop_ani(sc);
> -	del_timer_sync(&sc->rx_poll_timer);

[snip]

> But then we have the chicken and the egg problem, as the work item
> could fire off the timer so it would seem to be good to prevent
> adding new work when suspending.

Yup, this is egg and chicken problem, I think it can not be fixed by
changing ordering of del_timer and cancel_work, it would be like:

del_timer_sync(&sc->rx_poll_timer);
/* but timer could schedule work */
ath_cancel_work(sc);
/* but work could schedule timer */ 
del_timer_sync(&sc->rx_poll_timer);
/* but timer could schedule work */
ath_cancel_work(sc);
/* And so on ... */

Check is needed in work or timer callback, depending what is canceled
last, to fix the problem ...

> > In mac80211 we use local->suspended and local->quiesce booleans to
> > prevent reschedule of timers when going to suspend for example.
> > Works use ifmgd->associted to prevent reschedule when we are
> > disassociating.
> > 
> > I think on ath9k also some boolean variable should be used, not only
> > for rx_poll_timer but also for other works i.e. tx_complete_work.
> > Is possible to use SC_OP_INVALID flags, since mac80211 call ath9k_stop
> > on suspend and ath9k_start on resume.
> 
> Indeed however ieee80211_queue_work() already does a suspend check for
> us, it just complains as many drivers including mac80211 were setting
> up work incorrectly. The warning was put in place to help us find the
> issues. Using SC_OP_INVALID seems fair but we could also add a routine
> ieee80211_queue_work_safe() that silently fails if we are quiescing or
> suspended and not resuming but I can see that creating very sloppy
> driver writing and everyone abusing it.

We also have to reliable cancel works on ath9k_stop() if device goes
down for other reason than suspend, new mac80211 ieee80211_queue_work_safe()
routine will not help with that.

> OK how about this for stable for now:
> 
> diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
> index 39c84ec..7fdac6c 100644
> --- a/drivers/net/wireless/ath/ath9k/link.c
> +++ b/drivers/net/wireless/ath/ath9k/link.c
> @@ -170,7 +170,8 @@ void ath_rx_poll(unsigned long data)
>  {
>  	struct ath_softc *sc = (struct ath_softc *)data;
>  
> -	ieee80211_queue_work(sc->hw, &sc->hw_check_work);
> +	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
> +		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
>  }

That looks ok for me as -stable fix

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

Stanislaw 
