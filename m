Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaHVBnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:43:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:50375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbaHVBni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,377,1406617200"; 
   d="scan'208";a="471444348"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: kernel boot fail with efi earlyprintk (bisected)
Thread-Topic: kernel boot fail with efi earlyprintk (bisected)
Thread-Index: AQHPu4XSRTaCxkfh/U+HttRB4JxB75vbBnYAgADUTDA=
Date: Fri, 22 Aug 2014 01:43:15 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880265EF49@SHSMSX101.ccr.corp.intel.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
In-Reply-To: <20140821205224.GJ29733@console-pimps.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is only limited entries in the x86 early mapping which is implemented by the FIXMAP.
So this means for all __init call invoked for x86, if there was a early mapping in it, it should be unmapped before exiting the __init call.

Using this rule, all __init call implementers can make sure that before entering the __init call, the limited number of FIXMAP entries is enough.

The following bisected commit just increase early mapping times from 1 to 2 in ACPICA early table handling code.
The number of 2 is less than the number of available FIXMAP entries.
And ACPICA code has ensured that all mappings are correctly unmapped after the table initialization.
So we didn't break the rule.

We can offer a workaround in ACPICA to reduce mapping count from 2 to 1 using a global option.
But since this report sounds like that the root cause is earlyprintk=efi has broken the above rule and the existing issue is triggered by this cleanup.
So could someone check the earlyprintk=efi code first?
I think earlyprintk=efi should either unmap the increased mapping or increase the number of FIXMAP entries in case earlyprintk=efi need additional early mappings.
Otherwise it will always be chances for earlyprintk=efi to break future code.

Thanks and best regards
-Lv

> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Friday, August 22, 2014 4:52 AM
> 
> On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > Hi,
> >
> > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > It keeps scrolling at the bottom line of screen.
> >
> > Bisected, the first bad commit is below:
> > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > Author: Lv Zheng <lv.zheng@intel.com>
> > Date:   Fri Apr 4 12:38:57 2014 +0800
> >
> >     ACPICA: Tables: Fix table checksums verification before installation.
> >
> >
> > I did some debugging by enabling both serial and efi earlyprintk, below is
> > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > no free slot, but I'm still not sure if the debug info is right or not.
> 
> Thanks Dave, your callstack seems to make sense.
> 
> Can you also enable early_ioremap_debug so that we can figure out where
> all the FIXMAP slots are going?
> 
> --
> Matt Fleming, Intel Open Source Technology Center
