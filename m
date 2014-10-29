Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaJ2Iaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:30:35 -0400
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:45760
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755859AbaJ2Iaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:30:30 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "dave.hansen@intel.com" <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Topic: Does slow_virt_to_phys() work with vmalloc() in the case of
 32bit-PAE and 2MB page?
Thread-Index: Ac/yfEPZo4Dur33tTNaXzR8m0tIt+QAD4M0AADDp7TA=
Date: Wed, 29 Oct 2014 08:14:42 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61056FE3F@HKNPRD3002MB017.064d.mgd.msft.net>
References: <F792CF86EFE20D4AB8064279AFBA51C610567A76@HKNPRD3002MB017.064d.mgd.msft.net>
 <F792CF86EFE20D4AB8064279AFBA51C610568754@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C610568754@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.68]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(53754006)(189002)(164054003)(377454003)(13464003)(51704005)(84676001)(19580395003)(68736004)(44976005)(19580405001)(95666004)(76482002)(46102003)(80022003)(97736003)(2501002)(6806004)(120916001)(99396003)(66066001)(69596002)(23726002)(86146001)(2656002)(55846006)(106466001)(77096002)(97756001)(50986999)(92566001)(64706001)(76176999)(31966008)(85852003)(54356999)(26826002)(4396001)(85306004)(33656002)(16796002)(46406003)(47776003)(21056001)(20776003)(87936001)(107046002)(81156004)(86612001)(92726001)(50466002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1210;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1210;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> Behalf Of Dexuan Cui
> Sent: Tuesday, October 28, 2014 16:51 PM
> To: dave.hansen@intel.com; Rik van Riel; H. Peter Anvin
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org
> Subject: RE: Does slow_virt_to_phys() work with vmalloc() in the case of
> 32bit-PAE and 2MB page?
> 
> > -----Original Message-----
> > From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> > Behalf Of Dexuan Cui
> > Sent: Tuesday, October 28, 2014 15:08 PM
> > To: Dave Hansen; Rik van Riel; H. Peter Anvin
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org
> > Subject: Does slow_virt_to_phys() work with vmalloc() in the case of 32bit-
> > PAE and 2MB page?
> >
> > Hi all,
> > I suspect slow_virt_to_phys() may not work with vmalloc() in
> > the 32-bit PAE case(when the pa > 4GB), probably due to 2MB page(?)
> >
> > Is there any known issue with slow_virt_to_phys() + vmalloc() +
> > 32-bit PAE + 2MB page?
> >
> > From what I read the code of slow_virt_to_phys(), the variable 'psize' is
> > assigned with a value but not used at all -- is this a bug?
> After reading through the code, I think there is no issue here, though the
> assignment of 'psize'  should be unnecessary, I think.

Hi all,
Finally it turns out there is a left-shift-overflow bug for 32-PAE here!

pte_pfn() returns a PFN of long (32bits in 32-PAE), then "long << PAGE_SHIFT"
will overflow for PFNs above 4GB.

I'm going to post the below fix in another mail:

@@ -409,7 +409,7 @@ phys_addr_t slow_virt_to_phys(void *__virt_addr)
        psize = page_level_size(level);
        pmask = page_level_mask(level);
        offset = virt_addr & ~pmask;
-       phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+       phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
        return (phys_addr | offset);
 }

Thanks,
-- Dexuan
