Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3FKVvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:51:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34438 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3FKVvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:51:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julius Werner <jwerner@chromium.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] PM / Sleep: Print last wakeup source on failed wakeup_count write
Date: Wed, 12 Jun 2013 00:00:18 +0200
Message-ID: <4844834.TBe7kS6ocA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1369944137-30948-1-git-send-email-jwerner@chromium.org>
References: <1369944137-30948-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 01:02:17 PM Julius Werner wrote:
> Commit a938da06 introduced a useful little log message to tell
> users/debuggers which wakeup source aborted a suspend. However, this
> message is only printed if the abort happens during the in-kernel
> suspend path (after writing /sys/power/state).
> 
> The full specification of the /sys/power/wakeup_count facility allows
> user-space power managers to double-check if wakeups have already
> happened before it actually tries to suspend (e.g. while it was running
> user-space pre-suspend hooks), by writing the last known wakeup_count
> value to /sys/power/wakeup_count. This patch changes the sysfs handler
> for that node to also print said log message if that write fails, so
> that we can figure out the offending wakeup source for both kinds of
> suspend aborts.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/base/power/wakeup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> index 79715e7..b0b7886 100644
> --- a/drivers/base/power/wakeup.c
> +++ b/drivers/base/power/wakeup.c
> @@ -772,6 +772,8 @@ bool pm_save_wakeup_count(unsigned int count)
>  		events_check_enabled = true;
>  	}
>  	spin_unlock_irqrestore(&events_lock, flags);
> +	if (!events_check_enabled)
> +		print_active_wakeup_sources();

This is going to be done in the autosleep case too, which I'm slightly
concerned about.

If you wanted to cover /sys/power/wakeup_count only, it would be better
to put that into wakeup_count_store(), but perhaps you wanted to cover
autosleep too?

>  	return events_check_enabled;
>  }

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
