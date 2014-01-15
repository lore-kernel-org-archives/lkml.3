Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaAOAmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:42:31 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:57041 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAOAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:42:29 -0500
Date: Tue, 14 Jan 2014 16:42:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug [v3]
In-Reply-To: <1389727273-27817-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1401141642020.3375@chino.kir.corp.google.com>
References: <1389727273-27817-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Prarit Bhargava wrote:

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index b9e9bd8..ea93f75 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -343,6 +343,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			no: ACPI OperationRegions are not marked as reserved,
>  			no further checks are performed.
>  
> +	acpi_no_memhotplug [ACPI] Disable memory hotplug.  Useful for kexec
> +			   and kdump kernels.
> +
>  	add_efi_memmap	[EFI; X86] Include EFI memory map in
>  			kernel's map of available physical RAM.
>  
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 551dad7..4a0fa94 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -361,7 +361,19 @@ static void acpi_memory_device_remove(struct acpi_device *device)
>  	acpi_memory_device_free(mem_device);
>  }
>  
> +static bool acpi_no_memhotplug;
> +

I think this should be annotated with __initdata.

>  void __init acpi_memory_hotplug_init(void)
>  {
> +	if (acpi_no_memhotplug)
> +		return;
> +
>  	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
>  }
> +
> +static int __init disable_acpi_memory_hotplug(char *str)
> +{
> +	acpi_no_memhotplug = true;
> +	return 1;
> +}
> +__setup("acpi_no_memhotplug", disable_acpi_memory_hotplug);
