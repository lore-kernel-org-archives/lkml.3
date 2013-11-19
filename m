Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3KSEeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:34:20 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:28111 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3KSEeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:34:03 -0500
From: "Long, Wai Man" <waiman.long@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        "Andi Kleen" <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: RE: [PATCH v6 3/5] qrwlock: Enable fair queue read/write lock
Thread-Topic: [PATCH v6 3/5] qrwlock: Enable fair queue read/write lock
Thread-Index: AQHO37ZsRmhWO/O1R0CDPqIo3jMJ9JorU94AgACr++A=
Date: Tue, 19 Nov 2013 04:33:09 +0000
Message-ID: <401F72D6D1DFE3499766D25AA4EED18A35440103@G6W2503.americas.hpqcorp.net>
References: <1384267735-43213-1-git-send-email-Waiman.Long@hp.com>
	<1384267735-43213-5-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXu7eC1WGfZ=_JQbLLJHM5HYRkJPjm3jBDC51SL66Ecw@mail.gmail.com>
In-Reply-To: <CA+55aFxXu7eC1WGfZ=_JQbLLJHM5HYRkJPjm3jBDC51SL66Ecw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.201.12.21]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAJ4YZ0P032639

Sorry for the late reply.

The presence of the unfair option as default is largely due to fixing the recursive read lock in interrupt handler problem. You are right that it is no longer a valid reason now. 

An unfair lock may have a better performance characteristics, especially for a highly contended lock. Other than that, I have no other reason to keep an unfair option. I don't mind taking out the unfair option and make the fair qrwlock the default. It does simplify the code. I will send out an updated patchset with only the fair qrwlock.

Thank for suggestion.
-Longman

-----Original Message-----
From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus Torvalds
Sent: Monday, November 18, 2013 1:12 PM
To: Long, Wai Man
Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; Arnd Bergmann; linux-arch@vger.kernel.org; the arch/x86 maintainers; Linux Kernel Mailing List; Peter Zijlstra; Steven Rostedt; Andrew Morton; Michel Lespinasse; Andi Kleen; Rik van Riel; Paul E. McKenney; Raghavendra K T; George Spelvin; Tim Chen; Chandramouleeswaran, Aswin; Norton, Scott J
Subject: Re: [PATCH v6 3/5] qrwlock: Enable fair queue read/write lock

On Tue, Nov 12, 2013 at 6:48 AM, Waiman Long <Waiman.Long@hp.com> wrote:
> By default, queue rwlock is fair among writers and gives preference to 
> readers allowing them to steal lock even if a writer is waiting. 
> However, there is a desire to have a fair variant of rwlock that is 
> more deterministic. To enable this [..]

Is there really any point in having the option for unfair at all?

>From your timings, it looks like the unfair locks are more expensive for the writer side, but since pretty much the whole point of rwlocks is when readers are the common case, I don't think we care.

And I'm not at all convinced we want the complexity of two different kinds of rwlocks with different semantics and extra code for said semantics..

Your *original* fair rwlocks were unusable, since they didn't allow for the irq semantics that most users need, but afaik your current version always makes an irq/bh-context reader work even when the lock is otherwise trying to be fair, so this whole dual behavior seems to be largely pointless.

No?

                        Linus
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
