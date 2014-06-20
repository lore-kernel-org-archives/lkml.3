Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaFTXhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:37:24 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:29014 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaFTXhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:37:22 -0400
Message-ID: <53A4C5AE.9020209@hp.com>
Date: Fri, 20 Jun 2014 19:37:18 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] selinux: no recursive read_lock of policy_rwlock in security_genfs_sid()
References: <1403286324-34421-1-git-send-email-Waiman.Long@hp.com> <53A4742E.1090909@tycho.nsa.gov>
In-Reply-To: <53A4742E.1090909@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 01:49 PM, Stephen Smalley wrote:
> On 06/20/2014 01:45 PM, Waiman Long wrote:
>> With introduction of fair queued rwlock, recursive read_lock() may hang
>> the offending process if there is a write_lock() somewhere in between.
>>
>> With recursive read_lock checking enabled, the following error was
>> reported:
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 3.16.0-rc1 #2 Tainted: G            E
>> ---------------------------------------------
>> load_policy/708 is trying to acquire lock:
>>   (policy_rwlock){.+.+..}, at: [<ffffffff8125b32a>] security_genfs_sid+0x3a/0x170
>>
>> but task is already holding lock:
>>   (policy_rwlock){.+.+..}, at: [<ffffffff8125b48c>] security_fs_use+0x2c/0x110
>>
>> other info that might help us debug this:
>>   Possible unsafe locking scenario:
>>
>>         CPU0
>>         ----
>>    lock(policy_rwlock);
>>    lock(policy_rwlock);
>>
>> This patch fixes the occurrence of recursive read_lock() of
>> policy_rwlock in security_genfs_sid() by adding a 5th argument to
>> indicate if the rwlock has been taken.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> Thanks, but I'd prefer to instead create a static helper function in
> services.c that does not take the lock at all, use that function from
> security_fs_use, and leave the extern function unmodified.

On second thought, this is exactly what I want to change the patch. I 
will send out a new one later today.

-Longman
