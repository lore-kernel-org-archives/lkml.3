Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaJ0WY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:24:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49898 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752326AbaJ0WY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:24:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Imre Deak <imre.deak@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] PM / Sleep: fix async suspend_late/freeze_late error handling
Date: Mon, 27 Oct 2014 23:45:30 +0100
Message-ID: <8054820.ZaPIZ3Ztss@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414171750-6858-1-git-send-email-imre.deak@intel.com>
References: <1414137549-30005-1-git-send-email-imre.deak@intel.com> <1414171750-6858-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2014 08:29:09 PM Imre Deak wrote:
> If an asynchronous suspend_late or freeze_late callback fails
> during the SUSPEND, FREEZE or QUIESCE phases we don't propagate the
> corresponding error correctly, in effect ignoring the error and
> continuing the suspend-to-ram/hibernation. During suspend-to-ram this
> could leave some devices without a valid saved context, leading to a
> failure to reinitialize them during resume. During hibernation this
> could leave some devices active interfeering with the creation /
> restoration of the hibernation image. Also this could leave the
> corresponding devices without a valid saved context and failure to
> reinitialize them during resume.
> 
> v3 (added to patchset):
> - split out this fix into a separate patch (Rafael)
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Both [1-2/2] applied, thanks!

> ---
>  drivers/base/power/main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 4497319..9717d5f 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1266,6 +1266,8 @@ int dpm_suspend_late(pm_message_t state)
>  	}
>  	mutex_unlock(&dpm_list_mtx);
>  	async_synchronize_full();
> +	if (!error)
> +		error = async_error;
>  	if (error) {
>  		suspend_stats.failed_suspend_late++;
>  		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
