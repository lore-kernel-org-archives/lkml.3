Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbaJ1HIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:08:53 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:5856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753233AbaJ1HIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:08:51 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Topic: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Index: Ac/yfEPZo4Dur33tTNaXzR8m0tIt+Q==
Date: Tue, 28 Oct 2014 07:08:04 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C610567A76@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(53754006)(164054003)(199003)(84676001)(47776003)(64706001)(20776003)(77096002)(85306004)(86612001)(69596002)(68736004)(66066001)(44976005)(6806004)(85852003)(87936001)(99396003)(86146001)(97736003)(2656002)(95666004)(76482002)(92726001)(46406003)(23726002)(107046002)(4396001)(229853001)(26826002)(33656002)(92566001)(81156004)(106466001)(55846006)(21056001)(50466002)(16796002)(31966008)(120916001)(86362001)(97756001)(46102003)(54356999)(80022003)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:CH1PR03MB610;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CH1PR03MB610;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CH1PR03MB624;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I suspect slow_virt_to_phys() may not work with vmalloc() in
the 32-bit PAE case(when the pa > 4GB), probably due to 2MB page(?)

Is there any known issue with slow_virt_to_phys() + vmalloc() +
32-bit PAE + 2MB page?

>From what I read the code of slow_virt_to_phys(), the variable 'psize' is
assigned with a value but not used at all -- is this a bug?


phys_addr_t slow_virt_to_phys(void *__virt_addr)
{
        unsigned long virt_addr = (unsigned long)__virt_addr;
        phys_addr_t phys_addr;
        unsigned long offset;
        enum pg_level level;
        unsigned long psize;
        unsigned long pmask;
        pte_t *pte;

        pte = lookup_address(virt_addr, &level);
        BUG_ON(!pte);
        psize = page_level_size(level);
        pmask = page_level_mask(level);
        offset = virt_addr & ~pmask;
        phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
        return (phys_addr | offset);
}

Thanks,
-- Dexuan

