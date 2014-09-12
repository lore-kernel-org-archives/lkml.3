Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaILUf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:35:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:52465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaILUf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:35:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="scan'208";a="572477162"
Message-ID: <54135900.6010606@intel.com>
Date: Fri, 12 Sep 2014 13:35:12 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos> <alpine.DEB.2.10.1409121120440.4178@nanos> <5413050A.1090307@intel.com> <alpine.DEB.2.10.1409121812550.4178@nanos> <alpine.DEB.2.10.1409122038590.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409122038590.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 11:42 AM, Thomas Gleixner wrote:
> On Fri, 12 Sep 2014, Thomas Gleixner wrote:
>> On Fri, 12 Sep 2014, Dave Hansen wrote:
>> The proper solution to this problem is:
>>
>>     do_bounds()
>> 	bd_addr = get_bd_addr_from_xsave();
>> 	bd_entry = bndstatus & ADDR_MASK:
> 
> Just for clarification. You CANNOT avoid the xsave here because it's
> the only way to access BNDSTATUS according to the manual.
> 
> "The BNDCFGU and BNDSTATUS registers are accessible only with
>  XSAVE/XRSTOR family of instructions"
> 
> So there is no point to cache BNDCFGU as you get it anyway when you
> need to retrieve the invalid BD entry.

Agreed.  It serves no purpose during a bounds fault.

However, it does keep you from having to do an xsave during the bounds
table free operations, like at unmap() time.  That is actually a much
more critical path than bounds faults.

