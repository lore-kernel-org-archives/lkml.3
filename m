Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaEEEXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:23:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:13608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaEEEXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,985,1389772800"; 
   d="scan'208";a="427544738"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Boyer <jwboyer@fedoraproject.org>, Lv Zheng <zetalog@gmail.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in
 acpi_tb_parse_root_table().
Thread-Topic: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in
 acpi_tb_parse_root_table().
Thread-Index: AQHPZ/iuve4rvQgJnEi8eqtq/mEgq5sxYmJQ
Date: Mon, 5 May 2014 04:23:02 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802559B1C@SHSMSX101.ccr.corp.intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
 <c226eed72699ee1934426074b9d1c902ccfa0b48.1398817612.git.lv.zheng@intel.com>
 <CA+5PVA58OC2dbk5oqTSQjOsCVzYfF+8nfat1Nbd2cCRTxbn5Pg@mail.gmail.com>
 <1717964.6jLQaaky5K@vostro.rjw.lan>
In-Reply-To: <1717964.6jLQaaky5K@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s454NUCd032630

Hi, Rafael

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Monday, May 05, 2014 8:43 AM
> 
> On Saturday, May 03, 2014 08:59:14 AM Josh Boyer wrote:
> > On Tue, Apr 29, 2014 at 10:05 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> > > The commit of back porting Linux XSDT validation mechanism has introduced
> > > a regreession:
> > >   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
> > >   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> > > There is a pointer still accessed after unmapping.
> > >
> > > This patch fixes this issue.  Lv Zheng.
> > >
> > > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> > > Buglink: https://bugs.archlinux.org/task/39811
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> > > Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> > > Signed-off-by: Bob Moore <robert.moore@intel.com>
> > > Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> >
> > This patch should get into 3.15-rcX soon.  It fixes a known regression
> > that prevents booting on machines with AMI firmware, and that is
> > present in 3.14 so we need it for stable as well.  Rafael?
> 
> Lv, is it safe to take this patch alone into 3.15-rc?

Yes, it's safe to only take this patch to be a regression fix.
I'm sorry for the regression I made in the bisected commit.

Thanks and best regards
-Lv

> 
> Rafael
> 
> 
> > > ---
> > >  drivers/acpi/acpica/tbutils.c |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> > > index 6c31d77..e1638ad 100644
> > > --- a/drivers/acpi/acpica/tbutils.c
> > > +++ b/drivers/acpi/acpica/tbutils.c
> > > @@ -355,6 +355,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> > >         u32 table_count;
> > >         struct acpi_table_header *table;
> > >         acpi_physical_address address;
> > > +       acpi_physical_address rsdt_address;
> > >         u32 length;
> > >         u8 *table_entry;
> > >         acpi_status status;
> > > @@ -383,11 +384,14 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> > >                  * as per the ACPI specification.
> > >                  */
> > >                 address = (acpi_physical_address) rsdp->xsdt_physical_address;
> > > +               rsdt_address =
> > > +                   (acpi_physical_address) rsdp->rsdt_physical_address;
> > >                 table_entry_size = ACPI_XSDT_ENTRY_SIZE;
> > >         } else {
> > >                 /* Root table is an RSDT (32-bit physical addresses) */
> > >
> > >                 address = (acpi_physical_address) rsdp->rsdt_physical_address;
> > > +               rsdt_address = address;
> > >                 table_entry_size = ACPI_RSDT_ENTRY_SIZE;
> > >         }
> > >
> > > @@ -410,8 +414,7 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
> > >
> > >                         /* Fall back to the RSDT */
> > >
> > > -                       address =
> > > -                           (acpi_physical_address) rsdp->rsdt_physical_address;
> > > +                       address = rsdt_address;
> > >                         table_entry_size = ACPI_RSDT_ENTRY_SIZE;
> > >                 }
> > >         }
> > > --
> > > 1.7.10
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
