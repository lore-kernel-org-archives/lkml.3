Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaEGXbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:31:55 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54236 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751867AbaEGXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:31:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 2/4] acpi_processor: do not mark present at boot but not onlined CPU as onlined
Date: Thu, 08 May 2014 01:48:33 +0200
Message-ID: <20310348.uigSpUyQCR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399322991-19329-3-git-send-email-imammedo@redhat.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com> <1399322991-19329-3-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2014 10:49:49 PM Igor Mammedov wrote:
> acpi_processor_add() assumes that present at boot CPUs
> are always onlined, it is not so if a CPU failed to become
> onlined. As result acpi_processor_add() will mark such CPU
> device as onlined in sysfs and following attempts to
> online/offline it using /sys/device/system/cpu/cpuX/online
> attribute will fail.
> 
> Do not poke into device internals in acpi_processor_add()
> and touch "struct device { .offline }" attribute, since
> for CPUs onlined at boot it's set by:
>   topology_init() -> arch_register_cpu() -> register_cpu()
> before ACPI device tree is parsed, and for hotplugged
> CPUs it's set when userspace onlines CPU via sysfs.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Would there be a problem if I applied this separately from the rest of the
series?

> ---
> v2:
>  - fix regression in v1 leading to NULL pointer dereference
>    on CPU unplug, do not remove "pr->dev = dev;"
> ---
>  drivers/acpi/acpi_processor.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index b06f5f5..52c81c4 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -405,7 +405,6 @@ static int acpi_processor_add(struct acpi_device *device,
>  		goto err;
>  
>  	pr->dev = dev;
> -	dev->offline = pr->flags.need_hotplug_init;
>  
>  	/* Trigger the processor driver's .probe() if present. */
>  	if (device_attach(dev) >= 0)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
