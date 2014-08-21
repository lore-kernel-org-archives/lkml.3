Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaHUVas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:30:48 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56583 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbaHUVar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140821212820.GD20529@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com> <d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
 <CALCETrW+vtPnB47aCxfKFxkmKxZS2QsWCkazCc776yg0aPPidA@mail.gmail.com> <20140821212820.GD20529@madcap2.tricolour.ca>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 Aug 2014 14:30:25 -0700
Message-ID: <CALCETrXUTTo5MN=bRM96Kos5JueWED5Rhr7SB2dgzTdy7bw5cw@mail.gmail.com>
Subject: Re: [PATCH V4 1/8] namespaces: assign each namespace instance a
 serial number
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        arozansk@redhat.com, linux-audit@redhat.com,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 2:28 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 14/08/21, Andy Lutomirski wrote:
>> On Aug 20, 2014 8:12 PM, "Richard Guy Briggs" <rgb@redhat.com> wrote:
>> >
>> > Generate and assign a serial number per namespace instance since boot.
>> >
>> > Use a serial number per namespace (unique across one boot of one kernel)
>> > instead of the inode number (which is claimed to have had the right to change
>> > reserved and is not necessarily unique if there is more than one proc fs) to
>> > uniquely identify it per kernel boot.
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> > ---
>> >  fs/mount.h                     |    1 +
>> >  fs/namespace.c                 |    1 +
>> >  include/linux/ipc_namespace.h  |    1 +
>> >  include/linux/nsproxy.h        |    8 ++++++++
>> >  include/linux/pid_namespace.h  |    1 +
>> >  include/linux/user_namespace.h |    1 +
>> >  include/linux/utsname.h        |    1 +
>> >  include/net/net_namespace.h    |    1 +
>> >  init/version.c                 |    1 +
>> >  ipc/msgutil.c                  |    1 +
>> >  ipc/namespace.c                |    2 ++
>> >  kernel/nsproxy.c               |   17 +++++++++++++++++
>> >  kernel/pid.c                   |    1 +
>> >  kernel/pid_namespace.c         |    2 ++
>> >  kernel/user.c                  |    1 +
>> >  kernel/user_namespace.c        |    2 ++
>> >  kernel/utsname.c               |    2 ++
>> >  net/core/net_namespace.c       |    8 +++++++-
>> >  18 files changed, 51 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/fs/mount.h b/fs/mount.h
>> > index d55297f..c076f99 100644
>> > --- a/fs/mount.h
>> > +++ b/fs/mount.h
>> > @@ -5,6 +5,7 @@
>> >  struct mnt_namespace {
>> >         atomic_t                count;
>> >         unsigned int            proc_inum;
>> > +       long long       serial_num;
>> >         struct mount *  root;
>> >         struct list_head        list;
>> >         struct user_namespace   *user_ns;
>> > diff --git a/fs/namespace.c b/fs/namespace.c
>> > index 182bc41..9af49ff 100644
>> > --- a/fs/namespace.c
>> > +++ b/fs/namespace.c
>> > @@ -2486,6 +2486,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
>> >                 kfree(new_ns);
>> >                 return ERR_PTR(ret);
>> >         }
>> > +       new_ns->serial_num = ns_serial();
>> >         new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
>> >         atomic_set(&new_ns->count, 1);
>> >         new_ns->root = NULL;
>> > diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
>> > index 35e7eca..8ccfb2d 100644
>> > --- a/include/linux/ipc_namespace.h
>> > +++ b/include/linux/ipc_namespace.h
>> > @@ -69,6 +69,7 @@ struct ipc_namespace {
>> >         struct user_namespace *user_ns;
>> >
>> >         unsigned int    proc_inum;
>> > +       long long       serial_num;
>> >  };
>> >
>> >  extern struct ipc_namespace init_ipc_ns;
>> > diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
>> > index b4ec59d..8e5fe0d 100644
>> > --- a/include/linux/nsproxy.h
>> > +++ b/include/linux/nsproxy.h
>> > @@ -66,6 +66,14 @@ static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
>> >         return rcu_dereference(tsk->nsproxy);
>> >  }
>> >
>> > +long long ns_serial(void);
>> > +enum {
>> > +       NS_IPC_INIT_SN  = 1,
>> > +       NS_UTS_INIT_SN  = 2,
>> > +       NS_USER_INIT_SN = 3,
>> > +       NS_PID_INIT_SN  = 4,
>>
>> Please add an extra value here for the first dynamic value...
>> > +/**
>> > + * ns_serial - compute a serial number for the namespace
>> > + *
>> > + * Compute a serial number for the namespace to uniquely identify it in
>> > + * audit records.
>> > + */
>> > +long long ns_serial(void)
>> > +{
>> > +       static atomic64_t serial = ATOMIC_INIT(4); /* reserved for IPC, UTS, user, PID */
>>
>> ...and use it here.
>
> Yup, good idea.  Thanks.
>
>> Also, does this work on all architectures?
>
> I only know for certain x86_64.  There is discussion elsewhere about
> changing ns_serial from returning a long long to returning a u64.  That
> should help.  I can run standard compile and boot tests on several
> others, but won't be able to check output.

I was thinking of atomic64.  I guess there's a generic implementation
that works everywhere, if somewhat slowly.

--Andy
