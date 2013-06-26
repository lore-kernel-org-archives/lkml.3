Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3FZQ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:59:14 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:54046 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3FZQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:59:12 -0400
Date: Wed, 26 Jun 2013 18:59:00 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20130626165900.GF7171@linux-mips.org>
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
 <51C47864.9030200@gmail.com>
 <20130621202244.GA16610@redhat.com>
 <51C4BB86.1020004@caviumnetworks.com>
 <20130622190940.GA14150@redhat.com>
 <51C80CF0.4070608@imgtec.com>
 <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org>
 <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com>
 <51CACB80.5020706@imgtec.com>
 <20130626161452.GA2888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626161452.GA2888@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:14:52PM +0200, Oleg Nesterov wrote:

> Or simply remove the BUG_ON(), this can equally confuse wait(status).
> 128 & 0x7f == 0.
> 
> Still I think it would be better to change _NSIG on mips.

If it was that easy.  That's going to outright break binary compatibility,
see kernel/signal.c:

SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
                sigset_t __user *, oset, size_t, sigsetsize)
{
        sigset_t old_set, new_set;
        int error;

        /* XXX: Don't preclude handling different sized sigset_t's.  */
        if (sigsetsize != sizeof(sigset_t))
                return -EINVAL;

There are several more more syscalls performing tests like the above.

So at least the kernel sigset_t will have to remain constant, maybe something
like below, totally untested patch which I'm sure is going to open a few
20 foot containers full of worms such as NSIG being defined by glibc to 128
and fixing the kernel won't magically change installed libc headers or
binaries incorporating NSIG.

  Ralf

 arch/mips/include/uapi/asm/signal.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/signal.h b/arch/mips/include/uapi/asm/signal.h
index addb9f5..8bba323 100644
--- a/arch/mips/include/uapi/asm/signal.h
+++ b/arch/mips/include/uapi/asm/signal.h
@@ -11,12 +11,13 @@
 
 #include <linux/types.h>
 
-#define _NSIG		128
+#define _NSIG		64
 #define _NSIG_BPW	(sizeof(unsigned long) * 8)
 #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
 
 typedef struct {
 	unsigned long sig[_NSIG_WORDS];
+	unsigned long __fill[_NSIG_WORDS];
 } sigset_t;
 
 typedef unsigned long old_sigset_t;		/* at least 32 bits */
