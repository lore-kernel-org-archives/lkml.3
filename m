Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaLQAAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 19:00:50 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40359 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaLQAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 19:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141216230246.GA30905@twins.programming.kicks-ass.net>
References: <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
	<alpine.DEB.2.11.1411212049220.6439@nanos>
	<CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
	<alpine.DEB.2.11.1411212110320.6439@nanos>
	<CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
	<alpine.DEB.2.11.1411212207150.6439@nanos>
	<CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
	<20141216192803.GC3337@twins.programming.kicks-ass.net>
	<CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
	<20141216211921.GA2395@suse.de>
	<20141216230246.GA30905@twins.programming.kicks-ass.net>
Date: Tue, 16 Dec 2014 16:00:48 -0800
X-Google-Sender-Auth: P2hvY4IHpynyHQ4mrDVxGuYCEBE
Message-ID: <CA+55aFxyx_wcsgYJC2GXcjEvMsTg=K=uy6A=xDJdWdvZsE1VHQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 3:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK, should we just stick it in the x86 tree and see if anything
> explodes? ;-)

Gaah, I got confused about the patches.

And something did explode, it showed some Xen nasties. Xen has that
odd "we don't share PMD entries between MM's" thing going on, which
means that the vmalloc fault thing does actually have to occasionally
walk two levels rather than just copy the top level. I'm still not
sure why Xen doesn't share PMD's, since threads that shame the MM
clearly can share PMD's within Xen, but I gave up on it.

That said, making x86-64 use "read_cr3()" instead of
"current->active_mm" would at least make things a bit safer wrt NMI's
during the task switch, of course.  So *some* 32/64-bit consolidation
should be done, but my patch went a bit too far for Xen.

                      Linus
