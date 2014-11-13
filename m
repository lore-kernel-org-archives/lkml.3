Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbaKMSqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:46:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:20170 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933512AbaKMSqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:46:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,379,1413270000"; 
   d="scan'208";a="607410773"
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
Thread-Index: AQHP/s7+MsolZCiViEiCPzqCVeTRAJxdoOwAgACR1oD//3yvMIAAtdCAgAB2NOA=
Date: Thu, 13 Nov 2014 18:43:24 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
In-Reply-To: <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sADIkjsL026386

> printk seems to work just fine in do_machine_check.  Any chance you
> can instrument, for each cpu, all entries to do_machine_check, all
> calls to do_machine_check, all returns, and everything that tries to
> do memory_failure?

I first added a printk() just for the cpu that calls do_machine_check()

   printk("MCE: regs = %p\n", regs);

to see if something went wonky when jumping to the kernel stack.
But that printed the same value every time (same process is consuming
and recovering from errors).  Maybe this took longer to hit the problem
case - I ran to 1500ish errors instead of just 400 in the previous two tests.
But not sure if that is a significant change.

Then I added printk() for every entry/return on all cpus.  This just locked
up on the third injection.  Serial console looked to have stopped printing
after the first - so I put in bigger delays into my test program between injection
and consumption, and before looping around for the next cycle to give
time for all the messages (4-socket HSW-EX  ... there are a lot of cpus
printing messages). But now it is taking a lot longer to get through
injection/consumption iterations. At 226 now and counting.

> Also, shouldn't there be a local_irq_enable before memory_failure and
> a local_irq_disable after it?  It wouldn't surprise me if you've
> deadlocked somewhere.  Lockdep could also have something interesting
> to say.
Added enable/disable.

> should still be deliverable.  Is it possible that we really need an
> IRET to unmask NMIs?  This seems unlikely.)

If that were the problem, wouldn't we fail on iteration 2, instead of
400+ ?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
