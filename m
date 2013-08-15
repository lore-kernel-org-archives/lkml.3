Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3HOUBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab3HOUBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:01:22 -0400
Message-ID: <520D3388.4090007@redhat.com>
Date: Thu, 15 Aug 2013 16:01:12 -0400
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sasikantha Babu <sasikanth.v19@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc/mq: Do not vaild queue attributes default/ceiling
 value If the user pass attr as NULL
References: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com>
In-Reply-To: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com>
X-Enigmail-Version: 1.5.1
OpenPGP: id=0E572FDD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:09 AM, Sasikantha Babu wrote:
> Kernel should not validate queue attributes default/ceiling value while
> creating a mqueue, if user pass attr as NULL. Otherwise In worst case
> If the validation fails then sys_mq_open returns -EINVAL/-EOVERFLOW
> which will make user clueless about reason for the failure.
> 
> Signed-off-by: Sasikantha Babu <sasikanth.v19@gmail.com>
> ---
>  ipc/mqueue.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index ae1996d..04ece80 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -748,9 +748,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct inode *dir,
>  					 ipc_ns->mq_msg_default);
>  		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
>  					  ipc_ns->mq_msgsize_default);
> -		ret = mq_attr_ok(ipc_ns, &def_attr);
> -		if (ret)
> -			return ERR_PTR(ret);
>  	}
>  
>  	mode &= ~current_umask();
> 

Nak.  The only two instances where mq_attr_ok() will reject the default
values are if either of the size or num are <= 0 or if the possible
total size of the struct is large enough to overflow the memory
accounting.  Since we can't allow the memory accounting to overflow no
matter what the defaults are or what the user requests, we can't skip
that check.  And we don't allow 0 element or 0 size queues, so we can't
skip that check.  If the user tweaks the default knobs in the kernel
such that the default values result in an impossible allocation, that's
the user's fault.  You don't allow the kernel to create a known broken
queue just because someone twiddled the default values to something invalid.

There are two possible different fixes:

1) Change this code to recognize that the default values resulted in an
error and print out a kernel message for the user to find

or

2) Change the memory accounting such that we don't check accounting
overflow on allocation but instead check it on msg queue and allow
people to create really large queues that they can fill up until they
hit the memory allocation overflow and then start rejecting queueing any
new messages to the queue until some of the old messages have been
removed and space freed up.  If that were done, then the overflow checks
in mq_attr_ok could go away.  But this would add some (although not a
lot) of overhead on the msg queue path.
