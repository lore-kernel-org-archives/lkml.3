Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbaD3Vej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:34:39 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:33255 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaD3Veh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:34:37 -0400
Message-ID: <1398893151.1789.46.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 3/5] acpi_processor: do not mark present at boot but
 not onlined CPU as onlined
From: Toshi Kani <toshi.kani@hp.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Date: Wed, 30 Apr 2014 15:25:51 -0600
In-Reply-To: <1397488277-14865-4-git-send-email-imammedo@redhat.com>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com>
	 <1397488277-14865-4-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 17:11 +0200, Igor Mammedov wrote:
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
> ---
> v2:
>  - fix regression in v1 leading to NULL pointer dereference
>    on CPU unplug, do not remove "pr->dev = dev;"
> ---
>  drivers/acpi/acpi_processor.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> index c29c2c3..42d66f8 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -404,7 +404,6 @@ static int acpi_processor_add(struct acpi_device *device,
>  		goto err;
>  
>  	pr->dev = dev;
> -	dev->offline = pr->flags.need_hotplug_init;

IIRC, this change was necessary to handle the case when maxcpus=X is
specified at boot.  In this case, excessive CPU's dev->offline needs to
be set to 1.  Can you verify this?

Thanks,
-Toshi

