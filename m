Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaG2ReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaG2ReG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:34:06 -0400
Date: Tue, 29 Jul 2014 19:31:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 6/8] x86: Split syscall_trace_enter into two phases
Message-ID: <20140729173136.GA2808@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <CALCETrWUFo_zXcAZja-vdL4_MgJDd=1ed5Vt54eyUuim930xAw@mail.gmail.com> <20140729165416.GA967@redhat.com> <CALCETrWBU-=zqLTCP7B1feZ9J-e4u-Boic+e1EEn1rL-ijeEKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWBU-=zqLTCP7B1feZ9J-e4u-Boic+e1EEn1rL-ijeEKg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Andy Lutomirski wrote:
>
> On Tue, Jul 29, 2014 at 9:54 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes, just to trigger the slow path, I guess.
> >
> >> I'll update the code to call user_exit iff TIF_NOHZ is
> >> set.
> >
> > Or perhaps it would be better to not add another user of this (strange) flag
> > and just call user_exit() unconditionally(). But, yes, you need to use
> > from "work = flags & (_TIF_WORK_SYSCALL_ENTRY & ~TIF_NOHZ)" then.\
>
> user_exit looks slow enough to me that a branch to try to avoid it may
> be worthwhile.  I bet that explicitly checking the flag is
> actually both faster and clearer.

I don't think so (unless I am confused again), note that user_exit() uses
jump label. But this doesn't matter. I meant that we should avoid TIF_NOHZ
if possible because I think it should die somehow (currently I do not know
how ;). And because it is ugly to check the same condition twice:

	if (work & TIF_NOHZ) {
		// user_exit()
		if (context_tracking_is_enabled())
			context_tracking_user_exit();
	}

TIF_NOHZ is set if and only if context_tracking_is_enabled() is true.
So I think that

	work = current_thread_info()->flags & (_TIF_WORK_SYSCALL_ENTRY & ~TIF_NOHZ);

	user_exit();

looks a bit better. But I won't argue.

> That's what I did for v4.

I am going to read it today. Not that I think I can help or find something
wrong.

Oleg.

