Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaGLCyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:54:14 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:23095
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754666AbaGLCyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:54:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "hch@infradead.org" <hch@infradead.org>
CC: James Bottomley <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPnQc52vh72TcerE+9u7O+On3hT5ubvf7A
Date: Sat, 12 Jul 2014 02:53:48 +0000
Message-ID: <2f82b93e74bb472caaa142fecde86b82@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-4-git-send-email-kys@microsoft.com>
	<20140709084300.GD6012@infradead.org>
	<a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	<2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	<20140711063216.GA20660@infradead.org> <yq1vbr42gzp.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1vbr42gzp.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(377454003)(189002)(199002)(51704005)(81542001)(74662001)(2656002)(87936001)(99286002)(85852003)(20776003)(77982001)(93886003)(64706001)(86362001)(85306003)(76176999)(4396001)(31966008)(107046002)(19580395003)(81342001)(33646001)(83322001)(105586002)(74316001)(76482001)(19580405001)(54356999)(46102001)(76576001)(106356001)(50986999)(95666004)(86612001)(99396002)(80022001)(101416001)(66066001)(79102001)(21056001)(106116001)(83072002)(74502001)(92566001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Friday, July 11, 2014 5:54 AM
> To: hch@infradead.org
> Cc: James Bottomley; KY Srinivasan; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; stable@vger.kernel.org;
> linux-scsi@vger.kernel.org; ohering@suse.com; jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> >>>>> "hch" == hch@infradead org <hch@infradead.org> writes:
> 
> (Back from vacation: Bear with me while I'm catching up on two weeks of
> linux-scsi stuff...)
> 
> hch> I think the problem is a differnet one.  If we have the logical
> hch> provisioning EVPD it configures what method to use, but if we don't
> hch> have one we simply check for a max unmap blocks field, and if
> hch> that's not present use WRITE SAME.
> 
> Yeah, that was done to accommodate the devices out there that predate the
> LBP VPD. There sadly are several still. And it's hard to motivate people to
> update their storage array firmware even when updates are readily available.
> 
> hch> The patch checks the no_write_same flag before doing that, for
> hch> which we also have to do the write_same setup before the discard
> hch> setup in sd_revalidate_disk.
> 
> The no_write_same was introduced to disable the REQ_WRITE_SAME use
> case where we have no INQUIRY/READ CAPACITY/VPD flags to key off of to
> determine whether it is safe to send the commands.
> 
> no_write_same does not preclude the REQ_DISCARD variants of
> WRITE_SAME. Those are gated by the discard heuristics exclusively.
> 
> So first of all I'd like to know whether it's a WRITE SAME(16) or a WRITE
> SAME(16) with the UNMAP bit set that's coming down.
> 
> hch> Ky: does hyperv support UNMAP?  If so any idea why it doesn't set
> hch> the maximum unmap block count field in the EVPD?
> 
> We shouldn't be sending down WRITE SAME(16) with the UNMAP bit set
> unless the device sets LBPME=1 in the READ CAPACITY(16) response.
> 
> So what does the storsvc report as its thin provisioning capabilities?
Given that our current Host (ws2012 r2) advertises SPC-2 compliance, Linux does not even query this page. We support UNMAP.
We just prototyped a host where we advertised SPC-3 compliance and Linux queries the EVPD page and does not use WRITE_SAME_16

K. Y
