Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3GIQ0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:26:15 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63351 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3GIQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130709101039.GA4479@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz> <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz> <20130709101039.GA4479@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Jul 2013 10:25:50 -0600
Message-ID: <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 4:10 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>> > > My thinkpad has rather high ping latencies... and perhaps it is due to
>> > > PCIE ASPM.
>> >
>> > Why would that be the problem?  The odds that the PCIE bus is the issue
>> > seems strange to me.
>>
>> Aha: I guess that's why the file is not writable:
>>
>> pavel@amd:~$ dmesg | grep -i aspm
>> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>> e1000e 0000:02:00.0: Disabling ASPM L0s L1
>> pavel@amd:~$ cat /sys/module/pcie_aspm/parameters/policy
>> [default] performance powersave
>> pavel@amd:~$
>> root@amd:~# echo -n performance >
>> /sys/module/pcie_aspm/parameters/policy
>> -su: echo: write error: Operation not permitted
>> root@amd:~#
>>
>> But:
>> 1) it should not list unavailable options
>>
>> 2) operation not permitted seems like wrong error code for
>> operation not supported.
>
> So I forcibly enabled ASPM, and now ping latencies are in normal
> range... no matter how I set
> /sys/module/pcie_aspm/parameters/policy. Strange.
>
> Any ideas what correct solution is?
>                                                                         Pavel
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> (but don't apply)
>
> diff --git a/.config b/.config
> index 149f713..d7f5a11 100644
> --- a/.config
> +++ b/.config
> @@ -1,6 +1,6 @@
>  #
>  # Automatically generated file; DO NOT EDIT.
> -# Linux/x86 3.10.0-rc2 Kernel Configuration
> +# Linux/x86 3.10.0 Kernel Configuration
>  #
>  # CONFIG_64BIT is not set
>  CONFIG_X86_32=y
> @@ -559,9 +559,9 @@ CONFIG_PCIEAER=y
>  # CONFIG_PCIEAER_INJECT is not set
>  CONFIG_PCIEASPM=y
>  CONFIG_PCIEASPM_DEBUG=y
> -CONFIG_PCIEASPM_DEFAULT=y
> +# CONFIG_PCIEASPM_DEFAULT is not set
>  # CONFIG_PCIEASPM_POWERSAVE is not set
> -# CONFIG_PCIEASPM_PERFORMANCE is not set
> +CONFIG_PCIEASPM_PERFORMANCE=y
>  CONFIG_PCIE_PME=y
>  CONFIG_ARCH_SUPPORTS_MSI=y
>  # CONFIG_PCI_MSI is not set
> @@ -1340,7 +1340,10 @@ CONFIG_MD_RAID1=y
>  # CONFIG_MD_RAID456 is not set
>  # CONFIG_MD_MULTIPATH is not set
>  # CONFIG_MD_FAULTY is not set
> -# CONFIG_BCACHE is not set
> +CONFIG_BCACHE=y
> +# CONFIG_BCACHE_DEBUG is not set
> +# CONFIG_BCACHE_EDEBUG is not set
> +# CONFIG_BCACHE_CLOSURES_DEBUG is not set
>  CONFIG_BLK_DEV_DM=y
>  # CONFIG_DM_DEBUG is not set
>  CONFIG_DM_CRYPT=y
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index e4b1fb2..9a1b63e 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -382,7 +382,7 @@ static int __init acpi_pci_init(void)
>
>         if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
>                 printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
> -               pcie_no_aspm();
> +//             pcie_no_aspm();
>         }
>
>         ret = register_acpi_bus_type(&acpi_pci_bus);

Hi Pavel,

Interesting.  Can you collect dmesg and "lspci -vvv" output for both
cases (high ping latency and normal ping latency)?  Also, how much
difference does this make in ping latency?  If ASPM is enabled for a
device, e.g., your NIC, the link may be put in a low power state when
the device is idle.  It takes time to exit that low power state, of
course, but I would expect that time to be in the microsecond time and
probably not observable via ping.

Bjorn
