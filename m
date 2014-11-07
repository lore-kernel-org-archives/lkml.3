Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKGMo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:44:58 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57770 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaKGMo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:44:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        Will Deacon <will.deacon@arm.com>, "oleg@redhat.com" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Fri, 07 Nov 2014 13:44:07 +0100
Message-ID: <353850534.aGkkrtTogX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141107121119.GQ4042@n2100.arm.linux.org.uk>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <1678531.AUssrM9PAs@wuerfel> <20141107121119.GQ4042@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mlEVfBtx5YXd6EK7GCpJLmldEP2wNOMc0HgjHdglSAB
 ZntFOGWXY51TG2uOeVfwKwikkuufWscq0ZZSiKXZIh9oF+kLzt
 yOwZlmXv0a7Uv1SwcHQ1+5vQalKfVRfodwQnaF7mNngy67EFNt
 q/5gCHqOssJxsETt6CbUytnJh8Zpikhw1Vko0Y/dCrDMtzn4Dv
 f45AdDQ0J5gdmT6BDM4DyDl8VL13QXQeLifIb2sftk63aXzU79
 0z5UoK/IRCVnq2JlxWQDYT9KE2GDd8vrgc8kYaIm4EWyMDF1+x
 oKIKc/K7dKmE4h3yCMvjBX4UMfJXDAEvyTulb5H8N3O9NwOHHl
 q2fyHQ1MgH2Welf8+J6M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 12:11:19 Russell King - ARM Linux wrote:
> On Fri, Nov 07, 2014 at 01:03:00PM +0100, Arnd Bergmann wrote:
> > On Friday 07 November 2014 11:55:51 Will Deacon wrote:
> > > We need this for arm64 and, since all architectures seem to have a mechanism
> > > for setting a system call via ptrace, moving it to generic code should make
> > > sense for new architectures too, no?
> > 
> > It makes a little more sense now, but I still don't understand why you
> > need to set the system call number via ptrace. What is this used for,
> > and why doesn't any other architecture have this?
> 
> All other architectures have a way.  x86, for example, you set orig_eax
> (or orig_rax) to change the syscall number.  On ARM, that doesn't work
> because we don't always pass the syscall number in a register.
> 

Sorry for being slow today, but why can't we use the same interface that
s390 has on arm64:

static int s390_system_call_get(struct task_struct *target,
                                const struct user_regset *regset,
                                unsigned int pos, unsigned int count,
                                void *kbuf, void __user *ubuf)
{
        unsigned int *data = &task_thread_info(target)->system_call;
        return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
                                   data, 0, sizeof(unsigned int));
}

static int s390_system_call_set(struct task_struct *target,
                                const struct user_regset *regset,
                                unsigned int pos, unsigned int count,
                                const void *kbuf, const void __user *ubuf)
{
        unsigned int *data = &task_thread_info(target)->system_call;
        return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
                                  data, 0, sizeof(unsigned int));
}

static const struct user_regset s390_regsets[] = {
	...
        {
                .core_note_type = NT_S390_SYSTEM_CALL,
                .n = 1,
                .size = sizeof(unsigned int),
                .align = sizeof(unsigned int),
                .get = s390_system_call_get,
                .set = s390_system_call_set,
        },
	...
};

Is it just preference for being consistent with ARM32, or is there a
reason this won't work?

It's not that I care strongly about the interface, my main point is
that the changelog doesn't describe why one interface was used instead
the other.

	Arnd
