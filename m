Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaEEA0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:26:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50937 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753891AbaEEA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:26:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, Lv Zheng <lv.zheng@intel.com>,
        Lv Zheng <zetalog@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
Date: Mon, 05 May 2014 02:43:08 +0200
Message-ID: <1717964.6jLQaaky5K@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+5PVA58OC2dbk5oqTSQjOsCVzYfF+8nfat1Nbd2cCRTxbn5Pg@mail.gmail.com>
References: <cover.1398817612.git.lv.zheng@intel.com> <c226eed72699ee1934426074b9d1c902ccfa0b48.1398817612.git.lv.zheng@intel.com> <CA+5PVA58OC2dbk5oqTSQjOsCVzYfF+8nfat1Nbd2cCRTxbn5Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 03, 2014 08:59:14 AM Josh Boyer wrote:
> On Tue, Apr 29, 2014 at 10:05 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> > The commit of back porting Linux XSDT validation mechanism has introduced
> > a regreession:
> >   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
> >   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> > There is a pointer still accessed after unmapping.
> >
> > This patch fixes this issue.  Lv Zheng.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> > Buglink: https://bugs.archlinux.org/task/39811
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> > Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> > Signed-off-by: Bob Moore <robert.moore@intel.com>
> > Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> 
> This patch should get into 3.15-rcX soon.  It fixes a known regression
> that prevents booting on machines with AMI firmware, and that is
> present in 3.14 so we need it for stable as well.  Rafael?

Lv, is it safe to take this patch alone into 3.15-rc?

Rafael


> > ---
> >  drivers/acpi/acpica/tbutils.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> > index 6c31d77..e1638ad 100644
> > --- a/drivers/acpi/acpica/tbutils.c
> > +++ b/drivers/acpi/acpica/tbutils.c
> > @@ -355,6 +355,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> >         u32 table_count;
> >         struct acpi_table_header *table;
> >         acpi_physical_address address;
> > +       acpi_physical_address rsdt_address;
> >         u32 length;
> >         u8 *table_entry;
> >         acpi_status status;
> > @@ -383,11 +384,14 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> >                  * as per the ACPI specification.
> >                  */
> >                 address = (acpi_physical_address) rsdp->xsdt_physical_address;
> > +               rsdt_address =
> > +                   (acpi_physical_address) rsdp->rsdt_physical_address;
> >                 table_entry_size = ACPI_XSDT_ENTRY_SIZE;
> >         } else {
> >                 /* Root table is an RSDT (32-bit physical addresses) */
> >
> >                 address = (acpi_physical_address) rsdp->rsdt_physical_address;
> > +               rsdt_address = address;
> >                 table_entry_size = ACPI_RSDT_ENTRY_SIZE;
> >         }
> >
> > @@ -410,8 +414,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> >
> >                         /* Fall back to the RSDT */
> >
> > -                       address =
> > -                           (acpi_physical_address) rsdp->rsdt_physical_address;
> > +                       address = rsdt_address;
> >                         table_entry_size = ACPI_RSDT_ENTRY_SIZE;
> >                 }
> >         }
> > --
> > 1.7.10
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
