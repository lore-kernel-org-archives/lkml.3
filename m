Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaENSAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:00:32 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39239 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaENSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:00:29 -0400
Message-ID: <5373AF39.7030406@colorfullife.com>
Date: Wed, 14 May 2014 20:00:25 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ipc,msg: loosen check for full queue
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-6-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400012857-11733-6-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr, Hi Andrew,

On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> When sending a message, we must guarantee that there will be
> enough room in the queue to add it, otherwise wait until space
> becomes available -- which requires blocking the calling task.
> Currently, this relies meeting both of the following conditions:
>
> (i) The new msg size + current size is lower than the queue's max size.
> (ii) The current amount of messages in the queue + 1 (this msg) is lower
>       than the queue's max size.
>
> While (i) is obvious and well documented in the msgsnd(2) manpage, the
> second one is far more ambiguous and does not serve the purpose, as we do
> not control the amount of messages in the queue (unlike posix queues do).
> Thus remove (ii) and loosen how we check for space.
I know that (ii) is undocumented and not part of SUS, but I think it is 
required:
Otherwise it would be possible to use up an infinite amount of locked 
memory by sending 0-byte messages.

I added it some long time ago, and at that time I didn't check what the 
other sysv msg implementation were doing.

 From a quick search:

FreeBSD:
- Optional: RACCT_MSGQQUEUED
- Always: The number of messages is limited due to a global array 
(limited to MSGTQL entries: array msghdrs, free list  free_msghdrs)

http://fxr.watson.org/fxr/source/kern/sysv_msg.c

Opensolaris:
- Also a limit of the number of messages:
http://fxr.watson.org/fxr/source/common/os/msg.c?v=OPENSOLARIS;im=bigexcerpts#L1166

- it appears that it is related to MSGTQL:
http://fxr.watson.org/fxr/source/common/os/msg.c?v=OPENSOLARIS;im=bigexcerpts#L652

I.e.: We cannot remove the check unless we add another mechanism that 
limits the number of messages.

--
     Manfred
