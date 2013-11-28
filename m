Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3K1BNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 20:13:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:41221 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3K1BM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 20:12:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,786,1378882800"; 
   d="scan'208";a="435402238"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Topic: [PATCH v2] ACPI: Cleanup <acpi/acpi.h>, <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Index: AQHO6mdltsdUzD/SH0inO/nl6LJY6Zo3cYOA////3oCAAEMgAIACIVMQ
Date: Thu, 28 Nov 2013 01:12:47 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880248E0CB@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <2011704.hD86fZ2Qk5@vostro.rjw.lan>
 <20131126202905.GA12889@phenom.dumpdata.com>
 <3542568.jpR4FU4Yha@vostro.rjw.lan>
In-Reply-To: <3542568.jpR4FU4Yha@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAS1DaiF024675

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Wednesday, November 27, 2013 8:29 AM
> 
> On Tuesday, November 26, 2013 03:29:05 PM Konrad Rzeszutek Wilk wrote:
> > On Tue, Nov 26, 2013 at 09:29:33PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 26, 2013 01:21:15 PM Lv Zheng wrote:
> > > > Replace direct inclusions of <acpi/acpi.h>, <acpi/acpi_bus.h> and
> > > > <acpi/acpi_drivers.h>, which are incorrect, with <linux/acpi.h> inclusions.
> > > >
> > > > First of all, <acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h>
> > > > should not be included directly from any files that are built for
> > > > CONFIG_ACPI unset, because that generally leads to build warnings about
> > > > undefined symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set,
> > > > <linux/acpi.h> includes those files and for !CONFIG_ACPI it provides stub
> > > > ACPI symbols to be used in that case.
> > > >
> > > > Second, there are ordering dependencies between those files that always
> > > > have to be met.  Namely, it is required that <acpi/acpi_bus.h> be included
> > > > prior to <acpi/acpi_drivers.h> so that the acpi_pci_root declarations the
> > > > latter depends on are always there.  And <acpi/acpi.h> which provides
> > > > basic ACPICA type declarations should always be included prior to any other
> > > > ACPI headers in CONFIG_ACPI builds.  That also is taken care of including
> > > > <linux/acpi.h> as appropriate.
> > > >
> > > > This patch also includes necessary cleanups in the affected files where
> > > > other ACPI headers is also included but not referenced.
> > > >
> > >
> > > This looks OK to me, but it touches several other subsystems.  It's better to
> > > CC such things to linux-kernel at least.
> > >
> > > Peter, Matthew, Tony, Konrad, Greg, Bjorn, do you have any objections against this?
> >
> > CC-ing Boris and David here.
> >
> > I presume the proper compilation tests to make sure they do compile properly
> > has been done.
> 
> Yes and we're going to run it through the auto build machinery anyway.

Hi, Rafael

The revision 1 is written in the style that it wouldn't introduce regressions as:
<acpi/acpi.h> <acpi/acpi_bus.h> <acpi/acpi_drivers.h> is replaced by <linux/acpi.h>.  If there are 2 or more linux/acpi.h inclusions in the same files, then the latter ones are deleted.
And it gets building/booting tested by enabling the affected modules for testing on x86 and x86_64.
The checker enabled tests only showed line number differences.
For special IA64 only modules, they are tested using "make <dirname of file>/<basename of file>.o" with necessary -D passed through command line.

I the revision 2, there are <asm/xxx.h> order changes, it thus may introduce regressions if there are tricks we don't know better than the original authors.
My build tests still showed no issues, but we could feed them a coverage test.
Rafael, hope you can help me do this in your bleeding-edge branch and feel free to modify the commit to fix the issues caused by such tricks.

Thanks and best regards
-Lv

> 
> Thanks,
> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
