Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3F1L05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:26:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab3F1L0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:26:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Gustavo Padovan'" <gustavo.padovan@collabora.co.uk>,
        "'Daniel Drake'" <dsd@laptop.org>,
        "'Marcel Holtmann'" <marcel@holtmann.org>
Subject: Re: [PATCH 3.9-stable]  Bluetooth: btmrvl: fix thread stopping race
References: <002501ce7390$9f7c4750$de74d5f0$%choi@samsung.com>
Date: Fri, 28 Jun 2013 12:26:51 +0100
In-Reply-To: <002501ce7390$9f7c4750$de74d5f0$%choi@samsung.com> (Jonghwan
	Choi's message of "Fri, 28 Jun 2013 08:47:02 +0900")
Message-ID: <8761wy8ohw.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonghwan Choi <jhbird.choi@samsung.com> writes:

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

This seems to be applicable to all the other stable kernels as well
(and its a clean cherry-pick for all of them).  I'm queuing it for the
3.5 kernel.

Cheers,
-- 
Luis


>
> ------------------
>
> From: "Daniel Drake <dsd@laptop.org>"
>
> commit ea05fea9042620ac3b8ab9a3e5e4d2ed80c89244 upstream
>
> There is currently a race condition in the btmrvl_remove_card() which
> is causing hangs on suspend for OLPC. When the race occurs,
> kthread_stop() never returns.
>
> The problem is that btmrvl_service_main_thread() calls kthread_should_stop()
> and then does a fair number of things before restarting the loop and
> sleeping.
>
> If the thread gets stopped after kthread_should_stop() is checked, but
> before the sleep happens, the thread will go to sleep and won't necessarily
> be woken up.
>
> Move the kthread_should_stop() check into a race-free place.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/bluetooth/btmrvl_main.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/bluetooth/btmrvl_main.c
> b/drivers/bluetooth/btmrvl_main.c
> index 3a4343b..9a9f518 100644
> --- a/drivers/bluetooth/btmrvl_main.c
> +++ b/drivers/bluetooth/btmrvl_main.c
> @@ -498,6 +498,10 @@ static int btmrvl_service_main_thread(void *data)
>  		add_wait_queue(&thread->wait_q, &wait);
>  
>  		set_current_state(TASK_INTERRUPTIBLE);
> +		if (kthread_should_stop()) {
> +			BT_DBG("main_thread: break from main thread");
> +			break;
> +		}
>  
>  		if (adapter->wakeup_tries ||
>  				((!adapter->int_count) &&
> @@ -513,11 +517,6 @@ static int btmrvl_service_main_thread(void *data)
>  
>  		BT_DBG("main_thread woke up");
>  
> -		if (kthread_should_stop()) {
> -			BT_DBG("main_thread: break from main thread");
> -			break;
> -		}
> -
>  		spin_lock_irqsave(&priv->driver_lock, flags);
>  		if (adapter->int_count) {
>  			adapter->int_count = 0;
