Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaGaKQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaGaKQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:16:34 -0400
Message-ID: <53DA177C.80504@redhat.com>
Date: Thu, 31 Jul 2014 06:16:28 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <1816455.s1k7EgIPj9@vostro.rjw.lan> <53D99D80.8090905@codeaurora.org> <3140593.vs3eOK6CdF@vostro.rjw.lan>
In-Reply-To: <3140593.vs3eOK6CdF@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/30/2014 10:16 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 30, 2014 06:36:00 PM Saravana Kannan wrote:
>> On 07/30/2014 02:40 PM, Rafael J. Wysocki wrote:
>>> On Wednesday, July 30, 2014 10:18:25 AM Prarit Bhargava wrote:
>>>>
>>>> On 07/29/2014 08:03 PM, Rafael J. Wysocki wrote:
>>>>> On Tuesday, July 29, 2014 07:46:02 AM Prarit Bhargava wrote:
>>>
>>> [cut]
>>>
>>>>>> This patch effectively reverts commit 955ef483.
>>
>> The issue reported in this patch is valid. We are seeing that internally 
>> too. I believe I reported it in another thread (within the past month).
>>
>> However, the original patch fixes a real deadlock issue (I'm too tired 
>> to look it up now). We can revet the original, but it's going to bring 
>> back the original issue. I just want to make sure Prarit and Raphael 
>> realize this before proceeding.

Hi Saravana,

Thanks for your input.  I went back to the code and confirmed my original
statement about this patch.

Note: in a previous email I erroneously wrote "buffer->mutex" when I should
have identified the lock as sysfs_mutex.  Sorry 'bout that, and apologies
for any confusion that may have caused.

>From my commit message:

"In any case, the current linux.git code no longer can reproduce the original
failure; the locking in the sysfs release code has changed."

The original patch attempted to fix this deadlock:

A cpufreq driver on a file read did:

    -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
            [<c0055253>] __lock_acquire+0xef3/0x13dc
            [<c0055a79>] lock_acquire+0x61/0xbc
            [<c03ee1f5>] down_read+0x25/0x30
            [<c02f6179>] lock_policy_rwsem_read+0x25/0x34
            [<c02f6edd>] show+0x21/0x58
            [<c00f9c0f>] sysfs_read_file+0x67/0xcc
            [<c00b40a7>] vfs_read+0x63/0xd8
            [<c00b41fb>] sys_read+0x2f/0x50
            [<c000cdc1>] ret_fast_syscall+0x1/0x52

lock(s_active#41) [ which is actually the acquisition of sysfs_mutex ]
lock(&per_cpu(cpu_policy_rwsem, cpu));

and on the governor switch (notably the EXIT of the existing governor), the
opposite occurs

    -> #1 (s_active#41){++++.+}:
            [<c0055a79>] lock_acquire+0x61/0xbc
            [<c00fabf1>] sysfs_addrm_finish+0xc1/0x128
            [<c00f9819>] sysfs_hash_and_remove+0x35/0x64
            [<c00fbe6f>] remove_files.isra.0+0x1b/0x24
            [<c00fbea5>] sysfs_remove_group+0x2d/0xa8
            [<c02f9a0b>] cpufreq_governor_interactive+0x13b/0x35c
            [<c02f61df>] __cpufreq_governor+0x2b/0x8c
            [<c02f6579>] __cpufreq_set_policy+0xa9/0xf8
            [<c02f6b75>] store_scaling_governor+0x61/0x100
            [<c02f6f4d>] store+0x39/0x60
            [<c00f9b81>] sysfs_write_file+0xed/0x114
            [<c00b3fd1>] vfs_write+0x65/0xd8
            [<c00b424b>] sys_write+0x2f/0x50
            [<c000cdc1>] ret_fast_syscall+0x1/0x52


lock(&per_cpu(cpu_policy_rwsem, cpu));
lock(s_active#41) [ which is actually the acquisition of sysfs_mutex ]

The sysfs_mutex no longer blocks in the sysfs path, and I have built with
LOCKDEP on and off to confirm that I do not see any tracebacks or hangs.  I
tested this by doing a few reads of the current governor, and then doing a
governor switch (to at least initiate the LOCKDEP warning).  IIUC the traceback
above that is the way to reproduce this LOCKDEP warning.

IOW ... this deadlock situation no longer exists in the code (at least AFAICT).

Secondly, restoring the locking (and keeping in mind the semantic of the
read-write semaphore, specifically that all reads must be done before the write
lock is acquired by a thread) modifies the code such that the above situation (a
read and a write) can no longer occur in this code.

P.
