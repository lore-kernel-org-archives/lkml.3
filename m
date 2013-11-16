Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3KPTEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 14:04:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3KPTEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 14:04:00 -0500
Date: Sat, 16 Nov 2013 20:00:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 0/3] get/set_dumpable() cleanups and theoretical fix
Message-ID: <20131116190057.GA22666@redhat.com>
References: <20131101232521.GA23119@www.outflux.net> <20131114170337.GA11068@redhat.com> <CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com> <20131115203652.GA13476@redhat.com> <CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Kees Cook wrote:
>
> On Fri, Nov 15, 2013 at 12:36 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > unless I missed something, this is the fix, not cleanup ?
> >
> > If commit_creds()->set_dumpable(SUID_DUMP_ROOT) races with
> > sys_prctl()->set_dumpable(SUID_DUMP_DISABLE), we can get
> > SUID_DUMP_USER afaics.
> >
> > Yes, yes, even if I am right this race is very unlikely.
>
> Hm, yes, that is a fix then. I struggle to imagine it being
> exploitable (i.e. control over both threads, one at least already with
> a different cred, etc), but it certainly does look like a bug.

Yes, yes, sure, this is only theoretical.

OK, I am sending the patches to lkml. I didn't dare to keep your ack,
please review v2 (v1 confused bit-mask with bit-number, and in theory
we need ACCESS_ONCE).

It would be really nice if someone can ack the "it is safe to mix
bitops and cmpxchg" assumption mentioned in the changelog.


Alex, Josh, this also partly reverts 179899fd5dc780fe "coredump:
update coredump-related headers", I think fs/coredump.h buys nothing.

Oleg.

 fs/coredump.c         |    1 -
 fs/coredump.h         |    6 -----
 fs/exec.c             |   61 +++++--------------------------------------------
 include/linux/sched.h |   25 ++++++++++++++-----
 4 files changed, 24 insertions(+), 69 deletions(-)

