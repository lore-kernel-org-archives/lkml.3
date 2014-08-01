Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaHASpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:45:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:8881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbaHASpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:45:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,781,1400050800"; 
   d="scan'208";a="464077106"
From: "Zwisler, Ross" <ross.zwisler@intel.com>
To: "openosd@gmail.com" <openosd@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
Thread-Topic: [PATCH v8 04/22] Change direct_access calling convention
Thread-Index: AQHPrP403h2bNslEHkOap3XJoZ/hlJu8jNkA
Date: Fri, 1 Aug 2014 18:45:20 +0000
Message-ID: <1406918720.3198.3.camel@rzwisler-mobl1.amr.corp.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
	 <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com>
	 <53D9174C.7040906@gmail.com> <20140730194503.GQ6754@linux.intel.com>
	 <53DA165E.8040601@gmail.com> <20140731141315.GT6754@linux.intel.com>
	 <53DA60A5.1030304@gmail.com> <20140731171953.GU6754@linux.intel.com>
	 <53DA8518.3090604@gmail.com>
	 <1406838602.14136.12.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1406838602.14136.12.camel@rzwisler-mobl1.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.112.154]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CDAB0DF6035D34B987649760C33DA03@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s71IjTJs017862

On Thu, 2014-07-31 at 14:30 -0600, Ross Zwisler wrote:
> On Thu, 2014-07-31 at 21:04 +0300, Boaz Harrosh wrote:
> > On 07/31/2014 08:19 PM, Matthew Wilcox wrote:
> > > On Thu, Jul 31, 2014 at 06:28:37PM +0300, Boaz Harrosh wrote:
> > >> Matthew what is your opinion about this, do we need to push for removal
> > >> of the partition dead code which never worked for brd, or we need to push
> > >> for fixing and implementing new partition support for brd?
> > > 
> > > Fixing the code gets my vote.  brd is useful for testing things ... and
> > > sometimes we need to test things that involve partitions.
> > > 
> > 
> > OK I'm on it, its what I'm doing today.
> > 
> > rrr I manged to completely trash my vm by doing 'make install' of
> > util-linux and after reboot it never recovered, I remember that
> > mount complained about a now missing library and I forgot and rebooted,
> > that was the end of that. Anyway I installed a new fc20 system wanted
> > that for a long time over my old fc18
> 
> Ah, I'm already working on this as well.  :)  If you want you can wait for my
> patches to BRD & test - they should be out this week.
> 
> I'm planning on adding get_geo() and doing dynamic minors as is done in NVMe.

Ugh, it turns out that if you remove the "*part = 0" bit from brd_probe(),
attempts to create new BRD devices using mknod hit a deadlock.  Removal of
that code, ie:

@@ -550,7 +549,6 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
        kobj = brd ? get_disk(brd->brd_disk) : NULL;
        mutex_unlock(&brd_devices_mutex);

-       *part = 0;
        return kobj;
 }

is necessary if we want to do any sort of partitioning.

This isn't a use case for PRD, so I'll move over to that and try to add
dynamic minors there instead.  If we really do want partitions to work in BRD,
though, eventually we'll have to debug the deadlock.

- Ross

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
