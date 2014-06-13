Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaFMNLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:11:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:34084 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaFMNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:11:03 -0400
Date: Fri, 13 Jun 2014 15:10:51 +0200
From: Robert Richter <rric@kernel.org>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 3/5] acpi, apei, ghes: Introduce more generic
 mechanism to init/deinit GHES error notifications.
Message-ID: <20140613131051.GY27560@rric.localhost>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-4-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402657380-18539-4-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.14 13:02:58, Tomasz Nowicki wrote:

> @@ -811,6 +819,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>  	int sev, sev_global = -1;
>  	int ret = NMI_DONE;
>  
> +	BUG_ON(!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI));
> +

Now that we have the ARCH_HAS_ACPI_APEI_NMI option, group nmi code,
put it in an #ifdef ... and make function stubs for the !nmi case
where necessary. That code should moved to patch #2. If an arch does
not support nmi code, we don't want to compile it into the kernel.

Also this patch is quit a bit large and should further split into
moving functional code into separate functions and the introduction of
the notifier setup. This makes review much easier.

I did not yet took a deep look into your notifier framework, but I
don't really see a reason for the dynamic collection of function
pointers in ghes_notify_tab. See below.

>  	raw_spin_lock(&ghes_nmi_lock);
>  	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
>  		if (ghes_read_estatus(ghes, 1)) {
> @@ -875,10 +885,6 @@ out:
>  	return ret;
>  }

> +static int ghes_notify_init_nmi(struct ghes *ghes)
> +{
> +	unsigned long len;
> +	int status = 0;
> +
> +	len = ghes_esource_prealloc_size(ghes->generic);
> +	ghes_estatus_pool_expand(len);
> +	mutex_lock(&ghes_list_mutex);
> +	if (list_empty(&ghes_nmi))
> +		status = register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
> +					      "ghes");
> +	list_add_rcu(&ghes->list, &ghes_nmi);
> +	mutex_unlock(&ghes_list_mutex);
> +
> +	return status;
> +}
> +
> +static void ghes_notify_remove_nmi(struct ghes *ghes)
> +{
> +	unsigned long len;
> +
> +	mutex_lock(&ghes_list_mutex);
> +	list_del_rcu(&ghes->list);
> +	if (list_empty(&ghes_nmi))
> +		unregister_nmi_handler(NMI_LOCAL, "ghes");
> +	mutex_unlock(&ghes_list_mutex);
> +	/*
> +	 * To synchronize with NMI handler, ghes can only be
> +	 * freed after NMI handler finishes.
> +	 */
> +	synchronize_rcu();
> +	len = ghes_esource_prealloc_size(ghes->generic);
> +	ghes_estatus_pool_shrink(len);
> +}
> +
> +static void ghes_init_nmi(void)
> +{
> +	if (!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI))
> +		return;
> +
> +	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
> +	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].init_call = ghes_notify_init_nmi;
> +	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].remove_call =
> +							ghes_notify_remove_nmi;
> +}
> +

So this is the only code of your whole patch set that actually changes
an entry, and just one time only during nmi init. Thus, there is no
need at all for ghes_notify_tab. Just create function stubs for
ghes_notify_{init,remove}_nmi for the !nmi case with the error message
in it and call the functions directly in the switch/cases.

> +static struct ghes_notify_setup
> +	ghes_notify_tab[ACPI_HEST_NOTIFY_RESERVED] = {
> +		[ACPI_HEST_NOTIFY_POLLED]   = {"POLLED",
> +					       ghes_notify_init_polled,
> +					       ghes_notify_remove_polled},
> +		[ACPI_HEST_NOTIFY_EXTERNAL] = {"EXT_IRQ",
> +					       ghes_notify_init_external,
> +					       ghes_notify_remove_external},
> +		[ACPI_HEST_NOTIFY_LOCAL]    = {"LOCAL_IRQ", NULL, NULL},
> +		[ACPI_HEST_NOTIFY_SCI]      = {"SCI",
> +					       ghes_notify_init_sci,
> +					       ghes_notify_remove_sci},
> +		[ACPI_HEST_NOTIFY_NMI]      = {"NMI", NULL, NULL},
> +		[ACPI_HEST_NOTIFY_CMCI]     = {"CMCI", NULL, NULL},
> +		[ACPI_HEST_NOTIFY_MCE]      = {"MCE", NULL, NULL},
> +};

Again, just keep the switch/case statements in the probe and removal
function and call the init/remove functions directly in them. This is
much easier.

If we need dynamic registration of handlers (which I don't see yet)
for the error sources above we could do this with an acpi notify
handler or so.

-Robert
