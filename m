Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3H0OqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:46:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3H0OqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:46:05 -0400
Date: Tue, 27 Aug 2013 16:39:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: [PATCH 0/1] proc: make /proc/self point to thread
Message-ID: <20130827143938.GA19425@redhat.com>
References: <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com> <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Linus Torvalds wrote:
>
> On Mon, Aug 26, 2013 at 11:09 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Patch looks ok to me, but since this has never worked and nobody has
> > actually complained, I can't really convince myself that this is
> > critical.
>
> Actually, let's back-track..
>
> Did you try the other approach? Make /proc/self point to the thread
> instead of the task?

Yes, I thought about this. But I agree with Eric, we probably need
another magic link, /proc/thread or whatever.

And. I think that s/task_pid/task_tgid/ in proc_fd_permission()
makes sense anyway. It is not only for /proc/self, why we should
restrict the access to /proc/<sub-thread>/fd ?

> The thread-group leader seems to have these extra files:
>
>  - autogroup, coredump_filter, mountstats, net, task
>

Note really afaics. Yes, tgid_base_stuff and tid_base_stuff differ,
but proc_root_lookup() uses tgid_base_stuff in any case, so
/proc/<tid>/ also has task,mountstats,etc even if it is not leader.

> Yes, it would be semantically different,

And I am afraid this can break things. But I leave this to you and Eric.

Personally I think that /proc/self pointing to "current" is better, and
in fact I was surprised when I recently found that this is not true.
But perhaps it is too late to change this old behaviour.

> but it would mean that
> "/proc/self/fd/" would actually make sense in a way that it currently
> does *not* - which would seem fairly important, since the primary use
> for it tends to be /dev/stdin.

I think this doesn't matter "in practice", normally all threads have
the same ->files. Who needs CLONE_THREAD without CLONE_FILES ?

> And the other semantic differences might be much harder to notice.
> Worth testing?

Perhaps... Well, if Andrew takes this patch (assuming you and Eric
ack it), we can see if we have any bug reports.

Oleg.

