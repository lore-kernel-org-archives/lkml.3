Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3F1SA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab3F1SA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:00:56 -0400
Date: Fri, 28 Jun 2013 19:55:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
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
Message-ID: <20130628175559.GA30445@redhat.com>
References: <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com> <51C80CF0.4070608@imgtec.com> <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org> <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com> <51CACB80.5020706@imgtec.com> <20130626161452.GA2888@redhat.com> <20130626165900.GF7171@linux-mips.org> <20130626171551.GA5830@redhat.com> <51CD7C8C.4050807@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CD7C8C.4050807@imgtec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, James Hogan wrote:
>
> On 26/06/13 18:15, Oleg Nesterov wrote:
> >
> > I meant the minimal hack like
> >
> > 	--- x/arch/mips/include/uapi/asm/signal.h
> > 	+++ x/arch/mips/include/uapi/asm/signal.h
> > 	@@ -11,9 +11,9 @@
> >
> > 	 #include <linux/types.h>
> >
> > 	-#define _NSIG		128
> > 	+#define _NSIG		127
> > 	 #define _NSIG_BPW	(sizeof(unsigned long) * 8)
> > 	-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
> > 	+#define _NSIG_WORDS	DIV_ROUND_UP(_NSIG / _NSIG_BPW)
> >
> > 	 typedef struct {
> > 		unsigned long sig[_NSIG_WORDS];
> >
> > just to avoid BUG_ON().
> >
> > I agree that _NSIG == 126 or 64 needs more discussion. Although personally
> > I think this is the only choice in the long term, or we should change ABI
> > and break user-space completely.
> >
> > And, just in case, the hack above doesn't kill SIG_128 completely.
> > Say, the task can block/unblock it.
>
> Well it prevents a handler being added or the signal being sent, so it
> pretty much does kill it (patch v2 did this).

Yes, iirc you already sent something like the hack above.

> but it looks like it may be safe to
> reduce _NSIG to 127 for a stable fix

This was my point.

Sure, this change can break something anyway, we can't know if nobody
ever uses 128 anyway. But this is better than the ability to crash the
kernel. No need to use strace, just block(128) + kill(128) + unblock().

So perhaps you can resend your patch? Just I think it makes sense to
update the changelog to explain that this is not the "final" solution
but the minimal fix.

Oleg.

