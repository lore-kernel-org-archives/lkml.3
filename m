Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaD2Hth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:49:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:34164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbaD2Htf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:49:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="425253672"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v2 3/5] ACPICA: Add <asm/acenv.h> to remove mis-ordered
 inclusion of <asm/acpi.h> from <acpi/platform/aclinux.h>.
Thread-Topic: [PATCH v2 3/5] ACPICA: Add <asm/acenv.h> to remove mis-ordered
 inclusion of <asm/acpi.h> from <acpi/platform/aclinux.h>.
Thread-Index: AQHPYl6Ei5A5bX/F70+i/inXfH4mrJsmVyaAgACfRYCAAUNe8A==
Date: Tue, 29 Apr 2014 07:49:13 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802558BA5@SHSMSX101.ccr.corp.intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com>
 <cover.1398232408.git.lv.zheng@intel.com>
 <522ac0c3a52f1697d75363cc808a213773dca295.1398232409.git.lv.zheng@intel.com>
 <1469560.3p9s15HIYZ@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E880255865E@SHSMSX101.ccr.corp.intel.com>
 <535EBA4B.5090305@intel.com>
In-Reply-To: <535EBA4B.5090305@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3T7nksX030556

Hi, Rafael

> From: Wysocki, Rafael J
> Sent: Tuesday, April 29, 2014 4:30 AM
> 
> On 4/28/2014 5:02 AM, Zheng, Lv wrote:
> > Hi, Rafael
> >
> >> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> >> Sent: Monday, April 28, 2014 5:37 AM
> >> To: Zheng, Lv
> >>
> >> On Wednesday, April 23, 2014 02:54:06 PM Lv Zheng wrote:
> >>> There is a mis-order inclusion for <asm/acpi.h>.
> >>>
> >>> As we will enforce including <linux/acpi.h> for all Linux ACPI users, we
> >>> can find the inclusion order is as follows:
> >>>
> >>> <linux/acpi.h>
> >>>    <acpi/acpi.h>
> >>>     <acpi/platform/acenv.h>
> >>>      (acenv.h before including aclinux.h)
> >>>      <acpi/platform/aclinux.h>
> >>> ...........................................................................
> >>>       (aclinux.h before including asm/acpi.h)
> >>>       <asm/acpi.h>                             @Redundant@
> >>>        (ACPICA specific stuff)
> >>> ...........................................................................
> >>> ...........................................................................
> >>>        (Linux ACPI specific stuff) ? - - - - - - - - - - - - +
> >>>       (aclinux.h after including asm/acpi.h)   @Invisible@   |
> >>>      (acenv.h after including aclinux.h)       @Invisible@   |
> >>>     other ACPICA headers                       @Invisible@   |
> >>> ............................................................|..............
> >>>    <acpi/acpi_bus.h>                                         |
> >>>    <acpi/acpi_drivers.h>                                     |
> >>>    <asm/acpi.h> (Excluded)                                   |
> >>>     (Linux ACPI specific stuff) ! <- - - - - - - - - - - - - +
> >>>
> >>> NOTE that, in ACPICA, <acpi/platform/acenv.h> is more like Kconfig
> >>> generated <generated/autoconf.h> for Linux, it is meant to be included
> >>> before including any ACPICA code.
> >>>
> >>> In the above figure, there is a question mark for "Linux ACPI specific
> >>> stuff" in <asm/acpi.h> which should be included after including all other
> >>> ACPICA header files.  Thus they really need to be moved to the position
> >>> marked with exclaimation mark or the definitions in the blocks marked with
> >>> "@Invisible@" will be invisible to such architecture specific "Linux ACPI
> >>> specific stuff" header blocks.  This leaves 2 issues:
> >>> 1. All environmental definitions in these blocks should have a copy in the
> >>>     area marked with "@Redundant@" if they are required by the "Linux ACPI
> >>>     specific stuff".
> >>> 2. We cannot use any ACPICA defined types in <asm/acpi.h>.
> >>>
> >>> This patch splits architecture specific ACPICA stuff from <asm/acpi.h> to
> >>> fix this issue.
> >>>
> >>> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> >>> Cc: Tony Luck <tony.luck@intel.com>
> >>> Cc: Fenghua Yu <fenghua.yu@intel.com>
> >>> Cc: linux-ia64@vger.kernel.org
> >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>> Cc: Ingo Molnar <mingo@redhat.com>
> >>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>> Cc: x86@kernel.org
> >>> ---
> >>>   arch/ia64/include/asm/acenv.h   |   71 +++++++++++++++++++++++++++++++++++++++
> >>>   arch/ia64/include/asm/acpi.h    |   50 ---------------------------
> >>>   arch/x86/include/asm/acenv.h    |   65 +++++++++++++++++++++++++++++++++++
> >>>   arch/x86/include/asm/acpi.h     |   45 -------------------------
> >>>   include/acpi/platform/aclinux.h |    2 +-
> >> Please rename the files first (in a separate patch) and then modify the
> >> renamed ones.  That will make changes much easier to follow.
> > This patch doesn't provide a rename.
> > Currently, <asm/acpi.h> includes:
> > 1. arch specific ACPI stuff
> > 2. arch specific ACPICA stuff
> > This patch moves "2" to a separate file <asm/acenv.h>, thus no renaming happens here.
> 
> Ah, I overlooked that, sorry.
> 
> Which I might not do if the changelog said what the patch was really doing.

Hmm, I'll refine the changelog in the next revision. :-)
Thanks for the helping.

Best regards
-Lv
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
