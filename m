Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3ALXji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:39:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39211 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3ALXjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:39:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 17/22] PCI, ACPI: Add alloc_acpi_hp_work()
Date: Sun, 13 Jan 2013 00:45:24 +0100
Message-ID: <3988288.MTBNr2Bzqb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-18-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-18-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:44 PM Yinghai Lu wrote:
> Will use it with acpiphp and pci_root_hp events handling

I think it would be better if you folded patches [17-20/22] together.

Thanks,
Rafael


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/osl.c      |   21 +++++++++++++++++++++
>  include/acpi/acpiosxf.h |    9 +++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 3ff2678..e6539a3 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1778,3 +1778,24 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>  {
>  	__acpi_os_prepare_sleep = func;
>  }
> +
> +void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> +			void (*func)(struct work_struct *work))
> +{
> +	struct acpi_hp_work *hp_work;
> +	int ret;
> +
> +	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> +	if (!hp_work)
> +		return;
> +
> +	hp_work->handle = handle;
> +	hp_work->type = type;
> +	hp_work->context = context;
> +
> +	INIT_WORK(&hp_work->work, func);
> +	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> +	if (!ret)
> +		kfree(hp_work);
> +}
> +EXPORT_SYMBOL(alloc_acpi_hp_work);
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 4315274..2a64da5 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -195,6 +195,15 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
>   */
>  extern struct workqueue_struct *kacpi_hotplug_wq;
>  
> +struct acpi_hp_work {
> +	struct work_struct work;
> +	acpi_handle handle;
> +	u32 type;
> +	void *context;
> +};
> +void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> +			void (*func)(struct work_struct *work));
> +
>  acpi_thread_id acpi_os_get_thread_id(void);
>  
>  acpi_status
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
