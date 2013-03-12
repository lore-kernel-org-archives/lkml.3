Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3CLJ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:29:55 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49957 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3CLJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:29:52 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-3e-513ef58e0b9d
Message-id: <513EF598.5020206@samsung.com>
Date: Tue, 12 Mar 2013 13:30:00 +0400
From: Igor Zhbanov <i.zhbanov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0
 SeaMonkey/2.15
MIME-version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Fix common_audit_data type for smack_inode_unlink() and
 smack_inode_rmdir()
References: <1363002636-14158-1-git-send-email-i.zhbanov@samsung.com>
 <513E124C.3050502@schaufler-ca.com>
In-reply-to: <513E124C.3050502@schaufler-ca.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Zd2+r3aBBicO81hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M/vvHWQvuKlY8f/qZtYHxnHQXIyeHhICJxOPNr5khbDGJC/fW
	s3UxcnEICSxllPhx7iAjhLOaSeLt0bVgVbwCWhKPj84Hs1kEVCV2TV7JAmKzAcX3Pl8BFhcV
	iJeYPP00O0S9oMSPyffAakQEdCT27XkOFOfgYBbwlni3khUkLCyQJPH79gewViGBbIld36Yx
	gpRwChhI7D8bDhJmFrCWWDlpGyOELS+xec1b5gmMArOQLJiFpGwWkrIFjMyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MULC7+sOxqXHrA4xCnAwKvHwavy1DRRiTSwrrsw9xCjBwawkwpux
	2S5QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PI1W08ph7VsyWlDpa9+TC14om543H7bw+apf/Y
	f3PmtzG2e/xAg5VfYXJR3eHzM9k+nlTWZTl0S7/2Yc5h25qyN6fy465oKMtt1A/rSL/29sU1
	hYY1gUfbbj7UUvgz59C9+ivcPwWZPmwUzriRbxw3r692ffZ0/7enTSLKprAU3a9gnF12+qsS
	S3FGoqEWc1FxIgCwXGY4HQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

Casey Schaufler wrote:

> On 3/11/2013 4:50 AM, Igor Zhbanov wrote:
>> This patch fixes kernel Oops because of wrong common_audit_data type
>> in smack_inode_unlink() and smack_inode_rmdir().
> This patch does not apply to any tree I have. The lines:
>
> 	smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
>
> that the patch is deleting are not present. Can you make
> sure that the patch applies to Linus' tree and resubmit?

My patch is applied against linux-next:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/security/smack/smack_lsm.c

And the patch successfully applies to linux-3.8.2 too.
What tree you have?

> Thank you.
>> When SMACK security module is enabled and SMACK logging is on (/smack/logging
>> is not zero) and you try to delete the file which
>> 1) you cannot delete due to SMACK rules and logging of failures is on
>> or
>> 2) you can delete and logging of success is on,
>>
>> you will see following:
>>
>> 	Unable to handle kernel NULL pointer dereference at virtual address 000002d7
>>
>> 	[<...>] (strlen+0x0/0x28)
>> 	[<...>] (audit_log_untrustedstring+0x14/0x28)
>> 	[<...>] (common_lsm_audit+0x108/0x6ac)
>> 	[<...>] (smack_log+0xc4/0xe4)
>> 	[<...>] (smk_curacc+0x80/0x10c)
>> 	[<...>] (smack_inode_unlink+0x74/0x80)
>> 	[<...>] (security_inode_unlink+0x2c/0x30)
>> 	[<...>] (vfs_unlink+0x7c/0x100)
>> 	[<...>] (do_unlinkat+0x144/0x16c)
>>
>> The function smack_inode_unlink() (and smack_inode_rmdir()) need
>> to log two structures of different types. First of all it does:
>>
>> 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
>> 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
>>
>> This will set common audit data type to LSM_AUDIT_DATA_DENTRY
>> and store dentry for auditing (by function smk_curacc(), which in turn calls
>> dump_common_audit_data(), which is actually uses provided data and logs it).
>>
>> 	/*
>> 	 * You need write access to the thing you're unlinking
>> 	 */
>> 	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE, &ad);
>> 	if (rc == 0) {
>> 		/*
>> 		 * You also need write access to the containing directory
>> 		 */
>>
>> Then this function wants to log anoter data:
>>
>> 		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
>> 		smk_ad_setfield_u_fs_inode(&ad, dir);
>>
>> The function sets inode field, but don't change common_audit_data type.
>>
>> 		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
>> 	}
>>
>> So the dump_common_audit() function incorrectly interprets inode structure
>> as dentry, and Oops will happen.
>>
>> This patch reinitializes common_audit_data structures with correct type.
>> Also I removed unneeded
>> 	smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
>> initialization, because both dentry and inode pointers are stored
>> in the same union.
>>
>> Signed-off-by: Igor Zhbanov <i.zhbanov@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   security/smack/smack_lsm.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index fa64740..d52c780 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -654,7 +654,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
>>   		/*
>>   		 * You also need write access to the containing directory
>>   		 */
>> -		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
>> +		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
>>   		smk_ad_setfield_u_fs_inode(&ad, dir);
>>   		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
>>   	}
>> @@ -685,7 +685,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>>   		/*
>>   		 * You also need write access to the containing directory
>>   		 */
>> -		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
>> +		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
>>   		smk_ad_setfield_u_fs_inode(&ad, dir);
>>   		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
>>   	}

-- 
Best regards,
Igor Zhbanov,
Sub-Project Leader,
phone: +7 (495) 797 25 00 ext 3981
e-mail: i.zhbanov@samsung.com

Mobile group, Moscow R&D center, Samsung Electronics
12 Dvintsev street, building 1
127018, Moscow, Russian Federation

