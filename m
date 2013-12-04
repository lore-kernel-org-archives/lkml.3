Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3LDNsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:48:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab3LDNsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:48:19 -0500
Date: Wed, 4 Dec 2013 14:49:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the
	buggy while_each_thread()
Message-ID: <20131204134917.GA7251@redhat.com>
References: <20131204130351.GA5984@redhat.com> <20131204130409.GA5998@redhat.com> <20131204132828.GC4530@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204132828.GC4530@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Frederic Weisbecker wrote:
>
> On Wed, Dec 04, 2013 at 02:04:09PM +0100, Oleg Nesterov wrote:
>
> > For example, do/while_each_thread() always
> > sees at least one task, while for_each_thread() can do nothing if
> > the whole thread group has died.
>
> Would it be safe to have for_each_thread_continue() instead?

Yes, and no.

Yes, perhaps we will need for_each_thread_continue(). I am not sure
yet. And note that, say, check_hung_uninterruptible_tasks() already
does _continue if fact, although it is still not clear to me if we
actually need this helper.

But no, _continue() can't help if the whole thread group has died,
we simply can not continue.

Note also that _continue() can't be safely used lockless, unless
you verify pid_alive() or something similar.

And,

> Yeah if the conversion needs careful audit, it makes sense to switch incrementally.

Yes. For example the case above. If someone does

	do
		do_something(t);
	while_each_thread(g, t);

we should check that it can tolerate the case when do_something()
won't be called at all, or ensure that this is not possible.

Oleg.

