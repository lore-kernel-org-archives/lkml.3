Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaCaOMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:12:42 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:32297 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:12:40 -0400
Message-ID: <1396275156.2507.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: constify ipc_ops
From: Davidlohr Bueso <davidlohr@hp.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Nadia Derbey <Nadia.Derbey@bull.net>,
        Manfred Spraul <manfred@colorfullife.com>
Date: Mon, 31 Mar 2014 07:12:36 -0700
In-Reply-To: <CA+rthh93hc5w_yKMLyJmEZFrW0NbHU3TEf_YL4cpE5OT3hvpLQ@mail.gmail.com>
References: <1396186538-3378-1-git-send-email-minipli@googlemail.com>
	 <1396216043.2579.11.camel@buesod1.americas.hpqcorp.net>
	 <CA+rthh93hc5w_yKMLyJmEZFrW0NbHU3TEf_YL4cpE5OT3hvpLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 10:28 +0200, Mathias Krause wrote:
> On 30 March 2014 23:47, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > On Sun, 2014-03-30 at 15:35 +0200, Mathias Krause wrote:
> >> There is no need to recreate the very same ipc_ops structure on every
> >> kernel entry for msgget/semget/shmget. Just declare it static and be
> >> done with it.
> >> While at it, constify it as we don't modify the structure at runtime.
> >
> > Seems reasonable.
> >
> >>
> >> Found in the PaX patch, written by the PaX Team.
> >>
> >> Cc: PaX Team <pageexec@freemail.hu>
> >> Cc: Nadia Derbey <Nadia.Derbey@bull.net>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> >
> > In the future, for ipc changes, please CC me and Manfred as well.
> 
> As there is no maintainer entry for ipc/ in the MAINTAINERS file I
> looked at the recent commit history of ipc/ and found that most of the
> patches went in via Andrew and then Linus. But it's true, you and
> Manfred have quite some patches in the recent past. Though, having an
> official maintaner for ipc/ would accelerate the gyrating phase of
> whom to send the patches to in the future. Are you volunteering? :)
> 
> >
> > One comment below, otherwise:
> > Acked-by: Davidlohr Bueso <davidlohr@hp.com>
> >
> >> ---
> >>  ipc/msg.c  |    9 ++++-----
> >>  ipc/sem.c  |   10 +++++-----
> >>  ipc/shm.c  |   10 +++++-----
> >>  ipc/util.c |    8 ++++----
> >>  ipc/util.h |    2 +-
> >>  5 files changed, 19 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/ipc/msg.c b/ipc/msg.c
> >> index 649853105a..35e4018de5 100644
> >> --- a/ipc/msg.c
> >> +++ b/ipc/msg.c
> >> @@ -306,15 +306,14 @@ static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
> >>  SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
> >>  {
> >>       struct ipc_namespace *ns;
> >> -     struct ipc_ops msg_ops;
> >> +     static const struct ipc_ops msg_ops = {
> >> +             .getnew = newque,
> >> +             .associate = msg_security,
> >
> > For completeness, please add .more_checks = NULL as well.
> 
> The C standard already ensures that .more_checks is initialized with
> NULL. So I don't see any benefit from doing it explicitly.
> We're not initializing global/static variables holding NULL pointers
> in the majority of the code base either, so this is just "best
> practice".

Hence the word _completeness_.


