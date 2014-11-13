Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaKMCxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:53:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:61931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaKMCxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:53:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415778701"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Andi Kleen (ak@linux.intel.com)" <ak@linux.intel.com>
Subject: RE: [PATCH 5/6] ACPI/EC: Cleanup QR_SC command processing by adding
 a kernel thread to poll EC events.
Thread-Topic: [PATCH 5/6] ACPI/EC: Cleanup QR_SC command processing by
 adding a kernel thread to poll EC events.
Thread-Index: AQHP/hNuclXJFrB3lkaCapiXtYP3B5xd1baw//+DeYCAAIOIIA==
Date: Thu, 13 Nov 2014 02:52:03 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A0737@SHSMSX101.ccr.corp.intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <2277351.09XTT17U9b@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88026A0706@SHSMSX101.ccr.corp.intel.com>
 <1961414.bGx3EdA0yT@vostro.rjw.lan>
In-Reply-To: <1961414.bGx3EdA0yT@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD2rTBO021145

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Thursday, November 13, 2014 10:59 AM
> 
> On Thursday, November 13, 2014 02:31:08 AM Zheng, Lv wrote:
> > Hi, Rafael
> >
> > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > Sent: Wednesday, November 12, 2014 9:17 AM
> 
> [cut]
> 
> > > > +
> > > > +static int ec_create_event_poller(struct acpi_ec *ec)
> > > > +{
> > > > +	struct task_struct *t;
> > > > +
> > > > +	t = kthread_run(acpi_ec_event_poller, ec, "ec/gpe-%lu", ec->gpe);
> > >
> > > Does it have to be a kernel thread?
> > >
> > > What about using a workqueue instead?
> >
> > Actually I just want to use threaded IRQ here in response to Andi Kleen's comment.
> > If acpi_irq is registered as threaded IRQ, then acpi_ec_event_poller() will be the
> > callback from it.
> 
> How so?
> 
> > Since ACPICA is not ready for threaded IRQ currently, we cannot proceed at this point.
> > So I copied the threaded IRQ code from kernel/irq/manage.c here to prepare threaded IRQ logics.
> 
> Oh dear, no.
> 
> This isn't the way forward here.
> 
> > Using a separate work queue, we didn't decrease the kernel thread count.
> 
> Why does that matter at all?
> 
> > And the code written for the work item cannot be derived when things are
> > switched to the threaded IRQ.
> > So I used kthread here.
> 
> Please use a workqueue instead.  If/when we need to switch over to threaded
> IRQs, we'll do the work then.  For now, let's not complicate things more
> than necessary.

It seems we need the thread because we will move polling code from ec_poll() to acpi_ec_event_poller().
This will happen right after these cleanups.
That's the threaded IRQ logic - IRQ is polled in the thread.
We cannot achieve this using work queue.

Best regards
-Lv
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
