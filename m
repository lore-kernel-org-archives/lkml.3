Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaKGNLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:11:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54539 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaKGNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:11:37 -0500
Date: Fri, 7 Nov 2014 13:11:30 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141107131129.GF18916@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
 <1678531.AUssrM9PAs@wuerfel>
 <20141107121119.GQ4042@n2100.arm.linux.org.uk>
 <353850534.aGkkrtTogX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <353850534.aGkkrtTogX@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:44:07PM +0000, Arnd Bergmann wrote:
> On Friday 07 November 2014 12:11:19 Russell King - ARM Linux wrote:
> > On Fri, Nov 07, 2014 at 01:03:00PM +0100, Arnd Bergmann wrote:
> > > On Friday 07 November 2014 11:55:51 Will Deacon wrote:
> > > > We need this for arm64 and, since all architectures seem to have a mechanism
> > > > for setting a system call via ptrace, moving it to generic code should make
> > > > sense for new architectures too, no?
> > > 
> > > It makes a little more sense now, but I still don't understand why you
> > > need to set the system call number via ptrace. What is this used for,
> > > and why doesn't any other architecture have this?
> > 
> > All other architectures have a way.  x86, for example, you set orig_eax
> > (or orig_rax) to change the syscall number.  On ARM, that doesn't work
> > because we don't always pass the syscall number in a register.
> > 
> 
> Sorry for being slow today, but why can't we use the same interface that
> s390 has on arm64:
> 
> static int s390_system_call_get(struct task_struct *target,
>                                 const struct user_regset *regset,
>                                 unsigned int pos, unsigned int count,
>                                 void *kbuf, void __user *ubuf)
> {
>         unsigned int *data = &task_thread_info(target)->system_call;
>         return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
>                                    data, 0, sizeof(unsigned int));
> }
> 
> static int s390_system_call_set(struct task_struct *target,
>                                 const struct user_regset *regset,
>                                 unsigned int pos, unsigned int count,
>                                 const void *kbuf, const void __user *ubuf)
> {
>         unsigned int *data = &task_thread_info(target)->system_call;
>         return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
>                                   data, 0, sizeof(unsigned int));
> }
> 
> static const struct user_regset s390_regsets[] = {
> 	...
>         {
>                 .core_note_type = NT_S390_SYSTEM_CALL,
>                 .n = 1,
>                 .size = sizeof(unsigned int),
>                 .align = sizeof(unsigned int),
>                 .get = s390_system_call_get,
>                 .set = s390_system_call_set,
>         },
> 	...
> };
> 
> Is it just preference for being consistent with ARM32, or is there a
> reason this won't work?

Interesting, I hadn't considered a unit-length regset.

> It's not that I care strongly about the interface, my main point is
> that the changelog doesn't describe why one interface was used instead
> the other.

I suspect the current approach was taken because it follows the same scheme
as 32-bit ARM. If both methods are sufficient (Kees would have a better idea
than me on that), then I don't have a strong preference.

Will
