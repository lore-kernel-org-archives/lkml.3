Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBXAtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:49:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:12272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaBXAs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:48:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,531,1389772800"; 
   d="scan'208";a="480438438"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "rja@sgi.com" <rja@sgi.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLnhtHHqrgNtJQkeFFZTg6j/LB5q+DjEAgAAGvYCAAAGPAIAAA6AAgAAAfgCAAAfaAIAAAu6AgAAHs4CAAAWJgIAABTyAgAAGxACAAA3MgIAAprZAgABpXACABDgaoA==
Date: Mon, 24 Feb 2014 00:48:42 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024B2897@SHSMSX101.ccr.corp.intel.com>
References: <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
	 <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
	 <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230>
	 <20140220235904.GZ17949@sgi.com>
	 <1AE640813FDE7649BE1B193DEA596E88024B228C@SHSMSX101.ccr.corp.intel.com>
 <1392999172.20109.47.camel@x230>
In-Reply-To: <1392999172.20109.47.camel@x230>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1O0nBjn010646

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Matthew Garrett
> Sent: Saturday, February 22, 2014 12:13 AM
> 
> On Fri, 2014-02-21 at 02:17 +0000, Zheng, Lv wrote:
> 
> > In fact there is a workaround solution I've posted here:
> > https://patchwork.kernel.org/patch/2831851/
> > The updated version of this patch can be found at:
> > https://bugzilla.kernel.org/attachment.cgi?id=112611
> > It is the acpi-ipmi13.patch file.
> 
> I don't think that solves the underlying problem? We're still left with
> no guarantee of ordering between ACPI IPMI operation region support
> being available and the loading of a driver that may rely on it.

Yes. As it is a bit far beyond the bug report, I didn't work on it.
But actually, I have solution to achieve this.

> > I think there should be relationship between ACPI region and Linux kernel modules.
> > In fact on the well-known operating system, _REG is always invoked at the end of the IRP_PNP_START_DEVICE completions.
> > But we may still be able to return -EPROBE_DEFER in the power meter driver when it detects failures caused by the readiness state
> of the region handlers.
> 
> We don't have a guarantee that it'll happen at probe time. The
> capabilities list may be static, and so we'll get our first failure on
> an attempted userspace access instead.

This is the issue related to the IPMI operation region, and it can be solved by a "request_module()" call.
The -EPROBE_DEFER I mentioned is about the quality of  acpi power meter driver itself.

> It may be that Corey's suggestion satisfies the concerns Russ raised.
> Building IPMI in but only probing by default on systems that declare a
> BMC in ACPI or DMI should avoid boot-time delays while still ensuring
> that the functionality is available on systems where there's a real
> chance that the firmware expects the OS to provide support.

If you take a look at this patch (https://patchwork.kernel.org/patch/2831851/), you'll see it is possible to add request_module() in acpi_region_default_handler().
The callback is invoked when the first IPMI region access happens and it is in the process context without any locking.
I'd rather to embed acpi_ipmi into ipmi_si module with this fix:
https://bugzilla.kernel.org/attachment.cgi?id=112611 (acpi-ipmi14.patch).
After that, a request_module() invocation of ipmi_si in acpi_region_default_handler() can solve what you are worrying about.

What's your opinion?

Thanks and best regards
-Lv

> --
> Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
