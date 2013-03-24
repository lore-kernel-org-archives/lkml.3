Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3CXQ40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab3CXQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:56:25 -0400
Date: Sun, 24 Mar 2013 17:54:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 6/7] uretprobes: limit the depth of return probe
	nestedness
Message-ID: <20130324165400.GE17037@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-7-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-7-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
>   Unlike the kretprobes we can't trust userspace, thus must have
> protection from user space attacks,

Plus the user-space have the "unlimited" stack, it looks simply
impossible to handle the deep recursion correctly.

Lets consider the simplest case,

	void probed_func(int x)
	{
		if (--x)
			probed_func(x);
	}

We could add ret_instance->recursion_counter to handle this case and
avoid kmalloc(). But this way we won't be able to implement the new
features like data-pouch.

> this patch limits the return
> probes nestedness as a simple remedy for it.
>   The intention is to have KISS and bare minimum solution for the
> initial implementation in order to not complicate the uretprobes
> code.
>
>   In the future we may come up with more sophisticated solution that
> should remove this depth limitation, however it is not easy task
> and lays beyond this patchset. It should consider things like: breakpoint
> address lays outside the stack and stack growth direction, longjmp,
> sigaltstack... be able to clean up return instances.

I agree. Perhaps we should at least try to do something more clever in
future, but this needs another (certainly nontrivial) series, we should
not mix this with the initial implementation, it should be as simple as
possible.

Oleg.

