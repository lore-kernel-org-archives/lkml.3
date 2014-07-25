Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbaGYD1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:27:18 -0400
Received: from [207.46.163.142] ([207.46.163.142]:59369 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbaGYD1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:27:17 -0400
X-WSS-ID: 0N98ZHE-08-LJ2-02
X-M-MSG: 
From: "Sander, Ben" <ben.sander@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joerg Roedel <joro@8bytes.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, "Hugh Dickins" <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Cornwall, Jay" <Jay.Cornwall@amd.com>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 0/3] mmu_notifier: Allow to manage CPU external TLBs
Thread-Topic: [PATCH 0/3] mmu_notifier: Allow to manage CPU external TLBs
Thread-Index: AQHPp0yeauRiu03ozUKi9x6pH88Q7puwI66A///5sr8=
Date: Fri, 25 Jul 2014 03:10:28 +0000
Message-ID: <D7B2CBFE-6D70-4999-AC45-48773872FA08@amd.com>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>,<20140724163303.df34065a3c3b26c0a4b3bab1@linux-foundation.org>
In-Reply-To: <20140724163303.df34065a3c3b26c0a4b3bab1@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(377454003)(24454002)(199002)(189002)(33656002)(53416004)(83072002)(106466001)(81542001)(20776003)(68736004)(64706001)(107046002)(4396001)(23726002)(83716003)(86362001)(85852003)(80022001)(106116001)(95666004)(46406003)(110136001)(105586002)(85306003)(82746002)(92566001)(77096002)(92726001)(81342001)(77982001)(84676001)(50986999)(44976005)(97756001)(97736001)(99396002)(2656002)(46102001)(83322001)(19580395003)(31966008)(74502001)(76482001)(50466002)(36756003)(47776003)(76176999)(74662001)(19580405001)(21056001)(79102001)(101416001)(54356999)(87936001)(104396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=ben.sander@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. AMD has tested this with the iommuv2 driver and verified it works correctly.  There is a corresponding change in the iommuv2 driver to use the new API. 

> On Jul 24, 2014, at 6:33 PM, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> 
>> On Thu, 24 Jul 2014 16:35:38 +0200 Joerg Roedel <joro@8bytes.org> wrote:
>> 
>> here is a patch-set to extend the mmu_notifiers in the Linux
>> kernel to allow managing CPU external TLBs. Those TLBs may
>> be implemented in IOMMUs or any other external device, e.g.
>> ATS/PRI capable PCI devices.
>> 
>> The problem with managing these TLBs are the semantics of
>> the invalidate_range_start/end call-backs currently
>> available. Currently the subsystem using mmu_notifiers has
>> to guarantee that no new TLB entries are established between
>> invalidate_range_start/end. Furthermore the
>> invalidate_range_start() function is called when all pages
>> are still mapped and invalidate_range_end() when the pages
>> are unmapped an already freed.
>> 
>> So both call-backs can't be used to safely flush any non-CPU
>> TLB because _start() is called too early and _end() too
>> late.
>> 
>> In the AMD IOMMUv2 driver this is currently implemented by
>> assigning an empty page-table to the external device between
>> _start() and _end(). But as tests have shown this doesn't
>> work as external devices don't re-fault infinitly but enter
>> a failure state after some time.
>> 
>> Next problem with this solution is that it causes an
>> interrupt storm for IO page faults to be handled when an
>> empty page-table is assigned.
>> 
>> To solve this situation I wrote a patch-set to introduce a
>> new notifier call-back: mmu_notifer_invalidate_range(). This
>> notifier lifts the strict requirements that no new
>> references are taken in the range between _start() and
>> _end(). When the subsystem can't guarantee that any new
>> references are taken is has to provide the
>> invalidate_range() call-back to clear any new references in
>> there.
>> 
>> It is called between invalidate_range_start() and _end()
>> every time the VMM has to wipe out any references to a
>> couple of pages. This are usually the places where the CPU
>> TLBs are flushed too and where its important that this
>> happens before invalidate_range_end() is called.
>> 
>> Any comments and review appreciated!
> 
> It looks pretty simple and harmless.
> 
> I assume the AMD IOMMUv2 driver actually uses this and it's all
> tested and good?  What is the status of that driver?
> 
