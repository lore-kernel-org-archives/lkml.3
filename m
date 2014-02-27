Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaB0B7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:59:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaB0B7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:59:31 -0500
X-IronPort-AV: E=Sophos;i="4.97,551,1389715200"; 
   d="scan'208";a="9612319"
Message-ID: <530E9BEF.8080601@cn.fujitsu.com>
Date: Thu, 27 Feb 2014 09:59:11 +0800
From: Li Guang <lig.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20120421 Iceape/2.0.11
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com>
In-Reply-To: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 09:56:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 09:57:04,
	Serialize complete at 2014/02/27 09:57:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kieran Clancy wrote:
> A number of Samsung notebooks (530Uxx/535Uxx/540Uxx/550Pxx/900Xxx/etc)
> continue to log events during sleep (lid open/close, AC plug/unplug,
> battery level change), which accumulate in the EC until a buffer fills.
> After the buffer is full (tests suggest it holds 8 events), GPEs stop
> being triggered for new events. This state persists on wake or even on
> power cycle, and prevents new events from being registered until the EC
> is manually polled.
>
>    

that's really nasty EC firmware!

> This is the root cause of a number of bugs, including AC not being
> detected properly, lid close not triggering suspend, and low ambient
> light not triggering the keyboard backlight. The bug also seemed to be
> responsible for performance issues on at least one user's machine.
>
> Juan Manuel Cabo found the cause of bug and the workaround of polling
> the EC manually on wake.
>
> This patch:
> - Adds a function acpi_ec_clear() which polls the EC, at most
>    ACPI_EC_CLEAR_MAX (currently 20) times. A warning is logged if this
>    limit is reached.
> - Adds a flag EC_FLAGS_CLEAR_ON_RESUME which is set to 1 if the DMI
>    system vendor is Samsung. This check could be replaced by several more
>    specific DMI vendor/product pairs, but it's likely that the bug
>    affects more Samsung products than just the five series mentioned
>    above. Further, it should not be harmful to run acpi_ec_clear() on
>    systems without the bug; it will return immediately after finding no
>    data waiting.
> - Runs acpi_ec_clear() on initialisation (boot), from acpi_ec_add()
> - Runs acpi_ec_clear() on wake, from acpi_ec_unblock_transactions()
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=44161
> References: https://bugzilla.kernel.org/show_bug.cgi?id=45461
> References: https://bugzilla.kernel.org/show_bug.cgi?id=57271
> Signed-off-by: Kieran Clancy<clancy.kieran@gmail.com>
> Signed-off-by: Lan Tianyu<tianyu.lan@intel.com>
> Signed-off-by: Juan Manuel Cabo<juanmanuel.cabo@gmail.com>
> Signed-off-by: Dennis Jansen<dennis.jansen@web.de>
> Tested-by: Maurizio D'Addona<mauritiusdadd@gmail.com>
> Tested-by: San Zamoyski<san@plusnet.pl>
> ---
>   drivers/acpi/ec.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 61 insertions(+)
>
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index 959d41a..f437d9a 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -67,6 +67,8 @@ enum ec_command {
>   #define ACPI_EC_DELAY		500	/* Wait 500ms max. during EC ops */
>   #define ACPI_EC_UDELAY_GLK	1000	/* Wait 1ms max. to get global lock */
>   #define ACPI_EC_MSI_UDELAY	550	/* Wait 550us for MSI EC */
> +#define ACPI_EC_CLEAR_MAX	20	/* Maximum number of events to query
> +					 * when trying to clear the EC */
>    

20 is enough?
the query index is length of a byte.

>
>   enum {
>   	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
> @@ -116,6 +118,7 @@ EXPORT_SYMBOL(first_ec);
>   static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
>   static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
>   static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
> +static int EC_FLAGS_CLEAR_ON_RESUME; /* EC should be polled on boot/resume */
>    

seems name is implicit, what about EC_FLAGS_QEVENT_CLR_ON_RESUME?
seems too long :-)

>
>   /* --------------------------------------------------------------------------
>                                Transaction Management
> @@ -440,6 +443,26 @@ acpi_handle ec_get_handle(void)
>
>   EXPORT_SYMBOL(ec_get_handle);
>
> +static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data);
> +
> +/* run with locked ec mutex */
> +static void acpi_ec_clear(struct acpi_ec *ec)
> +{
> +	int i, status;
> +	u8 value = 0;
> +
> +	for (i = 0; i<  ACPI_EC_CLEAR_MAX; i++) {
> +		status = acpi_ec_query_unlocked(ec,&value);
> +		if (status || !value)
> +			break;
> +	}
> +
> +	if (i == ACPI_EC_CLEAR_MAX)
> +		pr_warn("Warning: Maximum of %d stale EC events cleared\n", i);
> +	else
> +		pr_info("%d stale EC events cleared\n", i);
> +}
> +
>   void acpi_ec_block_transactions(void)
>   {
>   	struct acpi_ec *ec = first_ec;
> @@ -463,6 +486,10 @@ void acpi_ec_unblock_transactions(void)
>   	mutex_lock(&ec->mutex);
>   	/* Allow transactions to be carried out again */
>   	clear_bit(EC_FLAGS_BLOCKED,&ec->flags);
> +
> +	if (EC_FLAGS_CLEAR_ON_RESUME)
> +		acpi_ec_clear(ec);
> +
>   	mutex_unlock(&ec->mutex);
>   }
>
> @@ -821,6 +848,13 @@ static int acpi_ec_add(struct acpi_device *device)
>
>   	/* EC is fully operational, allow queries */
>   	clear_bit(EC_FLAGS_QUERY_PENDING,&ec->flags);
> +
> +	/* Some hardware may need the EC to be cleared before use */
>    

description is implicit, should specify what we clear is Q event, not EC.

Thanks!
Li Guang

> +	if (EC_FLAGS_CLEAR_ON_RESUME) {
> +		mutex_lock(&ec->mutex);
> +		acpi_ec_clear(ec);
> +		mutex_unlock(&ec->mutex);
> +	}
>   	return ret;
>   }
>
> @@ -922,6 +956,30 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
>   	return 0;
>   }
>
> +/*
> + * On some hardware it is necessary to clear events accumulated by the EC during
> + * sleep. These ECs stop reporting GPEs until they are manually polled, if too
> + * many events are accumulated. (e.g. Samsung Series 5/9 notebooks)
> + *
> + * https://bugzilla.kernel.org/show_bug.cgi?id=44161
> + *
> + * Ideally, the EC should also be instructed not to accumulate events during
> + * sleep (which Windows seems to do somehow), but the interface to control this
> + * behaviour is not known at this time.
> + *
> + * Models known to be affected are Samsung 530Uxx/535Uxx/540Uxx/550Pxx/900Xxx,
> + * however it is very likely that other Samsung models are affected.
> + *
> + * On systems which don't accumulate EC events during sleep, this extra check
> + * should be harmless.
> + */
> +static int ec_clear_on_resume(const struct dmi_system_id *id)
> +{
> +	pr_debug("Detected system needing EC poll on resume.\n");
> +	EC_FLAGS_CLEAR_ON_RESUME = 1;
> +	return 0;
> +}
> +
>   static struct dmi_system_id ec_dmi_table[] __initdata = {
>   	{
>   	ec_skip_dsdt_scan, "Compal JFL92", {
> @@ -965,6 +1023,9 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
>   	ec_validate_ecdt, "ASUS hardware", {
>   	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
>   	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
> +	{
> +	ec_clear_on_resume, "Samsung hardware", {
> +	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
>   	{},
>   };
>
>    

