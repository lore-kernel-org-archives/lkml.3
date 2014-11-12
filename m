Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaKLRSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:18:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:58460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaKLRSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:18:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="606720664"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEIAAoQn1gADe14CAAAmMgP//hGUA
Date: Wed, 12 Nov 2014 17:17:55 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3292AE0D@ORSMSX114.amr.corp.intel.com>
References: <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic>
In-Reply-To: <20141112162225.GF16807@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sACHIb2O018673

> Not that easy for testing the #MC path - there we have to inject real
> MCEs and then noodle through the memory_failure() code. I'd be very much
> interested to see what would happen if two MCEs happen back-to-back with
> your change, the second one being raised when we're on the kernel stack
> and in memory_failure()...

If the second one hits before we clear MCG_STATUS, then the processor resets.

If the second one is caused by the recovery thread somewhere in memory_failure(),
then Andy won't switch stacks - but we will declare this a fatal error an panic (we have
no recovery from machine checks in the kernel).

Otherwise the memory_failure() thread is the innocent bystander. If the affected thread
decides to do recovery, then the first thread will be allowed to return and continue.

I might worry a bit if the second error is another thread hitting the *same* page which
hasn't finished processing yet ... then the second will chase along behind the first trying
to fix the same problem.  I *think* the first will complete and the second will just end
up here:

	if (TestSetPageHWPoison(p)) {
		printk(KERN_ERR "MCE %#lx: already hardware poisoned\n", pfn);
		return 0;
	}

which is really early in memory_failure().

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
