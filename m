Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKQW1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:27:18 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:34752 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaKQW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic> <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic> <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic> <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Nov 2014 14:26:54 -0800
Message-ID: <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:55 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>> However, I'd like to be very sure this thing doesn't introduce any
>>> regressions to the MCA code. So even if Tony's testing passes, I'd like
>>> to be very conservative here and stress it more than usual. Because once
>>> this thing hits upstream and stuff starts breaking, it'll be a serious
>>> PITA reverting it.
>
> The test I left running on Friday was just running the stack-switch asm
> patch, without any mce.c changes.  It died at 16000 iterations with the
> mce synchronization issue.

I still wonder whether the timeout code is the real culprit.  My patch
will slow down entry into do_machine_check by tens of cycles, several
cachelines, and possibly a couple of TLB misses.  Given that the
timing seemed marginal to me, it's possible (albeit not that likely)
that it pushed the time needed for synchronization into the range of
unreliability.

Any chance you can retry it at some point with that USEC_PER_SEC thing
changed to NSEC_PER_SEC and SPINUNIT set to something closer to 10
than 100?

--Andy

>
> This morning I started a new test with all the mce changes (no TIF_MCE_NOTIFY,
> just process the recovery in the tail of do_machine_check().
>
> It just passed the 18000 point, and it still going.  In addition I've been throwing
> the odd "make -j144" kernel build at the machine so we check out the non-idle
> paths too.
>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
