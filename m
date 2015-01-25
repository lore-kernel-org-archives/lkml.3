Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbbAYNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:16:59 -0500
Received: from mail-by2on0128.outbound.protection.outlook.com ([207.46.100.128]:36769
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753110AbbAYNQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:16:56 -0500
X-WSS-ID: 0NIQI80-08-SVA-02
X-M-MSG: 
Message-ID: <54C4ECBC.5070301@amd.com>
Date: Sun, 25 Jan 2015 15:16:44 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        <iommu@lists.linux-foundation.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [PATCH 2/2] iommu/amd: use handle_mm_fault directly v2
References: <1415830228-7844-1-git-send-email-jbarnes@virtuousgeek.org>
 <1415830228-7844-2-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1415830228-7844-2-git-send-email-jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; linux-foundation.org; dkim=none (message
 not signed) header.d=none;linux-foundation.org; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(479174004)(164054003)(24454002)(51704005)(377454003)(77156002)(46102003)(77096005)(62966003)(65806001)(36756003)(47776003)(105586002)(92566002)(87936001)(110136001)(2950100001)(54356999)(106466001)(23746002)(33656002)(101416001)(83506001)(86362001)(64126003)(19580405001)(50466002)(19580395003)(76176999)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB207;
X-Forefront-PRVS: 046753C63C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2015 13:16:53.4597
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/13/2014 12:10 AM, Jesse Barnes wrote:
> This could be useful for debug in the future if we want to track
> major/minor faults more closely, and also avoids the put_page trick we
> used with gup.
>
> In order to do this, we also track the task struct in the PASID state
> structure.  This lets us update the appropriate task stats after the
> fault has been handled, and may aid with debug in the future as well.
>
> v2: drop task accounting; GPU activity may have been submitted by a
>      different thread than the one binding the PASID (Joerg)
>
> Tested-by: Oded Gabbay<oded.gabbay@amd.com>
> Signed-off-by: Jesse Barnes<jbarnes@virtuousgeek.org>

Hi Jesse,

I know I tested your patch a few months ago, but we have a new feature (still 
internally) in the driver, which has some conflicts with this patch.

Our feature is basically doing "exception handling" by registering a callback 
function with the iommu driver in inv_ppr_cb.

Now, with the old code (we used 3.17.2 until a few days ago), this callback 
function was called in, at least, three use-cases (which we are testing):

(1) Writing to a "bad" system memory address, which is *not* in the process's 
memory address space.

(2) Writing to a read-only page, which is inside the process's memory address space

(3) Reading from a page without permissions, which is inside the process's 
memory address space

With the new code (3.19-rc5), this callback is only called in the first 
use-case, while (2) and (3) are handled in handle_mm_fault(), which is now 
called from do_fault. The return value of handle_mm_fault() is 0, so 
handle_fault_error() is not called and amdkfd doesn't get notification, hence 
our test fails.

This is a problem for us as we want to propagate these exceptions to the user 
space HSA runtime, so it could handle them.

I have 2 questions:

1. Why don't we call inv_ppr_cb() in any case ?
2. How come handle_mm_fault() returns 0 in cases (2) and (3) ? Or in other 
words, what is considered to be a success in handle_mm_fault() and is it visible 
to the user-space process ?

Thanks,

	Oded
