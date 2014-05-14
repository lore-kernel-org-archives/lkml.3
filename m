Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaENOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:12:20 -0400
Received: from mail-bn1bon0057.outbound.protection.outlook.com ([157.56.111.57]:45662
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762AbaENOMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:12:19 -0400
X-Greylist: delayed 3616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 10:12:18 EDT
X-WSS-ID: 0N5KB02-08-2LS-02
X-M-MSG: 
From: "Cornwall, Jay" <Jay.Cornwall@amd.com>
To: Joerg Roedel <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>,
        "Naru, Kim" <Kim.Naru@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Thread-Topic: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Thread-Index: AQHPbz6oQgh21rsJfkKuVzP73ph2r5tAEomA///gmiU=
Date: Wed, 14 May 2014 11:38:25 +0000
Message-ID: <99CB3FADB756624A867BE9481439561C334C9045@satlexdag03.amd.com>
References: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>,<20140514092920.GB6026@8bytes.org>
In-Reply-To: <20140514092920.GB6026@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(189002)(199002)(85852003)(33656001)(46406003)(74502001)(64706001)(79102001)(53416003)(54356999)(81342001)(92726001)(74662001)(31966008)(76482001)(77982001)(50466002)(50986999)(2009001)(83072002)(76176999)(81542001)(4396001)(23726002)(19580405001)(20776003)(84676001)(87936001)(99396002)(46102001)(86362001)(19580395003)(97756001)(68736004)(2656002)(47776003)(55846006)(97736001)(92566001)(101416001)(21056001)(44976005)(83322001)(80022001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB124;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Jay.Cornwall@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not sure why you're submitting this, Suravee?

We already agreed that we need the extra mmu_notifier point, proposed by Joerg back in 2011, to eliminate the race. I had thought we were waiting on that to be implemented.

________________________________________
From: Joerg Roedel [joro@8bytes.org]
Sent: Wednesday, May 14, 2014 4:29 AM
To: Suthikulpanit, Suravee
Cc: iommu@lists.linux-foundation.org; Hurwitz, Sherry; Naru, Kim; linux-kernel@vger.kernel.org; Cornwall, Jay
Subject: Re: [PATCH] iommu/amd: Fix for L2 race with VM invalidation

On Wed, May 14, 2014 at 01:34:12AM -0500, suravee.suthikulpanit@amd.com wrote:
> A low probability race exists with this fix. Translations received
> within the critical section to PTEs which are concurrently being
> invalidated may resolve to stale mappings.

Sorry, no. This patch can cause silent data corruption when the pages in
these stale mappings get reused. I understand that the current way does
not work either and can cause failures in the GPU, but silent data
corruption is worse than that.

How about putting the page-fault requests on hold between
invalidate_range_start/end()? The GPU will not see the failures, just a
longer delay until the page faults are handled.


        Joerg


