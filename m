Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaAVIvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:51:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:14907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaAVIvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:51:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="462725222"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: David Rientjes <rientjes@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/4] Intel MPX support
Thread-Topic: [PATCH v2 0/4] Intel MPX support
Thread-Index: AQHPF0ggU7e3U2g9DU6sJV0IAL1uEpqQbftQ
Date: Wed, 22 Jan 2014 08:51:14 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014EBF6B@SHSMSX102.ccr.corp.intel.com>
References: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
 <alpine.DEB.2.02.1401212354010.24910@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401212354010.24910@chino.kir.corp.google.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0M8pRWU015411

> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Wednesday, January 22, 2014 4:01 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 0/4] Intel MPX support
> 
> On Wed, 22 Jan 2014, Qiaowei Ren wrote:
> 
> > Changes since v1:
> >   * check to see if #BR occurred in userspace or kernel space.
> >   * use generic structure and macro as much as possible when
> >     decode mpx instructions.
> >
> > Qiaowei Ren (4):
> >   x86, mpx: add documentation on Intel MPX
> >   x86, mpx: hook #BR exception handler to allocate bound tables
> >   x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
> >   x86, mpx: extend siginfo structure to include bound violation
> >     information
> >
> >  Documentation/x86/intel_mpx.txt    |   76 +++++++
> >  arch/x86/Kconfig                   |    4 +
> >  arch/x86/include/asm/mpx.h         |   63 ++++++
> >  arch/x86/include/asm/processor.h   |   16 ++
> >  arch/x86/kernel/Makefile           |    1 +
> >  arch/x86/kernel/mpx.c              |  417
> ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/traps.c            |   61 +++++-
> >  include/uapi/asm-generic/siginfo.h |    9 +-
> >  include/uapi/linux/prctl.h         |    6 +
> >  kernel/signal.c                    |    4 +
> >  kernel/sys.c                       |   12 +
> >  11 files changed, 667 insertions(+), 2 deletions(-)  create mode
> > 100644 Documentation/x86/intel_mpx.txt  create mode 100644
> > arch/x86/include/asm/mpx.h  create mode 100644 arch/x86/kernel/mpx.c
> >
> 
> There's compiler warnings spread amongst the various patches with x86_64
> defconfig:
> 
> arch/x86/kernel/mpx.c: In function â€˜do_mpx_boundsâ€™:
> arch/x86/kernel/mpx.c:415:2: warning: format â€˜%lxâ€™ expects argument of
> type â€˜long unsigned intâ€™, but argument 3 has type â€˜void *â€™ [-Wformat]
> arch/x86/kernel/mpx.c:415:2: warning: format â€˜%lxâ€™ expects argument of
> type â€˜long unsigned intâ€™, but argument 4 has type â€˜void *â€™ [-Wformat]
> arch/x86/kernel/mpx.c: In function â€˜do_mpx_bt_faultâ€™:
> arch/x86/kernel/mpx.c:373:5: warning: â€˜old_valâ€™ may be used uninitialized in
> this function [-Wuninitialized]
> arch/x86/kernel/mpx.c:360:25: note: â€˜old_valâ€™ was declared here
> 
I will fix these warnings.
old_val will be set by user_atomic_cmpxchg_inatomic().

> and I had to resolve the second patch manually because of "x86/traps:
> Clean up error exception handler definitions" in the x86 tree.
> 
There is a conflict with latest kernel. I just fixed it and built successfully.

> With 32-bit, we get casting warnings:
> 
> arch/x86/kernel/mpx.c: In function â€˜do_mpx_boundsâ€™:
> arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of different
> size [-Wint-to-pointer-cast]
> arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of different
> size [-Wint-to-pointer-cast]
> 
> and I'm pretty sure you want this to be available for such a config.
> 
> There's also whitespace in the fourth patch.
Thanks much for your feedback.

Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
