Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbaKNBWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:22:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:36263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbaKNBWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:22:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,381,1413270000"; 
   d="scan'208";a="636718832"
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
Thread-Index: AQHP/hNuclXJFrB3lkaCapiXtYP3B5xd1baw//+DeYCAAIOIIIAAxeOAgACoDvA=
Date: Fri, 14 Nov 2014 01:21:51 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A0A0F@SHSMSX101.ccr.corp.intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <1961414.bGx3EdA0yT@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88026A0737@SHSMSX101.ccr.corp.intel.com>
 <1586902.iI2oFdt4zk@vostro.rjw.lan>
In-Reply-To: <1586902.iI2oFdt4zk@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAE1MCYe028908

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Friday, November 14, 2014 6:38 AM
> 
> On Thursday, November 13, 2014 02:52:03 AM Zheng, Lv wrote:
> > Hi, Rafael
> >
> > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > Sent: Thursday, November 13, 2014 10:59 AM
> > >
> > > On Thursday, November 13, 2014 02:31:08 AM Zheng, Lv wrote:
> > > > Hi, Rafael
> > > >
> > > > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > > > Sent: Wednesday, November 12, 2014 9:17 AM
> > >
> > > [cut]
> > >
> > > > > > +
> > > > > > +static int ec_create_event_poller(struct acpi_ec *ec)
> > > > > > +{
> > > > > > +	struct task_struct *t;
> > > > > > +
> > > > > > +	t = kthread_run(acpi_ec_event_poller, ec, "ec/gpe-%lu", ec->gpe);
> > > > >
> > > > > Does it have to be a kernel thread?
> > > > >
> > > > > What about using a workqueue instead?
> > > >
> > > > Actually I just want to use threaded IRQ here in response to Andi Kleen's comment.
> > > > If acpi_irq is registered as threaded IRQ, then acpi_ec_event_poller() will be the
> > > > callback from it.
> > >
> > > How so?
> > >
> > > > Since ACPICA is not ready for threaded IRQ currently, we cannot proceed at this point.
> > > > So I copied the threaded IRQ code from kernel/irq/manage.c here to prepare threaded IRQ logics.
> > >
> > > Oh dear, no.
> > >
> > > This isn't the way forward here.
> > >
> > > > Using a separate work queue, we didn't decrease the kernel thread count.
> > >
> > > Why does that matter at all?
> > >
> > > > And the code written for the work item cannot be derived when things are
> > > > switched to the threaded IRQ.
> > > > So I used kthread here.
> > >
> > > Please use a workqueue instead.  If/when we need to switch over to threaded
> > > IRQs, we'll do the work then.  For now, let's not complicate things more
> > > than necessary.
> >
> > It seems we need the thread because we will move polling code from ec_poll() to acpi_ec_event_poller().
> > This will happen right after these cleanups.
> > That's the threaded IRQ logic - IRQ is polled in the thread.
> > We cannot achieve this using work queue.
> 
> OK
> 
> In that case I'm not going to apply this patch, because it is not a cleanup.
> It doesn't belong to this series, but to the series that will move the
> polling code.

If we'll defer some execution and we know there will only be one execution corresponding to one indication, work item can fit.
If we'll poll something or there is no such 1 to 1 correspondence, using work queue may accumulate useless work items.

We have the work item to evaluate _Qxx in the EC driver, for the IRQ indications, IMO, it's better to use an IRQ poller thread.
And it's easier for me to control future improvements using kthread:
1. We need the SCI_EVT draining support for Samsung firmware. For Samsung, 1 SCI_EVT indication may mean several QR_EC transactions as we cannot rely on SCI_EVT value, it can be cleared by Samsung firmware before 0x00 is returned.
2. For Acer firmware, firmware will refuse to respond QR_EC if SCI_EVT=0 and further transactions will be blocked. Whether a transaction abort support is needed is unclear to me now because I'm not sure if this will appear on other platforms. When supporting this, I may face the difficulty to abort several queued up work items but for IRQ poller thread, I only need to abort the very 1 query transaction.

> Does patch [6/6] depend on [5/6]?

Patch [6/6] depends on [5/6].
So you can just take the patch 1-4 first..
I'll ask Samsung users to test an improved event draining support based on the poller thread and re-send the patch [5/5] and patch [6/6] after that.

Thanks and best regards
-Lv

> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
