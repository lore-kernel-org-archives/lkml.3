Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3KHRFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:05:39 -0500
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:41913 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757753Ab3KHRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:05:36 -0500
Date: Fri, 8 Nov 2013 17:05:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
In-Reply-To: <20131108163112.GA12853@localhost.localdomain>
Message-ID: <0000014238ad0fb9-aa252280-8e44-48ac-a096-e6dee26e09ea-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org> <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org> <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com> <20131107225049.GC28130@localhost.localdomain> <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
 <20131108163112.GA12853@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.08-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013, Frederic Weisbecker wrote:

> But it looks like it always end up calling a workqueue. May be I missed something though.
>
> Now we can argue that this workqueue seem to create kernel threads, which in turn create other kernel thread (uhh?)
> and I don't know if those inherit the kworker affinity. But from a quick look, it seems to me that
> this is what we want.

Right. The problem is that the affinity cannot be inherited since
usermodehelper may be called from a workqueue or other restricted kernel
context. The main point of the usermodehelper logic is to work itself out
of the restrictions of the context in which is was called to be able to
fork off a kernel thread that then can call a userspace helper program.

I want to restrict on which processors this working out of the limiting
context can occur. It should not occur on low latency processors nor
should user space stuff be run there.

Without this patch we see various processes being sprinkled over all the
processors in the system when usermodehelper is invoked.
