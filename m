Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180AbaGYUVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:21:55 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:50433 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907AbaGYUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140725201507.GA23410@redhat.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
 <20140725201507.GA23410@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Jul 2014 13:21:31 -0700
Message-ID: <CALCETrULRhQCSPsgepntRuCbvx-guEKzpBUT4EoQi2-VU0P8bQ@mail.gmail.com>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 1:15 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:
>
>  > There is recent interest in having a way to turn generally-available
>  > kernel features off.  Maybe we should add a good one so we can stop
>  > bikeshedding and avoid proliferating dumb interfaces.
>  >
>  > Things that might want to be turn-off-able include:
>  >  - getrandom with GRND_RANDOM [from the getrandom threads]
>  >  - Any lookup of a non-self pid [from the capsicum thread]
>  >  - Any lookup of a pid outside the caller thread group [capsicum]
>  >  - Various architectural things (personal wishlist), e.g.:
>  >     - RDTSC and userspace HPET access
>  >     - CPUID?
>  >     - 32-bit GDT code segments [huge attack surface]
>  >     - 64-bit GDT code segments [probably pointless]
>
> I'm not sure there's value in disabling cpuid dev interface,
> when the instruction is unprivileged.

I meant the CPUID instruction.  Some CPUs have a setting that turns
off the CPUID instruction for user code.  In principle, all VMs can do
this, too, if the hypervisor would be kind enough to help out.

I only mentioned the x86 stuff here to make the point that there are
quite a few possibilities along these lines.  There's actually already
a way to turn off RDTSC, but it's not currently very useful because it
doesn't do the right thing for the vDSO.  That could be fixed, but
there's certainly no reason to make any of the other stuff here wait
for that.

>
>  > I would propose a new syscall for this:
>  >
>  > long restrict_userspace(int mode, int type, int value, int flags);
>
> do the restrictions happen system-wide like in say SELinux,
> or only within the calling process, like seccomp ?
>

The calling process and children, like seccomp.

--Andy
