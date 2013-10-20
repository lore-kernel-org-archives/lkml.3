Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3JTSA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:00:26 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:58957 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949Ab3JTSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:00:25 -0400
Date: Sun, 20 Oct 2013 18:00:24 +0000
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
 kthreadd
In-Reply-To: <20131017222744.GA3943@localhost.localdomain>
Message-ID: <00000141d7066bf8-4a725d00-cdf3-430f-b6a9-616e180918a9-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131017135509.GB28963@localhost.localdomain> <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com> <20131017160726.GJ28963@localhost.localdomain>
 <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org> <20131017222744.GA3943@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Frederic Weisbecker wrote:

> Makes sense yeah. In fact what I'm mostly concerned about is that we should
> set the affinity of __call_usermodehelper threads through inheritance from
> a parent rather than making it setting its affinity itself. Because in the latter case,
> the usermodehelper thread can run anywhere until it sets its affinity. Whether
> this little window of global affinity is short or not, this defeats the initial purpose
> of this patch that is about isolating CPUs and having them undisturbed.
>
> May be we can do that by setting the affinity of the "khelper" workqueue?

The "parent" for usemodehelper in this case is keventd. The worker queue
item is triggered on a particular processor and thats fine because that is
the result of an OS action or a device irq action. These can already be
avoided. What is not ok is that a process makes a move onto a hardware
thread where we want to have the least OS holdoffs possible.

Setting it via khelper would be fine. Any objections?

