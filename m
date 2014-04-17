Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaDQQWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:22:34 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41008 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaDQQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:22:30 -0400
Message-ID: <534FFFC2.6050601@colorfullife.com>
Date: Thu, 17 Apr 2014 18:22:26 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2] ipc,shm: disable shmmax and shmall by default
References: <1397272942.2686.4.camel@buesod1.americas.hpqcorp.net> <CAHO5Pa3BOgJGCm7NvE4xbm3O1WbRLRBS0pgvErPudypP_iiZ3g@mail.gmail.com>
In-Reply-To: <CAHO5Pa3BOgJGCm7NvE4xbm3O1WbRLRBS0pgvErPudypP_iiZ3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 04/17/2014 12:53 PM, Michael Kerrisk wrote:
> On Sat, Apr 12, 2014 at 5:22 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> From: Davidlohr Bueso <davidlohr@hp.com>
>>
>> The default size for shmmax is, and always has been, 32Mb.
>> Today, in the XXI century, it seems that this value is rather small,
>> making users have to increase it via sysctl, which can cause
>> unnecessary work and userspace application workarounds[1].
>>
>> Instead of choosing yet another arbitrary value, larger than 32Mb,
>> this patch disables the use of both shmmax and shmall by default,
>> allowing users to create segments of unlimited sizes. Users and
>> applications that already explicitly set these values through sysctl
>> are left untouched, and thus does not change any of the behavior.
>>
>> So a value of 0 bytes or pages, for shmmax and shmall, respectively,
>> implies unlimited memory, as opposed to disabling sysv shared memory.
>> This is safe as 0 cannot possibly be used previously as SHMMIN is
>> hardcoded to 1 and cannot be modified.
>>
>> This change allows Linux to treat shm just as regular anonymous memory.
>> One important difference between them, though, is handling out-of-memory
>> conditions: as opposed to regular anon memory, the OOM killer will not
>> free the memory as it is shm, allowing users to potentially abuse this.
>> To overcome this situation, the shm_rmid_forced option must be enabled.
>>
>> [1]: http://rhaas.blogspot.com/2012/06/absurd-shared-memory-limits.html
>>
>> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Of the two proposed approaches (the other being
> marc.info/?l=linux-kernel&m=139730332306185), this looks preferable to
> me, since it allows strange users to maintain historical behavior
> (i.e., the ability to set a limit) if they really want it, so:
>
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> One or two comments below, that you might consider for your v3 patch.
I don't understand what you mean.

After a
     # echo 33554432 > /proc/sys/kernel/shmmax
     # echo 2097152 > /proc/sys/kernel/shmmax

both patches behave exactly identical.

There are only two differences:
- Davidlohr's patch handles
     # echo <really huge number that doesn't fit into 64-bit> > 
/proc/sys/kernel/shmmax
    With my patch, shmmax would end up as 0 and all allocations fail.

- My patch handles the case if some startup code/installer checks
    shmmax and complains if it is below the requirement of the application.

--
     Manfred
