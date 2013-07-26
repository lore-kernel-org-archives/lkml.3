Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3GZByH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:54:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:11898 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384Ab3GZByE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:54:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,747,1367996400"; 
   d="scan'208";a="376305761"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Topic: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Index: AQHOh3wWhtcRfGeNDUSAzJ7WvM5MAZl1Zu+AgADNjlA=
Date: Fri, 26 Jul 2013 01:54:00 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <cover.1374566394.git.lv.zheng@intel.com>
 <d9d5acba01eb80580e7696c50db4263ded86a86c.1374566394.git.lv.zheng@intel.com>
 <2501577.sf07PMEtR1@vostro.rjw.lan>
In-Reply-To: <2501577.sf07PMEtR1@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q1sATj008419

> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, July 26, 2013 5:29 AM
> 
> On Tuesday, July 23, 2013 04:09:43 PM Lv Zheng wrote:
> > This patch adds reference couting for ACPI operation region handlers to fix
> > races caused by the ACPICA address space callback invocations.
> >
> > ACPICA address space callback invocation is not suitable for Linux
> > CONFIG_MODULE=y execution environment.
> 
> Actually, can you please explain to me what *exactly* the problem is?

OK.  I'll add race explanations in the next revision.

The problem is there is no "lock" held inside ACPICA for invoking operation region handlers.
Thus races happens between the acpi_remove/install_address_space_handler and the handler/setup callbacks.

This is correct per ACPI specification.
As if there is interpreter locks held for invoking operation region handlers, the timeout implemented inside the operation region handlers will make all locking facilities (Acquire or Sleep,...) timed out.
Please refer to ACPI specification "5.5.2 Control Method Execution":
Interpretation of a Control Method is not preemptive, but it can block. When a control method does block, OSPM can initiate or continue the execution of a different control method. A control method can only assume that access to global objects is exclusive for any period the control method does not block.

So it is pretty much likely that ACPI IO transfers are locked inside the operation region callback implementations.
Using locking facility to protect the callback invocation will risk dead locks.

Thanks
-Lv

> Rafael

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
