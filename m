Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3J3BZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:25:56 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48013 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3J3BZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <8761sflhi1.fsf@tw-ebiederman.twitter.com>
References: <20131029220939.GA23060@kroah.com>
	<8761sflhi1.fsf@tw-ebiederman.twitter.com>
Date: Tue, 29 Oct 2013 18:25:53 -0700
X-Google-Sender-Auth: Zbh_TbwhXzMAuTUQb1HM9oeiT_4
Message-ID: <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
Subject: Re: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 5:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> I don't have a strong feeling either way but how would that matter?
> There is only ever one sd associated with a kobj.

What does that matter? If you have multiple callers, they might try to
free that one sd twice, since they could both see a non-NULL case.

> And we better be under the sysfs_mutex when the assignment and and
> sysfs_remove_dir are called.

Not as far as I can tell. kobject_del() calls sysfs_remove_dir(), and
I'm not seeing why that would be under the mutex.  The only locking I
see is that sysfs_assoc_lock, which _isn't_ held for the reading of
kobj->sd.

Now, there may be other reasons for this all working (like the fact
that only one user ever calls kobject_del() on any particular object,
but it sure as hell isn't obvious. The fact that you seem to be
confused about this only proves my point.

Besides, the "design pattern" of having a lock for the assignment, but
then reading the value without that lock seems to be all kinds of
f*cking stupid, wouldn't you agree? I'm really not seeing how that
could _ever_ be something you make excuses for in the first place.
Even if there is some external locking (which, as far as I can tell,
there is not), that would just raise the question as to what reason
that spinlock has to exist at all.

The code doesn't make any sense with the locking the way it is now. It
might _work_, of course, but it sure as hell doesn't make sense.


              Linus
