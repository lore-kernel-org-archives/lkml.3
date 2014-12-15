Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaLOOAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:00:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53512 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaLOOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:00:04 -0500
Date: Mon, 15 Dec 2014 15:00:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?Q?D=C3=A2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141215140000.GB6590@pd.tnic>
References: <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 09:47:26PM -0800, Linus Torvalds wrote:
> and "save_xstate_sig+0x81" shows up on all stacks, although only on
> CPU1 does it show up as a "guaranteed" part of the stack chain (ie it
> matches frame pointer data too). CPU1 also has that __clear_user show
> up (which is called from save_xstate_sig), but not other CPU's.  CPU2
> and CPU3 have "save_xstate_sig+0x98" in addition to that +0x81 thing.
> 
> My guess is that "save_xstate_sig+0x81" is the instruction after the
> __clear_user call, and that CPU1 took the fault in __clear_user(),
> while CPU2 and CPU3 took the fault at "save_xstate_sig+0x98" instead,
> which I'd guess is the
> 
>         xsave64 (%rdi)

Err, maybe a wild guess, but could XSAVE be encountering some problems,
like store ordering violations or somesuch?

Quick search shows

"AZ72. Store Ordering Violation When Using XSAVE"

here http://download.intel.com/design/mobile/specupdt/320121.pdf which
talks about SSE context stores happening out of order. Now, there are a
lot of IFs like does Dave's machine even have the erratum and even if,
would that erratum cause some sort of a livelock leading to the kernel
lockups and so on and so on...

It might be worth to rule out though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
