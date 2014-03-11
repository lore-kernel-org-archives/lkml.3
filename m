Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaCKWHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:07:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaCKWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:07:35 -0400
Date: Tue, 11 Mar 2014 15:07:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3 00/52] CPU hotplug: Fix issues with callback
 registration
Message-Id: <20140311150733.efcc594dd7fe59c9c5fe9325@linux-foundation.org>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 02:03:52 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Hi,
> 
> Many subsystems and drivers have the need to register CPU hotplug callbacks
> from their init routines and also perform initialization for the CPUs that are
> already online. But unfortunately there is no race-free way to achieve this
> today.
> 
> For example, consider this piece of code:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	put_online_cpus();
> 
> This is not safe because there is a possibility of an ABBA deadlock involving
> the cpu_add_remove_lock and the cpu_hotplug.lock.
> 
>           CPU 0                                         CPU 1
>           -----                                         -----
> 
>    Acquire cpu_hotplug.lock
>    [via get_online_cpus()]
> 
>                                               CPU online/offline operation
>                                               takes cpu_add_remove_lock
>                                               [via cpu_maps_update_begin()]
> 
>    Try to acquire
>    cpu_add_remove_lock
>    [via register_cpu_notifier()]
> 
>                                               CPU online/offline operation
>                                               tries to acquire cpu_hotplug.lock
>                                               [via cpu_hotplug_begin()]

Can't we fix this by using a different (ie: new) lock to protect
cpu_chain?

