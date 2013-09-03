Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481Ab3ICXUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:20:18 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:33409 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3ICXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:20:15 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130903231554.GA15720@redhat.com>
References: <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+icZUXi-YHK23sKnVQbfi4K2FOVZiROQ76H5Qw2NxTJT2uzDQ@mail.gmail.com>
	<20130903225528.GA14909@redhat.com>
	<CA+icZUVpb9yrhnaaUf7=0wd4kpWuBW0VpWiK=BfVZoBiRGuJ2Q@mail.gmail.com>
	<20130903231554.GA15720@redhat.com>
Date: Wed, 4 Sep 2013 01:20:14 +0200
Message-ID: <CA+icZUVnrBo3NY95-VRY+_ww-5_Z296zFp5ezqxeRobY5FnwiA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Jones <davej@redhat.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 1:15 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Sep 04, 2013 at 01:05:38AM +0200, Sedat Dilek wrote:
>  > On Wed, Sep 4, 2013 at 12:55 AM, Dave Jones <davej@redhat.com> wrote:
>  > > On Wed, Sep 04, 2013 at 12:37:25AM +0200, Sedat Dilek wrote:
>  > >
>  > >  > > You're spending more time on the task stats than on the actual lookup.
>  > >  > > Maybe you should turn off CONFIG_TASKSTATS..But why that whole
>  > >  > > irq_return thing? Odd.
>  > >  > >
>  > >  >
>  > >  > [ init/Kconfig ]
>  > >  > ...
>  > >  > config TASKSTATS
>  > >  >         bool "Export task/process statistics through netlink"
>  > >  >         depends on NET <--- Difficult to disable it?!
>  > >
>  > > More likely you're getting bitten by the fact that CONFIG_KVM has
>  > > a 'select TASKSTATS'
>  > >
>  >
>  > With CONFIG_KVM=n ...
>  >
>  > $ egrep 'CONFIG_NET=|CONFIG_KVM=|CONFIG_TASKSTATS' .config
>  > CONFIG_TASKSTATS=y
>  > CONFIG_NET=y
>
> Weird.
>
> sed -i '/TASKSTATS/d' .config
> sed -i '/KVM/d' .config
> make oldconfig
> ...
> egrep 'CONFIG_NET=|CONFIG_KVM=|CONFIG_TASKSTATS' .config
> # CONFIG_TASKSTATS is not set
> CONFIG_NET=y
>
>
> The NET dependancy shouldn't matter at all.
> I don't see any other 'select TASKSTATS' in the tree.
>

Ah, cool.

With CONFIG_KVM=n and CONFIG_TASKSTATS=n plus...

$ yes "" | make oldconfig && make silentoldconfig </dev/null

...I get now:

$ egrep 'CONFIG_NET=|CONFIG_KVM=|CONFIG_TASKSTATS' .config
# CONFIG_TASKSTATS is not set
CONFIG_NET=y

Thanks, Dave!

- Sedat -
