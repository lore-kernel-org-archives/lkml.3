Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaLNTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:50:26 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:58774 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLNTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141214180409.GB12622@lerouge>
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213073634.GD32572@gmail.com>
	<20141214180409.GB12622@lerouge>
Date: Sun, 14 Dec 2014 11:50:20 -0800
X-Google-Sender-Auth: 2gRjzKe341Hv_uN3eMN3HPlE5W4
Message-ID: <CA+55aFzOHwkMSEMN7v6THmx1U3YPPTy9B=zeLx96Rt2_Er=yBA@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix lost reschedule in __cond_resched()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:04 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>
> Such as:

So I like your patch, but quite frankly, can we go one step further?

Look at the callers of __schedule().

EVERY SINGLE ONE now has that loop around it that goes along the lines of

   do {
      .. disable preemption somehow ..
      __schedule();
      ...enable preemption without scheduling ..
   } while (need_resced());

except for one - the regular "schedule()" function.

Furthermore, look inside __schedule() itself: it has the same loop,
except with a count of one.

So I would suggest going the extra mile, and
 - remove the loop from __schedule() itself
 - add the same loop as everywhere else to "schedule()"

IOW, just make this "you have to loop and disable preemption" thing be
a rule that __schedule() can depend on.

                 Linus
