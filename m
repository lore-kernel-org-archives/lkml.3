Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaCDPn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:43:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:63198 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaCDPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:43:28 -0500
Message-ID: <5315F49C.20405@atmel.com>
Date: Tue, 4 Mar 2014 15:43:24 +0000
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Surendra Patil <surendra.tux@gmail.com>, <gregkh@linuxfoundation.org>
CC: <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:staging:ozwpan Replaced wrapper functions with
 actual spin lock function
References: <1393919867-15049-1-git-send-email-surendra.tux@gmail.com>
In-Reply-To: <1393919867-15049-1-git-send-email-surendra.tux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 07:57, Surendra Patil wrote:
> * Replaced all the spin lock/unlock wrappers from oz_polling_lock_bh()
> and oz_polllin_unlock_bh() with spin_lock_bh(&g_polling_lock) and
> spin_unlock_bh(&g_polling_lock).Completely erased the wrappers defination
> and declaration.
> * declared g_polling_lock as global variable in header file and added comments to it.
> Module builded successfully with sparse without warnings.
>
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>   drivers/staging/ozwpan/ozpd.c    | 28 ++++++++++++++--------------
>   drivers/staging/ozwpan/ozpd.h    |  5 +++++
>   drivers/staging/ozwpan/ozproto.c | 15 +++++----------
>   drivers/staging/ozwpan/ozproto.h |  2 --
>   4 files changed, 24 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
> index 7436950..29a23a3 100644
> --- a/drivers/staging/ozwpan/ozpd.c
> +++ b/drivers/staging/ozwpan/ozpd.c
> @@ -284,11 +284,11 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
>   					  ai->app_id);
>   				break;
>   			}
> -			oz_polling_lock_bh();
> +			spin_lock_bh(&g_polling_lock);
>   			pd->total_apps |= (1<<ai->app_id);
>   			if (resume)
>   				pd->paused_apps &= ~(1<<ai->app_id);
> -			oz_polling_unlock_bh();
> +			spin_unlock_bh(&g_polling_lock);
>   		}
>   	}
>   	return rc;
> @@ -304,14 +304,14 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
>   	oz_pd_dbg(pd, ON, "%s: (0x%x) pause(%d)\n", __func__, apps, pause);
>   	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
>   		if (apps & (1<<ai->app_id)) {
> -			oz_polling_lock_bh();
> +			spin_lock_bh(&g_polling_lock);
>   			if (pause) {
>   				pd->paused_apps |= (1<<ai->app_id);
>   			} else {
>   				pd->total_apps &= ~(1<<ai->app_id);
>   				pd->paused_apps &= ~(1<<ai->app_id);
>   			}
> -			oz_polling_unlock_bh();
> +			spin_unlock_bh(&g_polling_lock);
>   			ai->stop(pd, pause);
>   		}
>   	}
> @@ -349,17 +349,17 @@ void oz_pd_stop(struct oz_pd *pd)
>   
>   	oz_dbg(ON, "oz_pd_stop() State = 0x%x\n", pd->state);
>   	oz_pd_indicate_farewells(pd);
> -	oz_polling_lock_bh();
> +	spin_lock_bh(&g_polling_lock);
>   	stop_apps = pd->total_apps;
>   	pd->total_apps = 0;
>   	pd->paused_apps = 0;
> -	oz_polling_unlock_bh();
> +	spin_unlock_bh(&g_polling_lock);
>   	oz_services_stop(pd, stop_apps, 0);
> -	oz_polling_lock_bh();
> +	spin_lock_bh(&g_polling_lock);
>   	oz_pd_set_state(pd, OZ_PD_S_STOPPED);
>   	/* Remove from PD list.*/
>   	list_del(&pd->link);
> -	oz_polling_unlock_bh();
> +	spin_unlock_bh(&g_polling_lock);
>   	oz_dbg(ON, "pd ref count = %d\n", atomic_read(&pd->ref_count));
>   	oz_pd_put(pd);
>   }
> @@ -372,9 +372,9 @@ int oz_pd_sleep(struct oz_pd *pd)
>   	int do_stop = 0;
>   	u16 stop_apps;
>   
> -	oz_polling_lock_bh();
> +	spin_lock_bh(&g_polling_lock);
>   	if (pd->state & (OZ_PD_S_SLEEP | OZ_PD_S_STOPPED)) {
> -		oz_polling_unlock_bh();
> +		spin_unlock_bh(&g_polling_lock);
>   		return 0;
>   	}
>   	if (pd->keep_alive && pd->session_id)
> @@ -383,7 +383,7 @@ int oz_pd_sleep(struct oz_pd *pd)
>   		do_stop = 1;
>   
>   	stop_apps = pd->total_apps;
> -	oz_polling_unlock_bh();
> +	spin_unlock_bh(&g_polling_lock);
>   	if (do_stop) {
>   		oz_pd_stop(pd);
>   	} else {
> @@ -999,15 +999,15 @@ void oz_pd_indicate_farewells(struct oz_pd *pd)
>   	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
>   
>   	while (1) {
> -		oz_polling_lock_bh();
> +		spin_lock_bh(&g_polling_lock);
>   		if (list_empty(&pd->farewell_list)) {
> -			oz_polling_unlock_bh();
> +			spin_unlock_bh(&g_polling_lock);
>   			break;
>   		}
>   		f = list_first_entry(&pd->farewell_list,
>   				struct oz_farewell, link);
>   		list_del(&f->link);
> -		oz_polling_unlock_bh();
> +		spin_unlock_bh(&g_polling_lock);
>   		if (ai->farewell)
>   			ai->farewell(pd, f->ep_num, f->report, f->len);
>   		kfree(f);
> diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
> index 12c7129..56e6fdf 100644
> --- a/drivers/staging/ozwpan/ozpd.h
> +++ b/drivers/staging/ozwpan/ozpd.h
> @@ -22,6 +22,11 @@
>   #define OZ_TIMER_HEARTBEAT	2
>   #define OZ_TIMER_STOP		3
>   
> +/*
> + *External spinlock variable
> + */
> +extern spinlock_t g_polling_lock;
> +
>   /* Data structure that hold information on a frame for transmisson. This is
>    * built when the frame is first transmitted and is used to rebuild the frame
>    * if a re-transmission is required.
> diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
> index e7138ed..c1325a6 100644
> --- a/drivers/staging/ozwpan/ozproto.c
> +++ b/drivers/staging/ozwpan/ozproto.c
> @@ -38,9 +38,13 @@ struct oz_binding {
>   };
>   
>   /*
> + * External variable
> + */
> +
> +DEFINE_SPINLOCK(g_polling_lock);
> +/*
>    * Static external variables.
>    */
> -static DEFINE_SPINLOCK(g_polling_lock);
>   static LIST_HEAD(g_pd_list);
>   static LIST_HEAD(g_binding);
>   static DEFINE_SPINLOCK(g_binding_lock);
> @@ -794,12 +798,3 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
>   	return count;
>   }
>   
> -void oz_polling_lock_bh(void)
> -{
> -	spin_lock_bh(&g_polling_lock);
> -}
> -
> -void oz_polling_unlock_bh(void)
> -{
> -	spin_unlock_bh(&g_polling_lock);
> -}
> diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
> index 0c49c8a..cb38e02 100644
> --- a/drivers/staging/ozwpan/ozproto.h
> +++ b/drivers/staging/ozwpan/ozproto.h
> @@ -59,8 +59,6 @@ void oz_binding_remove(const char *net_dev);
>   void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time);
>   void oz_timer_delete(struct oz_pd *pd, int type);
>   void oz_pd_request_heartbeat(struct oz_pd *pd);
> -void oz_polling_lock_bh(void);
> -void oz_polling_unlock_bh(void);
>   void oz_pd_heartbeat_handler(unsigned long data);
>   void oz_pd_timeout_handler(unsigned long data);
>   enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer);

Acked-by: Rupesh Gujare <rupesh.gujare@atmel.com>

-- 
Regards,
Rupesh Gujare

