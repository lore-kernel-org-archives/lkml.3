Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3F1MHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:07:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19543 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3F1MHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:07:49 -0400
Message-ID: <51CD7C8C.4050807@imgtec.com>
Date: Fri, 28 Jun 2013 13:07:40 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>,
        "David Daney" <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com> <51C80CF0.4070608@imgtec.com> <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org> <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com> <51CACB80.5020706@imgtec.com> <20130626161452.GA2888@redhat.com> <20130626165900.GF7171@linux-mips.org> <20130626171551.GA5830@redhat.com>
In-Reply-To: <20130626171551.GA5830@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_28_13_07_42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/13 18:15, Oleg Nesterov wrote:
> On 06/26, Ralf Baechle wrote:
>>
>> On Wed, Jun 26, 2013 at 06:14:52PM +0200, Oleg Nesterov wrote:
>>
>>> Or simply remove the BUG_ON(), this can equally confuse wait(status).
>>> 128 & 0x7f == 0.
>>>
>>> Still I think it would be better to change _NSIG on mips.
>>
>> If it was that easy.  That's going to outright break binary compatibility,
>> see kernel/signal.c:
>>
>> SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
>>                 sigset_t __user *, oset, size_t, sigsetsize)
>> {
>>         sigset_t old_set, new_set;
>>         int error;
>>
>>         /* XXX: Don't preclude handling different sized sigset_t's.  */
>>         if (sigsetsize != sizeof(sigset_t))
>>                 return -EINVAL;
> 
> I meant the minimal hack like
> 
> 	--- x/arch/mips/include/uapi/asm/signal.h
> 	+++ x/arch/mips/include/uapi/asm/signal.h
> 	@@ -11,9 +11,9 @@
> 	 
> 	 #include <linux/types.h>
> 	 
> 	-#define _NSIG		128
> 	+#define _NSIG		127
> 	 #define _NSIG_BPW	(sizeof(unsigned long) * 8)
> 	-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
> 	+#define _NSIG_WORDS	DIV_ROUND_UP(_NSIG / _NSIG_BPW)
> 	 
> 	 typedef struct {
> 		unsigned long sig[_NSIG_WORDS];
> 
> just to avoid BUG_ON().
> 
> I agree that _NSIG == 126 or 64 needs more discussion. Although personally
> I think this is the only choice in the long term, or we should change ABI
> and break user-space completely.
> 
> And, just in case, the hack above doesn't kill SIG_128 completely.
> Say, the task can block/unblock it.

Well it prevents a handler being added or the signal being sent, so it
pretty much does kill it (patch v2 did this). Since glibc already has
SIGRTMAX=127, nothing running glibc should be affected unless it's being
really stupid (uClibc and bionic is a different matter).

I've booted debian with only 64 signals and an appropriate printk in
do_sigaction, and although various things try and set all the handlers,
I didn't found anything that breaks because of them being missing.

I've also audited all the binaries installed on my desktop (Fedora 17)
which contain libc_current_sigrtmax to see if I can find anything
problematic. Various things iterate all the signals (which doesn't do
any harm if a bunch are missing, especially when EINVAL is often
expected for SIGRTMIN..SIGRTMIN+2 because of libc using them). High
level language bindings open up some potential for breakage since
SIGRTMAX etc can be exposed to higher levels. The only real problem I've
found though is openjdk:

http://hg.openjdk.java.net/jdk7/jsn/jdk/file/tip/src/solaris/native/java/net/linux_close.c
57 /*
58  * Signal to unblock thread
59  */
60 static int sigWakeup = (__SIGRTMAX - 2);

It sets up a signal handler when the library is loaded (without any
error checking), and tries to send the signal to all threads blocked on
a file descriptor to wake them up (again without error checking), called
from NET_Dup2 and NET_SocketClose. Clearly this could easily break
backwards compatibility if SIGRTMAX is reduced any lower than 126.

Obviously this isn't exhaustive (I haven't tried android etc or actually
running many applications, and open source software probably isn't the
best example of badly written code), but it looks like it may be safe to
reduce _NSIG to 127 for a stable fix if nobody objects, and possibly to
126 in the future to avoid the wait exit status problem.

Cheers
James

