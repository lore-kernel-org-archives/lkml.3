Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3DAHnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:43:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:48983 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab3DAHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:43:15 -0400
Message-ID: <51593A03.4050407@parallels.com>
Date: Mon, 1 Apr 2013 11:40:51 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <hhuang@redhat.com>, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org> <20130326192852.GA25899@redhat.com> <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org> <20130329161746.GA8391@redhat.com> <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
In-Reply-To: <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.03.2013 22:43, Linus Torvalds пишет:
> On Fri, Mar 29, 2013 at 9:17 AM, Dave Jones<davej@redhat.com>  wrote:
>> >
>> >Now that I have that reverted, I'm not seeing msgrcv traces any more, but
>> >I've started seeing this..
>> >
>> >general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Do you have CONFIG_CHECKPOINT_RESTORE enabled? Does it go away if you
> disable it?
>
> I think I foud at least one bug in the MSG_COPY stuff: it leaks the
> "copy" allocation if
>
>      mode == SEARCH_LESSEQUAL
>

Hello, Linus.
Sorry, but I don't see copy allocation leak.
Dummy message is allocated always in msgflg has MSG_COPY flag being set.
Also prepare_copy() use msgtyp as a message number to copy and thus set it to 0.

> but maybe I'm misreading it. And that shouldn't cause the problem you
> see, but it's indicative of how badly tested and thought through the
> MSG_COPY code is.
>
> Totally UNTESTED leak fix appended. Stanislav?
>

I don't see, how this patch can help. And we should not release it until copy is
done in msg_handler, because msg is equal to copy.

Dummy copy message is release either by free_copy() (if msg is error) or
free_msg().

But there are two issues here definitely:

1) Poor SELinux support for message
copying. This issue was addressed by Stephen Smalley here:

https://lkml.org/lkml/2013/2/6/663

But look like he didn't sent the patch to Andrew.

2) Copy leak and queue corruption in case of
copy message wasn't found (this was mentioned by Peter in another thread; thanks for
catching this, Peter!), because msg will be a valid pointer and all the "message copy"
clean up logic doesn't work.

I like Peter's cleanup and fix series.  But if it looks like too much changes
for this old code, I have another small patch, which should fix the issue:

     ipc: set msg back to -EAGAIN if copy wasn't performed

     Make sure, that msg pointer is set back to error value in case of MSG_COPY
     flag is set and desired message to copy wasn't found. This garantees, that msg
     is either a error pointer or a copy address.
     Otherwise last message in queue will be freed without unlinking from queue
     (which leads to memory corruption) plus dummy allocated copy won't be released.

     Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

diff --git a/ipc/msg.c b/ipc/msg.c
index 31cd1bf..fede1d0 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -872,6 +872,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
                                                         goto out_unlock;
                                                 break;
                                         }
+                                       msg = ERR_PTR(-EAGAIN);
                                 } else
                                         break;
                                 msg_counter++;

>                       Linus
>
>
> patch.diff
>
>
>   ipc/msg.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 31cd1bf6af27..b841508556cb 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -870,6 +870,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
>   						msg = copy_msg(msg, copy);
>   						if (IS_ERR(msg))
>   							goto out_unlock;
> +						copy = NULL;
>   						break;
>   					}
>   				} else
> @@ -976,10 +977,9 @@ out_unlock:
>   			break;
>   		}
>   	}
> -	if (IS_ERR(msg)) {
> -		free_copy(copy);
> +	free_copy(copy);
> +	if (IS_ERR(msg))
>   		return PTR_ERR(msg);
> -	}
>
>   	bufsz = msg_handler(buf, msg, bufsz);
>   	free_msg(msg);
>


-- 
Best regards,
Stanislav Kinsbursky
