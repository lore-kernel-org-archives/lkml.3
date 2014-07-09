Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaGISvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:51:45 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:33524
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755274AbaGISvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:51:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Topic: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Index: AQHPmwbaMJcVE9K7bk+ZFkv2/whfmJuXbd+AgACmi9A=
Date: Wed, 9 Jul 2014 18:51:38 +0000
Message-ID: <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
In-Reply-To: <20140709084415.GF6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(13464003)(377454003)(189002)(199002)(51704005)(33646001)(20776003)(83072002)(46102001)(66066001)(99286002)(80022001)(106116001)(77982001)(101416001)(21056001)(74502001)(107046002)(93886003)(110136001)(87936001)(86362001)(85306003)(81542001)(85852003)(76176999)(4396001)(74662001)(81342001)(19580395003)(76576001)(83322001)(31966008)(105586002)(2656002)(64706001)(19580405001)(106356001)(74316001)(54356999)(95666004)(86612001)(79102001)(50986999)(99396002)(76482001)(92566001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:44 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
> 
> On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
> > Implement a simple abort handler. The host does not support "Abort";
> > just ensure that all inflight I/Os have been accounted for.
> 
> The abort handler should abort a single command, not wait for all of them.
> What issue do you see that this tries to address?

On Azure, we sometimes have unbounded I/O latencies and some distributions (such as SLES12) based on recent kernels are invoking
the "Abort Handler". Unfortunately, our scsi emulation on the host does not support aborting a command.
The issue I have seen is that the upper level scsi code attempts error recovery when the command times out and finally frees up the command.
The host subsequently responds to the command that has timed out and since the memory has been freed up, we end up touching freed memory
in this driver. Since the host is also doing error recovery, by just delaying the error handler in the guest until we can account for all the in-flight commands,
we can get around the problem.

Regards,

K. Y

