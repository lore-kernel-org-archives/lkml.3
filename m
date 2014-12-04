Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaLDUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:44:37 -0500
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:6545
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752979AbaLDUof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:44:35 -0500
Message-ID: <5480BFAA.2020106@ixiacom.com>
Date: Thu, 4 Dec 2014 22:10:18 +0200
From: Leonard Crestez <lcrestez@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
References: <547E3E57.3040908@ixiacom.com> <20141204175713.GE2995@htj.dyndns.org>
In-Reply-To: <20141204175713.GE2995@htj.dyndns.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [205.168.23.154]
X-ClientProxiedBy: CO1PR06CA036.namprd06.prod.outlook.com (10.242.160.26) To
 BN3PR0601MB1153.namprd06.prod.outlook.com (25.160.157.18)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1153;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1153;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(377454003)(479174003)(24454002)(189002)(199003)(51704005)(68736005)(65816999)(76176999)(87266999)(54356999)(62966003)(50986999)(110136001)(42186005)(20776003)(47776003)(66066001)(101416001)(33656002)(77096005)(23746002)(36756003)(107046002)(31966008)(106356001)(83506001)(105586002)(77156002)(40100003)(80316001)(46102003)(87976001)(92566001)(97736003)(4396001)(64706001)(50466002)(21056001)(86362001)(122386002)(99396003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0601MB1153;H:[10.205.20.121];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1153;
X-OriginatorOrg: ixiacom.com
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 205.168.23.154
X-MS-Exchange-CrossPremises-AuthSource: BN3PR0601MB1153.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-AVStamp-Service: 1.0
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BN3PR0601MB1153.namprd06.prod.outlook.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 07:57 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 03, 2014 at 12:33:59AM +0200, Leonard Crestez wrote:
>> It seems that free_percpu performance is very bad when working with small 
>> objects. The easiest way to reproduce this is to allocate and then free a large 
>> number of percpu int counters in order. Small objects (reference counters and 
>> pointers) are common users of alloc_percpu and I think this should be fast.
>> This particular issue can be encountered with very large number of net_device
>> structs.
> 
> Do you actually experience this with an actual workload?  The thing is
> allocation has the same quadratic complexity.  If this is actually an
> issue (which can definitely be the case), I'd much prefer implementing
> a properly scalable area allocator than mucking with the current
> implementation.

Yes, we are actually experiencing issues with this. We create lots of virtual
net_devices and routes, which means lots of percpu counters/pointers. In particular
we are getting worse performance than in older kernels because the net_device refcnt
is now a percpu counter. We could turn that back into a single integer but this
would negate an upstream optimization.

We are working on top of linux_3.10. We already pulled some allocation optimizations.
At least for simple allocation patterns pcpu_alloc does not appear to be unreasonably
slow.

Having a "properly scalable" percpu allocator would be quite nice indeed.

Regards,
Leonard
