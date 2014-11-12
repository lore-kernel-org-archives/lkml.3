Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaKLAWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:22:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:29490 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaKLAWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:22:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="635376676"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Oleg Nesterov" <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBag
Date: Wed, 12 Nov 2014 00:22:04 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
 <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
In-Reply-To: <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC0MEq3008784

Andy said:
> Yeah.  But if you haven't cleared MCIP, you go boom, which is the same
> with pretty much any approach.

The current code has an ugly hole at the moment.  End of do_machine_check()
clears MCG_STATUS.  At that point we are still running on the magic stack for
machine check exceptions ... if we take a machine check in the small window
from there until we get off this stack (iret) ... then we will enter the handler
back on the same stack that we haven't finished using yet. Bad things ensue.

Andy's RFC patch removes this window.  We are already off on the normal stack
when we clear MCG_STATUS.MCIP ... so we enter the new machine check on the
magic stack, but then (I hope) transition to the kernel stack (pushing a new frame
below the other one).

Boris said:
> This is the key: if I enable irqs and the process gets scheduled on
> another CPU, I lose. So I have to be able to say: before you run this
> task on any CPU, kill it.

I don't think it matters if sleep and schedule this task on another cpu. When
we run there we'll keep running the memory_failure() code that we were
in the middle of when we slept.  The task can move around - we just need to
make sure it doesn't *return to the user-mode instruction* that hit the machine
check before we find the pte and zero it and mark the page as POISON.

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
