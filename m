Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbaKAUck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:32:40 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:62107 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbaKAUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411012058030.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <266afcba1d1f91ea5501e4e16e94bbbc1a9339b6.1414190806.git.luto@amacapital.net>
 <alpine.DEB.2.11.1411012058030.5308@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Nov 2014 13:32:16 -0700
Message-ID: <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] perf: Add pmu callbacks to track event mapping and unmapping
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2014 at 12:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 24 Oct 2014, Andy Lutomirski wrote:
>
> I'm probably missing something.
>
> Why is this tied to the mmap? If I just open a counter then I should
> be able to read the counter from user space w/o mmapping something in
> the first place.

You can read it with read(2), which this patch shouldn't affect.  If
you want to read it with rdpmc, then you need to know what rdpmc index
to use, and the API for that is to mmap the event, check the
userpage's cap_user_rdpmc, and then rdpmc on ->idx - 1 (assuming that
->idx != 0).  You can't safely make any assumptions about which rdpmc
index it will be without explicitly checking, because perf reserves
the right to change the index whenever it wants.

There's plenty of room to tighten up the restrictions further, but
this is, I think, a decent first step, and it solves the problem of
information leaking into seccomp sandboxes.

Does that help?  I tested this with the only reasonable test case I
could find, which was Andi Kleen's "self" program.  It still worked.

--Andy
