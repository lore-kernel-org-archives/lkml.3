Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaKMAbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:31:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:2731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaKMAbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:31:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415729083"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Andi Kleen" <andi@firstfloor.org>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/s7+MsolZCiViEiCPzqCVeTRAJxdoOwAgACR1oD//3yvMA==
Date: Thu, 13 Nov 2014 00:31:30 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
In-Reply-To: <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD0VcUm020509

> v2's not going to make a difference unless you're using uprobes at the
> same time.

Not (knowingly) using uprobes. System is installed with a RHEL7 userspace ... but is essentially
idle except for my test program.

> In the interest of my sanity, can you add something like
> BUG_ON(!user_mode_vm(regs)) or the mce_panic equivalent before calling
> memory_failure?

I don't think that can possibly trip - we can only end up with a recoverable error from
a user mode access.  But I'll see about adding it anyway

> What happens if there's a shared bank but the actual offender has a
> higher order than the cpu that finds the error?

This test case injects a memory error which is logged in bank1. This bank is shared by the
two hyperthreads that are on the same core.  The mce_severity() function distinguishes
which is the active thread and which the innocent bystander by looking at MCG_STATUS.
In the active thread MCG_STATUS.EIPV is 1, in the bystander it is 0. The returned severity
is MCE_AR_SEVERITY for the thread that hit the error, MCE_KEEP_SEVERITY for the bystander.
So it doesn't matter which thread has the lower order and sees it first.

> Is this something I can try under KVM?

I don't know if KVM has a way to simulate a machine check event.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
