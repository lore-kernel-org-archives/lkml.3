Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3FZRU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3FZRUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:20:54 -0400
Date: Wed, 26 Jun 2013 19:15:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Message-ID: <20130626171551.GA5830@redhat.com>
References: <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com> <51C80CF0.4070608@imgtec.com> <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org> <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com> <51CACB80.5020706@imgtec.com> <20130626161452.GA2888@redhat.com> <20130626165900.GF7171@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626165900.GF7171@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Ralf Baechle wrote:
>
> On Wed, Jun 26, 2013 at 06:14:52PM +0200, Oleg Nesterov wrote:
>
> > Or simply remove the BUG_ON(), this can equally confuse wait(status).
> > 128 & 0x7f == 0.
> >
> > Still I think it would be better to change _NSIG on mips.
>
> If it was that easy.  That's going to outright break binary compatibility,
> see kernel/signal.c:
>
> SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
>                 sigset_t __user *, oset, size_t, sigsetsize)
> {
>         sigset_t old_set, new_set;
>         int error;
>
>         /* XXX: Don't preclude handling different sized sigset_t's.  */
>         if (sigsetsize != sizeof(sigset_t))
>                 return -EINVAL;

I meant the minimal hack like

	--- x/arch/mips/include/uapi/asm/signal.h
	+++ x/arch/mips/include/uapi/asm/signal.h
	@@ -11,9 +11,9 @@
	 
	 #include <linux/types.h>
	 
	-#define _NSIG		128
	+#define _NSIG		127
	 #define _NSIG_BPW	(sizeof(unsigned long) * 8)
	-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
	+#define _NSIG_WORDS	DIV_ROUND_UP(_NSIG / _NSIG_BPW)
	 
	 typedef struct {
		unsigned long sig[_NSIG_WORDS];

just to avoid BUG_ON().

I agree that _NSIG == 126 or 64 needs more discussion. Although personally
I think this is the only choice in the long term, or we should change ABI
and break user-space completely.

And, just in case, the hack above doesn't kill SIG_128 completely.
Say, the task can block/unblock it.

Oleg.

