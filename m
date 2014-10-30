Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbaJ3JDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:03:19 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52376 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbaJ3JDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:03:14 -0400
Message-ID: <1414659789.10491.9.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH] drivers: s390: net: ctcm: migrate variables to handle
 y2038 problem
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, opw-kernel@googlegroups.com
Date: Thu, 30 Oct 2014 10:03:09 +0100
In-Reply-To: <20141029160234.GA5003@localhost.localdomain>
References: <20141029160234.GA5003@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103009-0021-0000-0000-00000197AC82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aya,

thanks for this patch and thanks for calling our attention to this
future problem in our code. Here you come up with a solution optimized
for "accuracy", but you mention already an alternative solution
optimized for "speed". In ctcm the time stamps are just used to deliver
a statistic value. Since the time stamps are used in the hot traffic
path of the ctcm-driver, I prefer the "speed" optimized solution based
on jiffies here.

Regards, Ursula Braun

On Wed, 2014-10-29 at 18:02 +0200, Aya Mahfouz wrote:
> This patch is concerned with migrating the time variables for the s390
> network driver. The changes handle the y2038 problem where timespec will
> overflow in the year 2038. timespec64 and unsigned long long were used
> instead of timespec and unsigned long respectively in two files.
> All timespec variables use monotonic time values through the function
> ktime_get_ts64(). This is to make sure that all the time values
> are calculated from a fixed point.
> 
> Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
> ---
> v1: Arnd has advised me to provide you with options for time 
>     calculation. The first option: "accuracy" is used in this
>     patch. The second option: "speed" can be done through
>     jiffies and current_kernel_time().
> 
>  drivers/s390/net/ctcm_fsms.c | 18 +++++++++++-------
>  drivers/s390/net/ctcm_main.h |  4 ++--
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
> index fb92524..233aef8 100644
> --- a/drivers/s390/net/ctcm_fsms.c
> +++ b/drivers/s390/net/ctcm_fsms.c
> @@ -250,8 +250,10 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
>  	struct sk_buff *skb;
>  	int first = 1;
>  	int i;
> -	unsigned long duration;
> -	struct timespec done_stamp = current_kernel_time(); /* xtime */
> +	unsigned long long duration;
> +	struct timespec64 done_stamp;
> +
> +	ktime_get_ts64(&done_stamp);
> 
>  	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
> 
> @@ -307,7 +309,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
>  		spin_unlock(&ch->collect_lock);
>  		ch->ccw[1].count = ch->trans_skb->len;
>  		fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
> -		ch->prof.send_stamp = current_kernel_time(); /* xtime */
> +		ktime_get_ts64(&ch->prof.sendstamp);
>  		rc = ccw_device_start(ch->cdev, &ch->ccw[0],
>  						(unsigned long)ch, 0xff, 0);
>  		ch->prof.doios_multi++;
> @@ -1224,12 +1226,14 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
>  	int		first = 1;
>  	int		i;
>  	__u32		data_space;
> -	unsigned long	duration;
> +	unsigned long long	duration;
>  	struct sk_buff	*peekskb;
>  	int		rc;
>  	struct th_header *header;
>  	struct pdu	*p_header;
> -	struct timespec done_stamp = current_kernel_time(); /* xtime */
> +	struct timespec64 done_stamp;
> +
> +	ktime_get_ts64(&done_stamp);
> 
>  	CTCM_PR_DEBUG("Enter %s: %s cp:%i\n",
>  			__func__, dev->name, smp_processor_id());
> @@ -1361,7 +1365,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
> 
>  	ch->ccw[1].count = ch->trans_skb->len;
>  	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
> -	ch->prof.send_stamp = current_kernel_time(); /* xtime */
> +	ktime_get_ts64(&ch->prof.send_stamp);
>  	if (do_debug_ccw)
>  		ctcmpc_dumpit((char *)&ch->ccw[0], sizeof(struct ccw1) * 3);
>  	rc = ccw_device_start(ch->cdev, &ch->ccw[0],
> @@ -1827,7 +1831,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
>  	fsm_newstate(wch->fsm, CTC_STATE_TX);
> 
>  	spin_lock_irqsave(get_ccwdev_lock(wch->cdev), saveflags);
> -	wch->prof.send_stamp = current_kernel_time(); /* xtime */
> +	ktime_get_ts64(&wch->prof.send_stamp);
>  	rc = ccw_device_start(wch->cdev, &wch->ccw[3],
>  					(unsigned long) wch, 0xff, 0);
>  	spin_unlock_irqrestore(get_ccwdev_lock(wch->cdev), saveflags);
> diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
> index 477c933..ed7d44a 100644
> --- a/drivers/s390/net/ctcm_main.h
> +++ b/drivers/s390/net/ctcm_main.h
> @@ -120,8 +120,8 @@ struct ctcm_profile {
>  	unsigned long doios_single;
>  	unsigned long doios_multi;
>  	unsigned long txlen;
> -	unsigned long tx_time;
> -	struct timespec send_stamp;
> +	unsigned long long tx_time;
> +	struct timespec64 send_stamp;
>  };
> 
>  /*


