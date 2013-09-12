Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3ILPKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:10:12 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:45981 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3ILPKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:10:10 -0400
Message-ID: <5231D949.8010408@colorfullife.com>
Date: Thu, 12 Sep 2013 17:10:01 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: davidlohr.bueso@hp.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] ipc,msg: shorten critical region in msgsnd
References: <5231B181.7080705@colorfullife.com>
In-Reply-To: <5231B181.7080705@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 09/12/2013 02:20 PM, Manfred Spraul wrote:
>
> And: What about the other users of obtain_object_check?
> exit_sem() is also quite long, but I didn't spot any obvious problems.
>
a) I think semtimed(), msgsnd() and msgrcv() must be fixed:
They either leak memory or tasks can sleep forever.
I haven't checked the shm code, I would expect that there are similar 
problems.

b) There are additional races at least with selinux:
security/selinux/hooks.c
- selinux_sem_semop() accesses sma->sem_perm.security->sid.
- selinux_sem_free_security() does kfree() q_perm.security.

Right now, both operations can happen in parallel -> use after free.

I think the security_xx_yy() calls within ipc/*.c must only be called:
     - after checking _perm.deleted
     - with ipc_perm.lock acquired (to prevent parallel RMID calls).

Davidlohr:
What would be your proposal?

--
     Manfred
