Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaECM7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 08:59:17 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43673 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaECM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 08:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <c226eed72699ee1934426074b9d1c902ccfa0b48.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
	<c226eed72699ee1934426074b9d1c902ccfa0b48.1398817612.git.lv.zheng@intel.com>
Date: Sat, 3 May 2014 08:59:14 -0400
X-Google-Sender-Auth: i2Z01wMCHV6JEPsfryBtq0BU0T8
Message-ID: <CA+5PVA58OC2dbk5oqTSQjOsCVzYfF+8nfat1Nbd2cCRTxbn5Pg@mail.gmail.com>
Subject: Re: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Bob Moore <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:05 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> The commit of back porting Linux XSDT validation mechanism has introduced
> a regreession:
>   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
>   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> There is a pointer still accessed after unmapping.
>
> This patch fixes this issue.  Lv Zheng.
>
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> Buglink: https://bugs.archlinux.org/task/39811
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.

This patch should get into 3.15-rcX soon.  It fixes a known regression
that prevents booting on machines with AMI firmware, and that is
present in 3.14 so we need it for stable as well.  Rafael?

josh

> ---
>  drivers/acpi/acpica/tbutils.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> index 6c31d77..e1638ad 100644
> --- a/drivers/acpi/acpica/tbutils.c
> +++ b/drivers/acpi/acpica/tbutils.c
> @@ -355,6 +355,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>         u32 table_count;
>         struct acpi_table_header *table;
>         acpi_physical_address address;
> +       acpi_physical_address rsdt_address;
>         u32 length;
>         u8 *table_entry;
>         acpi_status status;
> @@ -383,11 +384,14 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>                  * as per the ACPI specification.
>                  */
>                 address = (acpi_physical_address) rsdp->xsdt_physical_address;
> +               rsdt_address =
> +                   (acpi_physical_address) rsdp->rsdt_physical_address;
>                 table_entry_size = ACPI_XSDT_ENTRY_SIZE;
>         } else {
>                 /* Root table is an RSDT (32-bit physical addresses) */
>
>                 address = (acpi_physical_address) rsdp->rsdt_physical_address;
> +               rsdt_address = address;
>                 table_entry_size = ACPI_RSDT_ENTRY_SIZE;
>         }
>
> @@ -410,8 +414,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
>
>                         /* Fall back to the RSDT */
>
> -                       address =
> -                           (acpi_physical_address) rsdp->rsdt_physical_address;
> +                       address = rsdt_address;
>                         table_entry_size = ACPI_RSDT_ENTRY_SIZE;
>                 }
>         }
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
