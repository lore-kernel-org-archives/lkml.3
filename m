Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3AKHqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:46:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53397 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3AKHqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:46:46 -0500
Message-ID: <50EFC356.10908@gmail.com>
Date: Fri, 11 Jan 2013 13:16:30 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: Abhijit Pawar <abhi.c.pawar@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] fs/xfs remove obsolete simple_strto<foo>
References: <1357740282-2377-1-git-send-email-abhi.c.pawar@gmail.com> <50EFB2FE.2000307@oracle.com>
In-Reply-To: <50EFB2FE.2000307@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 12:06 PM, Jeff Liu wrote:
> On 01/09/2013 10:04 PM, Abhijit Pawar wrote:
>> This patch replaces usages of obsolete simple_strtoul with kstrtoint in xfs_args and suffix_strtoul.
>>
>> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
>> ---
>>  fs/xfs/xfs_super.c |   29 +++++++++++++++++++----------
>>  1 files changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index ab8839b..c407121 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -139,9 +139,9 @@ static const match_table_t tokens = {
>>  
>>  
>>  STATIC unsigned long
>> -suffix_strtoul(char *s, char **endp, unsigned int base)
>> +suffix_kstrtoint(char *s, unsigned int base, int *res)
>>  {
>> -	int	last, shift_left_factor = 0;
>> +	int	last, shift_left_factor = 0, _res;
>>  	char	*value = s;
>>  
>>  	last = strlen(value) - 1;
>> @@ -158,7 +158,10 @@ suffix_strtoul(char *s, char **endp, unsigned int base)
>>  		value[last] = '\0';
>>  	}
>>  
>> -	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
>> +	if (kstrtoint(s, base, &_res))
>> +		return -EINVAL;
>> +	*res = _res << shift_left_factor;
>> +	return 0;
>>  }
>>  
>>  /*
>> @@ -174,7 +177,7 @@ xfs_parseargs(
>>  	char			*options)
>>  {
>>  	struct super_block	*sb = mp->m_super;
>> -	char			*this_char, *value, *eov;
>> +	char			*this_char, *value;
>>  	int			dsunit = 0;
>>  	int			dswidth = 0;
>>  	int			iosize = 0;
>> @@ -230,14 +233,16 @@ xfs_parseargs(
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			mp->m_logbufs = simple_strtoul(value, &eov, 10);
>> +			if (kstrtoint(value, 10, &mp->m_logbufs))
>> +				return EINVAL;
>>  		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
>>  			if (!value || !*value) {
>>  				xfs_warn(mp, "%s option requires an argument",
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			mp->m_logbsize = suffix_strtoul(value, &eov, 10);
>> +			if (suffix_kstrtoint(value, 10, &mp->m_logbsize))
>> +				return EINVAL;
>>  		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
>>  			if (!value || !*value) {
>>  				xfs_warn(mp, "%s option requires an argument",
>> @@ -266,7 +271,8 @@ xfs_parseargs(
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			iosize = simple_strtoul(value, &eov, 10);
>> +			if (kstrtoint(value, 10, &iosize))
>> +				return EINVAL;
>>  			iosizelog = ffs(iosize) - 1;
>>  		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
>>  			if (!value || !*value) {
>> @@ -274,7 +280,8 @@ xfs_parseargs(
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			iosize = suffix_strtoul(value, &eov, 10);
>> +			if (suffix_kstrtoint(value, 10, &iosize))
>> +				return EINVAL;
>>  			iosizelog = ffs(iosize) - 1;
>>  		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
>>  			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
>> @@ -296,14 +303,16 @@ xfs_parseargs(
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			dsunit = simple_strtoul(value, &eov, 10);
>> +			if (kstrtoint(value, 10, &dsunit))
>> +				return EINVAL;
>>  		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
>>  			if (!value || !*value) {
>>  				xfs_warn(mp, "%s option requires an argument",
>>  					this_char);
>>  				return EINVAL;
>>  			}
>> -			dswidth = simple_strtoul(value, &eov, 10);
>> +			if (kstrtoint(value, 10, &dswidth))
>> +				return EINVAL;
>>  		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
>>  			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
>>  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
>>
> checkpatch.pl show warning if we return EINVAL as below:
> WARNING: return of an errno should typically be -ve (return -EINVAL)
> 
> Can we just ignore such code style issue?
I think we can.
Ben?
> 
> Thanks,
> -Jeff
> 


-- 
-
Abhijit
