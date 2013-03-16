Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3CPVyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:54:44 -0400
Received: from two.firstfloor.org ([193.170.194.197]:49900 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3CPVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:54:41 -0400
Date: Sat, 16 Mar 2013 22:54:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 0/2] finx argv_split() vs sysctl race
Message-ID: <20130316215440.GV11268@two.firstfloor.org>
References: <20130312203514.GA23488@redhat.com>
 <20130313174641.GA28083@redhat.com>
 <20130313174705.GB28083@redhat.com>
 <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
 <20130315163916.GA31995@redhat.com>
 <20130316202327.GA18613@redhat.com>
 <20130316203221.GT11268@two.firstfloor.org>
 <20130316204539.GA19462@redhat.com>
 <20130316205634.GU11268@two.firstfloor.org>
 <20130316212351.GA21190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316212351.GA21190@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 10:23:51PM +0100, Oleg Nesterov wrote:
> On 03/16, Andi Kleen wrote:
> >
> > > Perhaps rcu can be better, although a global rwsem looks simpler,
> > > I dunno.
> >
> > It's a general problem with lots of sysctls.
> > >
> > > But argv_split() or its usage should be changed anyway, and GFP_KERNEL
> > > won't work under rcu_read_lock().
> >
> > rcu strings has a helper function to copy the string for sleepy cases.
> 
> Then you need to pre-allocate, take rcu_read_lock(), copy, and check
> that it actually fits the pre-allocated buffer. Not sure why the simple
> rwsem is worse.

The reason I did it originally like that was that some of the sysctls weren't
as "slow path" as power off. And for anything that is even moderately
often used a global lock is going to hurt eventually. The "read" in the
sem also doesn't help because it's still a hot cache line. 
I agree if it the goal was only to fix poweroff RCU is somewhat
overkill and a global lock would be fine.

> But I won't argue in any case
> 
> > > To me 1/2 looks as a simplification anyway, but I won't argue if we
> > > decide to add rcu/locking and avoid this patch.
> >
> > Ok I'll revisit.
> 
> OK, but do you agree with 1/2?

It doesn't solve the race alone because when the 0 byte can move it's
not safe to run kstrndup() in parallel. Ok given the n and that it 
force terminates it could only lead to some junk at the end.

But it seems like a useful small optimization, although I don't know
if it's used in any non slow paths.

I assume you audited all callers that they comprehend that they need
to free differently now.

-Andi
