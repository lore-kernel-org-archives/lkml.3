Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaETNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:54:09 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:50028
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751598AbaETNyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:54:06 -0400
X-WSS-ID: 0N5VL9X-08-2U1-02
X-M-MSG: 
From: "Cornwall, Jay" <Jay.Cornwall@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>,
        "Naru, Kim" <Kim.Naru@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Thread-Topic: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Thread-Index: AQHPbz6oQgh21rsJfkKuVzP73ph2r5tAEomA///gmiWACdFkgP//wGUQ
Date: Tue, 20 May 2014 13:53:57 +0000
Message-ID: <99CB3FADB756624A867BE9481439561C334C9EB5@satlexdag03.amd.com>
References: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140514092920.GB6026@8bytes.org>
 <99CB3FADB756624A867BE9481439561C334C9045@satlexdag03.amd.com>
 <20140520133245.GE17056@8bytes.org>
In-Reply-To: <20140520133245.GE17056@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(24454002)(80022001)(86362001)(74502001)(74662001)(31966008)(19580405001)(44976005)(46406003)(50986999)(97756001)(64706001)(33656001)(46102001)(97736001)(76176999)(54356999)(99396002)(23726002)(68736004)(20776003)(81342001)(2656002)(79102001)(81542001)(87936001)(83072002)(50466002)(85852003)(47776003)(4396001)(77982001)(76482001)(53416003)(92726001)(84676001)(92566001)(19580395003)(83322001)(101416001)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB009;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02176E2458
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Jay.Cornwall@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Tuesday, May 20, 2014 08:33
> 
> On Wed, May 14, 2014 at 11:38:25AM +0000, Cornwall, Jay wrote:
> > Hi,
> >
> > I'm not sure why you're submitting this, Suravee?
> >
> > We already agreed that we need the extra mmu_notifier point, proposed
> > by Joerg back in 2011, to eliminate the race. I had thought we were
> > waiting on that to be implemented.
> 
> Speaking of this, would it also be possible to hold back all faults (so not
> sending back ppr-comletions) between invalidate_range_start/end()?
> Or will the hardware run into a timeout when it takes too long to process a
> fault or when it issued the maximum number of parallel faults?

I haven't located a comment on this in the HW documentation. The ATC will set a MMIO register flag if a response takes more than 2^32 cycles (I'm not certain of the frequency). I don't know if this is fatal. I have experimented with adding significant delays into the PPR handler in the past without affecting test cases.

My larger concern with this design is that the only situations in which there is a conflict between the MM and IOTLB activity is where the IOTLB client is racing with munmap() or physical page relocation. Both of these are low proability scenarios. However, blocking PPR completions for all MM invalidations would impact all IOTLB client activity.

This is particularly true for heterogeneous applications.
