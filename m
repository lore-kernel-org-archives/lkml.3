Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab3CZNGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:06:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42942 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab3CZNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:06:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Mandeep Singh Baines <msb@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [PATCH 1/1] thinkpad-acpi: kill hotkey_thread_mutex
Date: Tue, 26 Mar 2013 14:14:07 +0100
Message-ID: <3714515.nbfe9U9zSg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130307175359.GB15631@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <20130307175305.GA15631@redhat.com> <20130307175359.GB15631@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 07, 2013 06:53:59 PM Oleg Nesterov wrote:
> hotkey_kthread() does try_to_freeze() under hotkey_thread_mutex.
> 
> We can simply kill this mutex, hotkey_poll_stop_sync() does not need
> to serialize with hotkey_kthread(). When kthread_stop() returns the
> thread is already dead, it called do_exit()->complete_vfork_done().
> 
> Reported-by: Artem Savkov <artem.savkov@gmail.com>
> Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I wonder if anyone is taking care of this patch?

Rafael


> --- x/drivers/platform/x86/thinkpad_acpi.c
> +++ x/drivers/platform/x86/thinkpad_acpi.c
> @@ -1965,9 +1965,6 @@ struct tp_nvram_state {
>  /* kthread for the hotkey poller */
>  static struct task_struct *tpacpi_hotkey_task;
>  
> -/* Acquired while the poller kthread is running, use to sync start/stop */
> -static struct mutex hotkey_thread_mutex;
> -
>  /*
>   * Acquire mutex to write poller control variables as an
>   * atomic block.
> @@ -2463,8 +2460,6 @@ static int hotkey_kthread(void *data)
>  	unsigned int poll_freq;
>  	bool was_frozen;
>  
> -	mutex_lock(&hotkey_thread_mutex);
> -
>  	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
>  		goto exit;
>  
> @@ -2524,7 +2519,6 @@ static int hotkey_kthread(void *data)
>  	}
>  
>  exit:
> -	mutex_unlock(&hotkey_thread_mutex);
>  	return 0;
>  }
>  
> @@ -2534,9 +2528,6 @@ static void hotkey_poll_stop_sync(void)
>  	if (tpacpi_hotkey_task) {
>  		kthread_stop(tpacpi_hotkey_task);
>  		tpacpi_hotkey_task = NULL;
> -		mutex_lock(&hotkey_thread_mutex);
> -		/* at this point, the thread did exit */
> -		mutex_unlock(&hotkey_thread_mutex);
>  	}
>  }
>  
> @@ -3235,7 +3226,6 @@ static int __init hotkey_init(struct ibm
>  	mutex_init(&hotkey_mutex);
>  
>  #ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> -	mutex_init(&hotkey_thread_mutex);
>  	mutex_init(&hotkey_thread_data_mutex);
>  #endif
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
