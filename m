Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaFWOaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:30:30 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:40360 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaFWOa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:30:28 -0400
Message-ID: <53A83A01.2070402@hp.com>
Date: Mon, 23 Jun 2014 10:30:25 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2] selinux: no recursive read_lock of policy_rwlock in
 security_genfs_sid()
References: <1403310623-37002-1-git-send-email-Waiman.Long@hp.com> <53A81ECD.1010001@tycho.nsa.gov>
In-Reply-To: <53A81ECD.1010001@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 08:34 AM, Stephen Smalley wrote:
> On 06/20/2014 08:30 PM, Waiman Long wrote:
>> v1->v2:
>>   - Add an internal helper to switch on/off lock acquisition instead
>>     of modifying the external API.
>>
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
>>   (policy_rwlock){.+.+..}, at: [<ffffffff8125b32a>]
>> security_genfs_sid+0x3a/0x170
>>
>> but task is already holding lock:
>>   (policy_rwlock){.+.+..}, at: [<ffffffff8125b48c>]
>> security_fs_use+0x2c/0x110
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
>> policy_rwlock in security_genfs_sid() by adding a helper function
>> which has a 5th argument to indicate if the rwlock has been taken.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>   security/selinux/ss/services.c |   36 ++++++++++++++++++++++++++++--------
>>   1 files changed, 28 insertions(+), 8 deletions(-)
>>
>> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
>> index 4bca494..5f4c1f3 100644
>> --- a/security/selinux/ss/services.c
>> +++ b/security/selinux/ss/services.c
>> @@ -2277,20 +2277,22 @@ out:
>>   }
>>
>>   /**
>> - * security_genfs_sid - Obtain a SID for a file in a filesystem
>> + * __security_genfs_sid - Helper to obtain a SID for a file in a filesystem
>>    * @fstype: filesystem type
>>    * @path: path from root of mount
>>    * @sclass: file security class
>>    * @sid: SID for path
>> + * @locked: true if policy_rwlock taken
>>    *
>>    * Obtain a SID to use for a file in a filesystem that
>>    * cannot support xattr or use a fixed labeling behavior like
>>    * transition SIDs or task SIDs.
>>    */
>> -int security_genfs_sid(const char *fstype,
>> -		       char *path,
>> -		       u16 orig_sclass,
>> -		       u32 *sid)
>> +static inline int __security_genfs_sid(const char *fstype,
>> +				       char *path,
>> +				       u16 orig_sclass,
>> +				       u32 *sid,
>> +				       int locked)
>>   {
>>   	int len;
>>   	u16 sclass;
>> @@ -2301,7 +2303,8 @@ int security_genfs_sid(const char *fstype,
>>   	while (path[0] == '/'&&  path[1] == '/')
>>   		path++;
>>
>> -	read_lock(&policy_rwlock);
>> +	if (!locked)
>> +		read_lock(&policy_rwlock);
> I believe that this kind of conditional lock-taking is frowned upon in
> the kernel, although I could be wrong.  I think it would be cleaner to
> instead just unconditionally take and release the lock around the call
> to this helper in security_genfs_sid(), and not do so around the call to
> it from security_fs_use().

Thank for the comments. Will send out a new patch with the suggested change.

-Longman

