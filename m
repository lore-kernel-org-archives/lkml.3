Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaBYVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:09:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaBYVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:09:27 -0500
Date: Tue, 25 Feb 2014 13:09:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Dwight Engen <dwight.engen@oracle.com>, Eric Paris <eparis@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Michal Marek <mmarek@suse.cz>, Mike Frysinger <vapier@gentoo.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Landley <rob@landley.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make allnoconfig disable options behind
 EMBEDDED and EXPERT
Message-Id: <20140225130925.813f29105079cbd3d5a9ba30@linux-foundation.org>
In-Reply-To: <20140224022021.GA12665@thin>
References: <20140224022021.GA12665@thin>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Feb 2014 18:20:26 -0800 Josh Triplett <josh@joshtriplett.org> wrote:

> "make allnoconfig" exists to ease testing of minimal configurations.
> Documentation/SubmitChecklist includes a note to test with allnoconfig.
> This helps catch missing dependencies on common-but-not-required
> functionality, which might otherwise go unnoticed.
> 
> However, allnoconfig still leaves many symbols enabled, because they're
> hidden behind CONFIG_EMBEDDED or CONFIG_EXPERT.  For instance,
> allnoconfig still has CONFIG_PRINTK and CONFIG_BLOCK enabled, so drivers
> don't typically get build-tested with those disabled.
> 
> To address this, introduce a new Kconfig option "allnoconfig_y", used on
> symbols which only exist to hide other symbols.  Set it on
> CONFIG_EMBEDDED (which then selects CONFIG_EXPERT).  allnoconfig will
> then disable all the symbols hidden behind those.

Now look what you've done!

kernel/sched/core.c: In function 'pick_next_task':
kernel/sched/core.c:2613: warning: control reaches end of non-void function

static inline struct task_struct *
pick_next_task(struct rq *rq, struct task_struct *prev)
{
	const struct sched_class *class;
	struct task_struct *p;

	/*
	 * Optimization: we know that if all tasks are in
	 * the fair class we can call that function directly:
	 */
	if (likely(prev->sched_class == &fair_sched_class &&
		   rq->nr_running == rq->cfs.h_nr_running)) {
		p = fair_sched_class.pick_next_task(rq, prev);
		if (likely(p))
			return p;
	}

	for_each_class(class) {
		p = class->pick_next_task(rq, prev);
		if (p)
			return p;
	}

	BUG(); /* the idle class will always have a runnable task */
}

akpm3:/usr/src/25> grep CONFIG_BUG .config
# CONFIG_BUG is not set
