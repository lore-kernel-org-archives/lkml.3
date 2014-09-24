Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaIXHTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:19:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:56544 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIXHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:19:46 -0400
Message-ID: <5422708D.20601@parallels.com>
Date: Wed, 24 Sep 2014 11:19:41 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] fuse: fix synchronous case of fuse_file_put()
References: <20140821160304.11005.15166.stgit@localhost.localdomain>	<20140821160916.11005.37344.stgit@localhost.localdomain>	<CAJfpegsWoaqR1vQRq8QpYdwUX9Ace9XTe77eOkOUy2VyHUeEdQ@mail.gmail.com>	<5411CA4F.7040006@parallels.com> <CAJfpegs3v9EVzoPMgX9_JV+-Y3qy7oWD8tceSi+tnmo=_b=a7A@mail.gmail.com>
In-Reply-To: <CAJfpegs3v9EVzoPMgX9_JV+-Y3qy7oWD8tceSi+tnmo=_b=a7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 12:19 PM, Miklos Szeredi wrote:
> On Thu, Sep 11, 2014 at 6:14 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>
>> I really need your help to proceed with this patch. Could you please explain
>> what those places are where we should allow interruption.
>>
>> BTW, as for "just an optimization", I've recently noticed that __fput()
>> calls locks_remove_file(). So guarantees provided by the patch-set are on
>> the same level as flock(2) behaviour.
> SIGKILL trumps that.  At least that's what I think, and that's what
> NFS currently does as well, AFAICS.
>
>>> Also fuse really should distinguish fatal and non-fatal interruptions
>>> and handle them accordingly...
>>
>> And elaborate on this concern, please.
> Requests have two states where they stay for any significant amount of
> time: PENDING (queued to userspace) and SENT (in userspace).
>
> Currently we do the following for interrupted requests:
>
> PENDING:
>     - non-fatal signal: do nothing
>     - fatal signal: dequeue and return -EINTR, unless force is set
>
> SENT:
>     - send INTERRUPT request to userspace
>
> This is fine, but fatal interrupts should be able to abort SENT and
> forced requests as well without having to wait for the userspace
> reply.  This is what I was referring to.

Thank you for detailed clarification, that's much clearer now. If I 
understood it right, fatal signals must abort *any* request in *any* 
state. The only difference between forced and not forced requests is 
that forced ones must be eventually delivered to userspace in all cases 
(even if they were in PENDING state when we were interrupted and we 
returned -EINTR).

The thing that bothers me is the net result of these changes. Yes, 
end-user will be able to interrupt its app by SIGKIILL if it is waiting 
in request_wait_answer(). But there are many other places where kernel 
fuse waits for something dependent on userspace. Do you think we have to 
make those places interruptible as well?

>
> This would not be difficult, were it not for i_mutex and
> s_vfs_rename_mutex being held by some operations.   For correctness,
> we can't release these while a reply is not received, since the
> locking expecations of the userspace filesystem would not be met.
> This can be solved by adding shadow locks to fuse that we hold onto
> even after the request is interrupted.

Shadow locking seems to be not enough. For example, we have to postpone 
FUSE_RELEASE until all interrupted synchronous I/O is ACKed by 
userspace. And similarly we shouldn't surprise userspace by FUSE_DESTROY 
if any requests are still in-flight. May be there are other hidden 
dependencies that don't come to mind now.

Thanks,
Maxim

