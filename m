Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaKQXQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:16:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:18401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaKQXQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:16:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,405,1413270000"; 
   d="scan'208";a="609415242"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Topic: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Thread-Index: AQHP/fIL6Pup6CZwB0y4k4v+dv83WpxceVOAgAAKAgCAAAXbAIAAAfAAgAAIKwCAAAM7AP//iBaggACOCID//33YEIAAoQn1gADe14CAAAmMgIABruEAgAFGphCABQ+BAIAAEq4AgAAB1ACAAACVgP//kExAABLiaAAAD6th0A==
Date: Mon, 17 Nov 2014 23:16:47 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3293F64E@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic>
 <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic>
 <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
 <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
In-Reply-To: <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAHNGuZG016686

> I still wonder whether the timeout code is the real culprit.  My patch
> will slow down entry into do_machine_check by tens of cycles, several
> cachelines, and possibly a couple of TLB misses.  Given that the
> timing seemed marginal to me, it's possible (albeit not that likely)
> that it pushed the time needed for synchronization into the range of
> unreliability.

I think we have very conservative timeouts.  Here are the significant bits from mce

First SPINUNIT ... how many nanoseconds to spin "ndelay(SPINUNIT)"  before pounding on an atomic op to see if we are done:
#define SPINUNIT 100    /* 100ns */

Initialization of our timeout - comment above this claims we are aiming for "one second"

	cfg->monarch_timeout = USEC_PER_SEC;

Inside mce_start() - set up our timeout. Math says this will be 1e9

	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;

Now the actual loop:
        while (atomic_read(&mce_callin) != cpus) {
                if (mce_timed_out(&timeout)) {
                        atomic_set(&global_nwo, 0);
                        return -1;
                }
                ndelay(SPINUNIT);
        }

And the inside of mce_timed_out() ... we decrement our 1e9 by 100 for each call:

        if ((s64)*t < SPINUNIT) {
                if (mca_cfg.tolerant <= 1)
                        mce_panic("Timeout synchronizing machine check over CPUs",
                                  NULL, NULL);
                cpu_missing = 1;
                return 1;
        }
        *t -= SPINUNIT;

Not sure what the worst case is for waiting for other processors to show up. Perhaps it is
when the other cpu is in some deep C-state and we have to wait for it to power the core
back on and resync clock.  Maybe it is when a cpu has just started a "wbinvd" instruction
with a cache entirely full of dirty lines that belong on some other processor so have to
be written back across QPI (may when QPI links are congested with 10gbit network traffic?

But a full second seems like a lot ... you adding a handful of cache and TLB misses shouldn't
push us over the edge.

-Tony

   
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
