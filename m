Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaH2LUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:20:15 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43478 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaH2LUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:20:13 -0400
Date: Fri, 29 Aug 2014 12:20:10 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140829112009.GD11445@sucs.org>
References: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140829094945.GA5122@mwanda>
 <EE124450C0AAF944A40DD71E61F878C997956C@SINEX14MBXC418.southpacific.corp.microsoft.com>
 <20140829102411.GE5071@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829102411.GE5071@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:24:11PM +0300, Dan Carpenter wrote:
> On Fri, Aug 29, 2014 at 10:16:32AM +0000, Dexuan Cui wrote:
> > 
> > Section 4.11.3 of Hypervisor Top Level Functional Specification(available at
> > http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/02/17/updated-hypervisor-top-level-functional-specification.aspx)
> > says HV_STATUS_INVALID_ALIGNMENT can also be returned for a hypercall if
> > "the specified input or output parameter lists spans pages."
> > 
> > My understanding is: the input's memory range shouldn't cross a page
> > boundary.
> 
> Ah.  That makes sense then.  Thanks.

This got me too.

Because this particular return code is overloaded with multiple meanings
that can't necessarily be deduced from its name perhaps this
documentation patch would be helpful:

diff --git a/arch/x86/include/uapi/asm/hyperv.h b/arch/x86/include/uapi/asm/hyperv.h
index 462efe7..04894d5 100644
--- a/arch/x86/include/uapi/asm/hyperv.h
+++ b/arch/x86/include/uapi/asm/hyperv.h
@@ -213,6 +213,12 @@
 #define HV_STATUS_SUCCESS                      0
 #define HV_STATUS_INVALID_HYPERCALL_CODE       2
 #define HV_STATUS_INVALID_HYPERCALL_INPUT      3
+/*
+ * HV_STATUS_INVALID_ALIGNMENT indicates one of the following:
+ *   The input or output pointer is not aligned to 8 bytes.
+ *   The input or output lists span more than one page.
+ *   The input or output pointer is out of bounds.
+ */
 #define HV_STATUS_INVALID_ALIGNMENT            4
 #define HV_STATUS_INSUFFICIENT_BUFFERS         19

Dexuan: Does this mean that if input/output pointer is well aligned and
the (payload start) is in the same page as (payload start + payload
size) all will be well? If so it won't matter what the length of payload
size is right?

-- 
Sitsofe | http://sucs.org/~sits/
