Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3DWXnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3DWXnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:43:05 -0400
Date: Tue, 23 Apr 2013 16:43:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp
 filters.
Message-Id: <20130423164303.d2eb663c4a1becea4a185087@linux-foundation.org>
In-Reply-To: <51752D98.8070709@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
	<1363618233-6375-2-git-send-email-nschichan@freebox.fr>
	<20130417145628.88058f0f3104ab9ae551ddd3@linux-foundation.org>
	<51752D98.8070709@freebox.fr>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 14:31:20 +0200 Nicolas Schichan <nschichan@freebox.fr> wrote:

> On 04/17/2013 11:56 PM, Andrew Morton wrote:
> > This patch is killing me.
> >
> >> --- a/include/linux/seccomp.h
> >> +++ b/include/linux/seccomp.h
> >> @@ -6,6 +6,7 @@
> >>   #ifdef CONFIG_SECCOMP
> >>
> >>   #include <linux/thread_info.h>
> >> +#include <linux/filter.h>
> >>   #include <asm/seccomp.h>
> >
> > In file included from include/linux/compat.h:18,
> >                   from include/linux/filter.h:9,
> >                   from include/linux/seccomp.h:9,
> >                   from include/linux/sched.h:39,
> >                   from arch/x86/kernel/asm-offsets.c:9:
> > /usr/src/25/arch/x86/include/asm/compat.h: In function 'arch_compat_alloc_user_space':
> > /usr/src/25/arch/x86/include/asm/compat.h:301: error: dereferencing pointer to incomplete type
> >
> > Problem is, compat.h's arch_compat_alloc_user_space() needs sched.h for
> > task_struct but as you can see from the above include tree, sched.h
> > includes seccomp.h and everything falls over.  The preprocessed code
> > contains the definition of arch_compat_alloc_user_space() *before* the
> > definition of task_struct.
> >
> > This is a basic x86_64 "make clean; make allmodconfig; make".
> 
> Hi,
> 
> Would including <uapi/linux/filter.h> instead of <linux/filter.h> in seccomp.h 
> be an acceptable solution ?
> 
> I have tried that and (with an additional forward declaration of struct 
> sk_buff) an x86_64 "make clean; make allmodconfig" run finishes succesfully.
> 
> If that's ok with you, I can resend the serie with that fix.

It would be better to make the code and include tangle less complex,
rather than more complex.

Did we really need to move the `struct seccomp_filter' definition into
the header file?  afaict that wasn't really necessary - we can add a
few helper functions to kernel/seccomp.c and then have the remote code
treat seccomp_filter in an opaque fashion rather than directly poking
at its internals.


btw, what on earth is going on with seccomp_jit_free()?  It does
disturbing undocumented typecasting and it punts the module_free into a
kernel thread for mysterious, undocumented and possibly buggy reasons.

I realize it just copies bpf_jit_free().  The same observations apply there.
