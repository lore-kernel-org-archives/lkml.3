Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaKUCI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:08:26 -0500
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:14896
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756700AbaKUCIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:08:24 -0500
X-WSS-ID: 0NFD9XV-07-THC-02
X-M-MSG: 
Message-ID: <546E9E8E.5000303@amd.com>
Date: Thu, 20 Nov 2014 20:08:14 -0600
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <jiang.liu@linux.intel.com>, <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqdomain: Fix NULL pointer dererence in irq_domain_free_irqs_parent
References: <1416531745-24661-1-git-send-email-suravee.suthikulpanit@amd.com>
 <alpine.DEB.2.11.1411210219370.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411210219370.6439@nanos>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(189002)(199003)(164054003)(51704005)(479174003)(377454003)(92726001)(19580395003)(102836001)(76176999)(65816999)(99396003)(64706001)(33656002)(80316001)(84676001)(50986999)(83506001)(19580405001)(86362001)(87266999)(20776003)(46102003)(101416001)(65956001)(92566001)(23746002)(54356999)(110136001)(68736004)(47776003)(44976005)(50466002)(59896002)(87936001)(107046002)(36756003)(77156002)(62966003)(31966008)(21056001)(4396001)(120916001)(64126003)(95666004)(97736003)(106466001)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 07:32 PM, Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, suravee.suthikulpanit@amd.com wrote:
>> This patch checks if the parent domain is NULL before recursively freeing
>> irqs in the parent domains.
>
> Which is nonsense, because if the thing has not been allocated in the
> first place, then it cannot explode in the free path magically, except
> there is a missing check in the allocation path error handling.
>
> And that's obviously not the case simply because this originates from:
>> [<fffffe0000449278>] pci_disable_msix+0x40/0x50
>

Thomas,

In this case, I have the following irq domain hierarchy:

[GIC] -- [GICv2m] -- [MSI]

which recursively calling the freeing function:

In GIC domain, it currently defines the struct irq_domain_ops.free() with :
   --> irq_domain_free_irqs_top()
     |--> irq_domain_free_irqs_common()
       |--> irq_domain_free_irq_parent()
         |--> irq_domain_free_irqs_recursive()

and there is no check before passing the NULL domain->parent into the 
irq_domain_free_irqs_recursive(), which causes the error.

Since the GIC is the top most domain, it does not have parent domain.
So, I'm not sure what is missing from the allocation path error 
handling, as you mentioned.

Thanks,

Suravee
