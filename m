Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3FPLp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:45:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39246 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab3FPLp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:45:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: Re: [PATCH 4/9] acpi: Replace weird use of PTR_RET.
Date: Sun, 16 Jun 2013 13:55:09 +0200
Message-ID: <21786607.z88XI8SeQN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371357768-4968-4-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au> <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au> <1371357768-4968-4-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 16, 2013 02:12:43 PM Rusty Russell wrote:
> This functions is really weird.  It sets rc to -ENOMEM, then overrides
> it.  It was converted to PTR_RET in a1458187 when it should have
> simply been rewritten.
> 
> This version makes it more explicit, with a single IS_ERR() test.
> 
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/acpi_pad.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index 27bb6a9..46e0b3c 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -231,16 +231,19 @@ static struct task_struct *ps_tsks[NR_CPUS];
>  static unsigned int ps_tsk_num;
>  static int create_power_saving_task(void)
>  {
> -	int rc = -ENOMEM;
> +	int rc;
>  
>  	ps_tsks[ps_tsk_num] = kthread_run(power_saving_thread,
>  		(void *)(unsigned long)ps_tsk_num,
>  		"acpi_pad/%d", ps_tsk_num);
> -	rc = PTR_RET(ps_tsks[ps_tsk_num]);
> -	if (!rc)
> -		ps_tsk_num++;
> -	else
> +
> +	if (IS_ERR(ps_tsks[ps_tsk_num])) {
> +		rc = PTR_ERR(ps_tsks[ps_tsk_num]);
>  		ps_tsks[ps_tsk_num] = NULL;
> +	} else {
> +		rc = 0;
> +		ps_tsk_num++;
> +	}
>  
>  	return rc;
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
