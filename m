Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaK1T2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 14:28:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaK1T2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 14:28:20 -0500
Date: Fri, 28 Nov 2014 20:28:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] oom && coredump
Message-ID: <20141128192805.GA3669@redhat.com>
References: <20141127230349.GA25075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230349.GA25075@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Oleg Nesterov wrote:
>
> On 11/27, Oleg Nesterov wrote:
> >
> > So I think the patch below makes sense anyway. Although I should probably
> > split it and remove PT_TRACE_EXIT in 2/2.
>
> So let me send the patches.
>
> David, Michal, could you review and ack/nack these changes explicitly?
>
> Let me repeat once again that this patch doesn't pretend to solve
> all problems, even with the coredumping. And I have to admit that
> my main motivation is 2/2, this PT_TRACE_EXIT check annoys me ;)

Another simple test. cat mtsleep.c:

	#include <unistd.h>
	#include <pthread.h>

	void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	int main(void)
	{
		pthread_t th;

		pthread_create(&th, NULL, tfunc, NULL);
		pause();

		return 0;
	}

Now,

	# echo '|/bin/sleep 1000' >> /proc/sys/kernel/core_pattern
	# echo 10 >> /proc/sys/kernel/core_pipe_limit

	# ./mtsleep &
	# kill -QUIT %1
	# perl -e 'push @_,"x" x 1000_1000 while 1'

Before this series the system hangs and doesn't respond. With these
patches it correctly kills perl.

Oleg.

