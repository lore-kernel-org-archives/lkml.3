Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3CQOSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab3CQOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:18:15 -0400
Date: Sun, 17 Mar 2013 15:15:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20130317141555.GA25236@redhat.com>
References: <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com> <20130316203221.GT11268@two.firstfloor.org> <20130316204539.GA19462@redhat.com> <20130316205634.GU11268@two.firstfloor.org> <20130316212351.GA21190@redhat.com> <20130316215440.GV11268@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316215440.GV11268@two.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Andi Kleen wrote:
>
> On Sat, Mar 16, 2013 at 10:23:51PM +0100, Oleg Nesterov wrote:
> > >
> > > rcu strings has a helper function to copy the string for sleepy cases.
> >
> > Then you need to pre-allocate, take rcu_read_lock(), copy, and check
> > that it actually fits the pre-allocated buffer. Not sure why the simple
> > rwsem is worse.
>
> The reason I did it originally like that was that some of the sysctls weren't
> as "slow path" as power off.

OK, in this case rwsem is not fine, I agree.

> > > > To me 1/2 looks as a simplification anyway, but I won't argue if we
> > > > decide to add rcu/locking and avoid this patch.
> > >
> > > Ok I'll revisit.
> >
> > OK, but do you agree with 1/2?
>
> It doesn't solve the race alone because when the 0 byte can move it's
> not safe to run kstrndup() in parallel.

I don't think this is possible... To simplify, lets consider
poweroff_cmd[POWEROFF_CMD_PATH_LEN]. proc_dostring() or whatever can
never overwrite the last byte == 0, otherwise it will exceed this array
later to write the final zero.

But this doesn't matter,

> Ok given the n and that it
> force terminates it could only lead to some junk at the end.

Yes, kstrndup(max) is always safe even if the memory is not null
terminated.

> But it seems like a useful small optimization, although I don't know
> if it's used in any non slow paths.

Ah, I didn't mean the patch makes sense because of optimization. My
point was, we can fix the race without making this code worse (in fact
it tries to make the code better but this is subjective).

"fix the race" only means "make it safe" of course, a string in between
is unlikely useful.

> I assume you audited all callers that they comprehend that they need
> to free differently now.

Yes, /bin/grep shows that all callers use argv_free().

Oleg.

