Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3JQW2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:28:05 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47244 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3JQW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:27:50 -0400
Date: Fri, 18 Oct 2013 00:27:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-ID: <20131017222744.GA3943@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
 <20131017135509.GB28963@localhost.localdomain>
 <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
 <20131017160726.GJ28963@localhost.localdomain>
 <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017105026.451ce2782d573c0b7dfbbc5d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:50:26AM -0700, Andrew Morton wrote:
> On Thu, 17 Oct 2013 18:07:28 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Couldn't we instead make kthread children (those created with kthread_create()) to inherit
> > kthread initial affinity? Currently kthread's children have cpu_all_mask. We could change
> > that behaviour. This way the initial kthread affinity could be inherited all along.
> 
> I'm wondering if it's clean/logical to tie usermodehelper affinity to
> kthreadd affinity at all.  It's certainly convenient, but they're
> distinct concepts.  What is the reason to not have a separate control
> for usermodehelper cpus-allowed?

Makes sense yeah. In fact what I'm mostly concerned about is that we should
set the affinity of __call_usermodehelper threads through inheritance from
a parent rather than making it setting its affinity itself. Because in the latter case,
the usermodehelper thread can run anywhere until it sets its affinity. Whether
this little window of global affinity is short or not, this defeats the initial purpose
of this patch that is about isolating CPUs and having them undisturbed.

May be we can do that by setting the affinity of the "khelper" workqueue?
