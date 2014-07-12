Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaGLQfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:35:17 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:42207
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752139AbaGLQfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:35:14 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Topic: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Index: AQHPmwbaMJcVE9K7bk+ZFkv2/whfmJuXbd+AgACmi9CAAQoygIADhKQAgAAEnBA=
Date: Sat, 12 Jul 2014 16:35:10 +0000
Message-ID: <ad924a86fdb14712a0125ee313b56657@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-6-git-send-email-kys@microsoft.com>
	<20140709084415.GF6012@infradead.org>
	<9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
	<CAFLxGvzFTeE9J-4KFUn9q1fggB_pGBHEMEPcBtDhje+uRm7yMw@mail.gmail.com>
 <CAFLxGvyJRr4dXEqv2KfCf30Q-kiA6=mPcKB+m4i1y79Xeoqe3A@mail.gmail.com>
In-Reply-To: <CAFLxGvyJRr4dXEqv2KfCf30Q-kiA6=mPcKB+m4i1y79Xeoqe3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(189002)(199002)(51704005)(377454003)(13464003)(24454002)(86612001)(95666004)(50986999)(101416001)(80022001)(99396002)(46102001)(19580405001)(54356999)(76482001)(74316001)(76576001)(106356001)(66066001)(92566001)(74502001)(83072002)(21056001)(79102001)(106116001)(85852003)(20776003)(74662001)(2656002)(81542001)(87936001)(99286002)(107046002)(33646001)(19580395003)(93886003)(81342001)(105586002)(77982001)(83322001)(64706001)(86362001)(31966008)(76176999)(4396001)(85306003)(110136001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6CGZhj0028186



> -----Original Message-----
> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Saturday, July 12, 2014 9:17 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
> 
> On Thu, Jul 10, 2014 at 12:33 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Wed, Jul 9, 2014 at 8:51 PM, KY Srinivasan <kys@microsoft.com> wrote:
> >>
> >>
> >>> -----Original Message-----
> >>> From: Christoph Hellwig [mailto:hch@infradead.org]
> >>> Sent: Wednesday, July 9, 2014 1:44 AM
> >>> To: KY Srinivasan
> >>> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> >>> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> >>> apw@canonical.com; linux-scsi@vger.kernel.org
> >>> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort
> >>> handler
> >>>
> >>> On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
> >>> > Implement a simple abort handler. The host does not support
> >>> > "Abort"; just ensure that all inflight I/Os have been accounted for.
> >>>
> >>> The abort handler should abort a single command, not wait for all of
> them.
> >>> What issue do you see that this tries to address?
> >>
> >> On Azure, we sometimes have unbounded I/O latencies and some
> >> distributions (such as SLES12) based on recent kernels are invoking the
> "Abort Handler". Unfortunately, our scsi emulation on the host does not
> support aborting a command.
> >> The issue I have seen is that the upper level scsi code attempts error
> recovery when the command times out and finally frees up the command.
> >> The host subsequently responds to the command that has timed out and
> >> since the memory has been freed up, we end up touching freed memory
> >> in this driver. Since the host is also doing error recovery, by just delaying
> the error handler in the guest until we can account for all the in-flight
> commands, we can get around the problem.
> >
> > I see strange issues in Azure and maybe they are related to this.
> > Some Linux machines crash in a way that no disk IO is possible (thus,
> > no SSH for me) but they still respond to ping. It happens rather
> > seldom (every few weeks).
> >
> > Do you see similar symptoms?
> 
> ping?

Sorry for the delayed response. Yes we have seen resets and potentially the file system mounted
Read-only because of the I/O timeouts. We have increased the standard scsi timeouts. Implementing the
Timedout handler as we have done now should solve this problem.

K. Y
> 
> --
> Thanks,
> //richard
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
