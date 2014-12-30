Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaL3FG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:06:56 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54313 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3FGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:06:55 -0500
MIME-Version: 1.0
In-Reply-To: <1419894305.4961.2.camel@freescale.com>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com> <1419894305.4961.2.camel@freescale.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 30 Dec 2014 00:06:22 -0500
Message-ID: <CAJhHMCBTYOsfZOH92KhTAbqH+UqsjuBNUGzxRwUT+Ah7P0eJ2g@mail.gmail.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>,
        Andy Fleming <afleming@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Daniel Walter <dwalter@google.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 6:05 PM, Scott Wood <scottwood@freescale.com> wrote:
> On Sat, 2014-12-27 at 12:17 -0500, Pranith Kumar wrote:
>> Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
>> is a compile time failure if srcu is used when not enabled. This was decided to
>> be better than waiting until link time for a failure to occur.
>
> Yes, false positives and extra ifdefs are so much better. :-P
>
> Why not just ifdef the functions/macros, and leave the types alone?  If
> you're worried about direct access to struct members, you could even
> ifdef the members away while leaving the struct itself.  It is not
> normal practice in Linux to need ifdefs around #includes.

Yup, totally agree that this is not ideal. The idea here is to not
even compile the structure for tinification purposes. ifdefs for
headers are ugly, but given the current code structure, I was not able
to figure out any other way around it without major overhaul.

>
>> There are places which include kvm headers and utilize kvm data structures
>> without checking if KVM is enabled. In two such archs(s390, ppc64), the current
>> patch makes the uses of KVM conditional on KVM being enabled. The other option,
>> which is to enable KVM unconditionally seemed a bit too much as we could easily
>> figure out KVM only parts and enclose them in ifdefs.
>
> Maybe not so easy (mpc85xx_smp_defconfig with NOTIFY stuff turned off so
> that SRCU gets deselected):
>
> In file included from /home/scott/fsl/git/linux/upstream/arch/powerpc/include/asm/kvm_ppc.h:30:0,
>                  from /home/scott/fsl/git/linux/upstream/arch/powerpc/kernel/smp.c:39:
> /home/scott/fsl/git/linux/upstream/include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
> /home/scott/fsl/git/linux/upstream/include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
> /home/scott/fsl/git/linux/upstream/scripts/Makefile.build:257: recipe for target 'arch/powerpc/kernel/smp.o' failed
> make[2]: *** [arch/powerpc/kernel/smp.o] Error 1
> /home/scott/fsl/git/linux/upstream/Makefile:955: recipe for target 'arch/powerpc/kernel' failed
> make[1]: *** [arch/powerpc/kernel] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> Are you sure KVM is the only SRCU user so impacted?  It's also likely
> that new such problems get introduced, because most people are going to
> have SRCU enabled and thus not notice the breakage they're adding.

Well, it is the major one which I encountered until now. There might
be other problems lurking which I will gladly try to fix if and when
they are reported.

>
> There's also at least one place that needs to be fixed, that currently
> expects to get other headers indirectly via srcu.h:
>
> /home/scott/fsl/git/linux/upstream/lib/assoc_array.c: In function 'assoc_array_apply_edit':
> /home/scott/fsl/git/linux/upstream/lib/assoc_array.c:1425:2: error: implicit declaration of function 'call_rcu' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> /home/scott/fsl/git/linux/upstream/scripts/Makefile.build:257: recipe for target 'lib/assoc_array.o' failed

I will send a patch fixing this(need to use rcupdate.h here
explicitly). Thanks for reporting these!

>
> -Scott
>
>



-- 
Pranith
