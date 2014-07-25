Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbaGYQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:47:41 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:38655
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934870AbaGYQri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:47:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Topic: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Index: AQHPpznyfmLHK0GnrkSEOCNbbvYH8ZuvP1KVgAAcOACAAAU+74ABn+tw
Date: Fri, 25 Jul 2014 16:47:35 +0000
Message-ID: <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
 <yq1egxakb0z.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1egxakb0z.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(129404003)(51704005)(199002)(189002)(92566001)(95666004)(81542001)(76576001)(99396002)(4396001)(85852003)(79102001)(83072002)(85306003)(105586002)(77096002)(101416001)(87936001)(76482001)(80022001)(50986999)(86362001)(19580395003)(74316001)(99286002)(76176999)(20776003)(19580405001)(74502001)(33646002)(77982001)(106116001)(83322001)(66066001)(74662001)(93886003)(2656002)(81342001)(31966008)(21056001)(54356999)(46102001)(64706001)(86612001)(106356001)(107046002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, July 24, 2014 8:54 AM
> To: Sitsofe Wheeler
> Cc: Martin K. Petersen; Christoph Hellwig; KY Srinivasan;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> So we can see it is really a SATA device that announces discard
> Sitsofe> correctly and supports discard through WRITE_SAME(16).
> 
> No, that's the SATA device that announces support for DSM TRIM, and as a
> result the Linux SATL reports support for WRITE SAME(16) w. the UNMAP bit
> set and LBPME.
> 
> Sitsofe> It is the act of passing it through Hyper-V that turned it into
> Sitsofe> a SCSI device that supports UNMAP (but not WRITE_SAME(16)),
> Sitsofe> doesn't announce its SCSI conformance number and doesn't
> Sitsofe> correctly announce which features it supports. Surely in this
> Sitsofe> case it's reasonable to quirk our way around the problem?
> 
> No. That's an issue in Hyper-V that'll you'll have to take up with Microsoft. I
> don't know what their passthrough limitations are for SCSI-ATA translation.
> Maybe K. Y. has some insight into this?

For the pass through case, the host validates the request and passes the request to the device.
However, not all scsi commands are passed through even though the device it is being passed through
may support the command. WRITE_SAME is one such command. Consequently, in the EVPD page,
we will set state indicating that WRITE_SAME is not supported (even if the device supports it).

Hope this helps.

K. Y 
> 
> There must be a reason why the VPD page was added and yet the device not
> flagged as LBPME=1.
> 
> Many vendors do not support UNMAP/WRITE SAME to DSM TRIM
> translation.
> Additionally, many vendors explicitly only whitelist drives that are known to
> be working correctly. Your drive is an ADATA and therefore very likely to be
> blacklisted by default by a vendor SATL.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
