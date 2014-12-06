Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaLFWig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:38:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:39146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaLFWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:38:35 -0500
Date: Sat, 6 Dec 2014 23:38:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFwhdbcvvimPx0F7Q-BYDUSYDUODo5k5xeJuRCAtGB2dwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412062318570.16275@nanos>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com> <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com> <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141205171501.GA1320@redhat.com> <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <20141205184808.GA2753@redhat.com> <CA+55aFwhdbcvvimPx0F7Q-BYDUSYDUODo5k5xeJuRCAtGB2dwg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, Linus Torvalds wrote:
> On Fri, Dec 5, 2014 at 10:48 AM, Dave Jones <davej@redhat.com> wrote:
> >
> > In the meantime, I rebooted into the same kernel, and ran trinity
> > solely doing the lsetxattr syscalls.
> 
> Any particular reason for the lsetxattr guess? Just the last call
> chain? I don't recognize it from the other traces, but maybe I just
> didn't notice.
> 
> >   The load was a bit lower, so I
> > cranked up the number of child processes to 512, and then this
> > happened..
> 
> Ugh. "dump_trace()" being broken and looping forever? I don't actually

Looking at the callchain: up to the point where dump_stack() is called
everything is preemtible context. So dump_stack() would need to loop
for a few seconds to trigger the NMI watchdog.

> believe it, because this isn't even on the exception stack (well, the
> NMI dumper is, but that one worked fine - this is the "nested" dumping
> of just the allocation call chain)

I doubt that dump_trace() itself is broken, but the call site might
have handed in something which causes memory corruption. And looking
at set_track() and the completely undocumented way how it retrieves
the storage for the trace entries via get_track() makes my brain melt.

Thanks,

	tglx







