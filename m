Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3BKMmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:42:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab3BKMmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:42:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130122073315.13822.27093.stgit@srivatsabhat.in.ibm.com>
References: <20130122073315.13822.27093.stgit@srivatsabhat.in.ibm.com> <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        tj@kernel.org, oleg@redhat.com, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/45] percpu_rwlock: Introduce the global reader-writer lock backend
Date: Mon, 11 Feb 2013 12:41:31 +0000
Message-ID: <30708.1360586491@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> We can use global rwlocks as shown below safely, without fear of deadlocks:
> 
> Readers:
> 
>          CPU 0                                CPU 1
>          ------                               ------
> 
> 1.    spin_lock(&random_lock);             read_lock(&my_rwlock);
> 
> 
> 2.    read_lock(&my_rwlock);               spin_lock(&random_lock);

The lock order on CPU 0 is unsafe if CPU2 can do:

	write_lock(&my_rwlock);
	spin_lock(&random_lock);

and on CPU 1 if CPU2 can do:

	spin_lock(&random_lock);
	write_lock(&my_rwlock);

I presume you were specifically excluding these situations?

David
