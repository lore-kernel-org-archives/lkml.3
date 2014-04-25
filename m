Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaDYTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaDYTZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:25:55 -0400
Date: Fri, 25 Apr 2014 21:25:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        john.johansen@canonical.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@ZenIV.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
Message-ID: <20140425192543.GA11908@redhat.com>
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com> <20140425182310.GA9128@redhat.com> <87sip15iy5.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sip15iy5.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Eric, this makes me think again that we should do exit_task_namespaces()
> > after exit_task_work(). We already discussed this before, but this looks
> > like another indication this change makes sense.
>
> I know you mentioned something about that.  I haven't actually had much
> time to think about it.
>
> > The problem with fput() from free_nsproxy() was hopefully also fixed by
> > e7b2c4069252. The main motivation for "move" was "outside of exit_notify".
> > Even if we fix the paths above task_work_add() can have another user which
> > wants ->nsproxy.
> >
> > What do you think?
>
> I am scratching my head.  Delayed work that depends on current sort of
> blows my mind.

But task_work_add(task) was specially introduced to run a callback in the
task's context.

> That is utter nonsense.

Yes I agree, _perhaps_ we can fix this particular problem without changing
the exit_namespace/work ordering, and perhaps this makes sense anyway.

Well. I _think_ that __fput() and ima_file_free() in particular should not
depend on current and/or current->nsproxy. If nothing else, fput() can be
called by the unrelated task which looks into /proc/pid/.

But again, task_work_add() has more and more users, and it seems that even
__fput() paths can do "everything", so perhaps it would be safer to allow
to use ->nsproxy in task_work_run.

Oleg.

