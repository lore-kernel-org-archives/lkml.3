Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaKKWBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:01:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:54373 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaKKWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:01:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="630391773"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Oleg Nesterov" <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOA//96WVA=
Date: Tue, 11 Nov 2014 22:00:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32929962@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
In-Reply-To: <20141111213628.GP31490@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sABM1AlF008142

So here is the flow:

1) A machine check happens - it is (currently) broadcast to all logical cpus on all sockets

2) First cpu to execute "order = atomic_inc_return(&mce_callin);" in mce_start() gets to be the "monarch" and directs things during the handler.

3) Every cpu gets to scan all the machine check banks to see what happened. If the error was a fatal one we are going to panic - this isn't the interesting case.

4) There are two kinds of recoverable error
4a) Ones not in execution context (SRAO = Software Recoverable Action Optional) -  these also aren't very interesting - save the address in a NMI safe ring buffer to process later
4b) In execution context (SRAR = Software Recoverable Action Required) - this is where we need to do some real work to convert from the physical address logged to the list of affected processes.

Now when we get to step 4b - we need to let all the other processors return from the machine check handler (they may have been interrupted in kernel context and could hold locks that we need).

We also need to clear the MSR MCG_STATUS (on each logical cpu) to indicate we are done with this machine check.


Andy - with your RFC patch - can we just make the bottom end of do_machine_check() look like this:

	/* collected everything we need from banks - re-enable machine check on all cpus */
	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);

	if (we are *not* the thread with the SRAR error)
		return;

	/* do all the things that were previously in mce_notify_process() here */
}

and if we do this - what happens if we get another machine check while we are in the "do all the things" bit?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
