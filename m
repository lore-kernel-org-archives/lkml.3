Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaD2V0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:26:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53753 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755565AbaD2V0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:26:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kieran Clancy <clancy.kieran@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Stefan Biereigel <stefan@biereigel.de>
Subject: Re: [PATCH] ACPI / EC: Process rather than discard events in acpi_ec_clear
Date: Tue, 29 Apr 2014 23:42:30 +0200
Message-ID: <24139858.4TxL0glm7k@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398783080-24554-1-git-send-email-clancy.kieran@gmail.com>
References: <1398783080-24554-1-git-send-email-clancy.kieran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 12:21:20 AM Kieran Clancy wrote:
> Address a regression caused by commit ad332c8a4533:
> (ACPI / EC: Clear stale EC events on Samsung systems)
> 
> After the earlier patch, there was found to be a race condition on some
> earlier Samsung systems (N150/N210/N220). The function acpi_ec_clear was
> sometimes discarding a new EC event before its GPE was triggered by the
> system. In the case of these systems, this meant that the "lid open"
> event was not registered on resume if that was the cause of the wake,
> leading to problems when attempting to close the lid to suspend again.
> 
> After testing on a number of Samsung systems, both those affected by the
> previous EC bug and those affected by the race condition, it seemed that
> the best course of action was to process rather than discard the events.
> On Samsung systems which accumulate stale EC events, there does not seem
> to be any adverse side-effects of running the associated _Q methods.
> 
> This patch adds an argument to the static function acpi_ec_sync_query so
> that it may be used within the acpi_ec_clear loop in place of
> acpi_ec_query_unlocked which was used previously.
> 
> With thanks to Stefan Biereigel for reporting the issue, and for all the
> people who helped test the new patch on affected systems.
> 
> References: https://lkml.kernel.org/r/532FE3B2.9060808@biereigel-wb.de
> References: https://bugzilla.kernel.org/show_bug.cgi?id=44161#c173
> Reported-by: Stefan Biereigel <stefan@biereigel.de>
> Signed-off-by: Kieran Clancy <clancy.kieran@gmail.com>
> Tested-by: Stefan Biereigel <stefan@biereigel.de>
> Tested-by: Dennis Jansen <dennis.jansen@web.de>
> Tested-by: Nicolas Porcel <nicolasporcel06@gmail.com>
> Tested-by: Maurizio D'Addona <mauritiusdadd@gmail.com>
> Tested-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
> Tested-by: Giannis Koutsou <giannis.koutsou@gmail.com>
> Tested-by: Kieran Clancy <clancy.kieran@gmail.com>
> Cc: Lan Tianyu <tianyu.lan@intel.com>

Queued up for 3.15, thanks!

> ---
> 
> To maintainers: Assuming this patch is accepted, please mark this for
> inclusion in all -stable trees. It should be noted that the previous
> patch (ad332c8a4533) was excluded from a number of stable trees after
> the regression was found, but should now be included again along with
> this patch. I am not sure of the correct way to annotate this above.

I only can tag it for 3.14.y, because the mainline regression is in 3.14.

You'll need to ask the -stable maintainers in question to pick up both
patches after this one reaches the Linus' tree.

>  drivers/acpi/ec.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index d7d32c2..ad11ba4 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -206,13 +206,13 @@ unlock:
>  	spin_unlock_irqrestore(&ec->lock, flags);
>  }
>  
> -static int acpi_ec_sync_query(struct acpi_ec *ec);
> +static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data);
>  
>  static int ec_check_sci_sync(struct acpi_ec *ec, u8 state)
>  {
>  	if (state & ACPI_EC_FLAG_SCI) {
>  		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
> -			return acpi_ec_sync_query(ec);
> +			return acpi_ec_sync_query(ec, NULL);
>  	}
>  	return 0;
>  }
> @@ -443,10 +443,8 @@ acpi_handle ec_get_handle(void)
>  
>  EXPORT_SYMBOL(ec_get_handle);
>  
> -static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
> -
>  /*
> - * Clears stale _Q events that might have accumulated in the EC.
> + * Process _Q events that might have accumulated in the EC.
>   * Run with locked ec mutex.
>   */
>  static void acpi_ec_clear(struct acpi_ec *ec)
> @@ -455,7 +453,7 @@ static void acpi_ec_clear(struct acpi_ec *ec)
>  	u8 value = 0;
>  
>  	for (i = 0; i < ACPI_EC_CLEAR_MAX; i++) {
> -		status = acpi_ec_query_unlocked(ec, &value);
> +		status = acpi_ec_sync_query(ec, &value);
>  		if (status || !value)
>  			break;
>  	}
> @@ -582,13 +580,18 @@ static void acpi_ec_run(void *cxt)
>  	kfree(handler);
>  }
>  
> -static int acpi_ec_sync_query(struct acpi_ec *ec)
> +static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
>  {
>  	u8 value = 0;
>  	int status;
>  	struct acpi_ec_query_handler *handler, *copy;
> -	if ((status = acpi_ec_query_unlocked(ec, &value)))
> +
> +	status = acpi_ec_query_unlocked(ec, &value);
> +	if (data)
> +		*data = value;
> +	if (status)
>  		return status;
> +
>  	list_for_each_entry(handler, &ec->list, node) {
>  		if (value == handler->query_bit) {
>  			/* have custom handler for this bit */
> @@ -612,7 +615,7 @@ static void acpi_ec_gpe_query(void *ec_cxt)
>  	if (!ec)
>  		return;
>  	mutex_lock(&ec->mutex);
> -	acpi_ec_sync_query(ec);
> +	acpi_ec_sync_query(ec, NULL);
>  	mutex_unlock(&ec->mutex);
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
