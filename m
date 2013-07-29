Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab3G2HPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:15:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab3G2HPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:15:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,767,1367942400"; 
   d="scan'208";a="8055381"
Message-ID: <51F616F2.5040906@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 15:17:06 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
 projids in any user namespace
References: <87txpaph4n.fsf@xmission.com> <1361149870-27732-1-git-send-email-ebiederm@xmission.com> <1361149870-27732-5-git-send-email-ebiederm@xmission.com> <20130219015550.GJ26694@dastard>
In-Reply-To: <20130219015550.GJ26694@dastard>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 15:13:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 15:13:31,
	Serialize complete at 2013/07/29 15:13:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 09:55 AM, Dave Chinner wrote:
> On Sun, Feb 17, 2013 at 05:10:58PM -0800, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> - Convert the userspace value in fa->fsx_projid into a kprojid and
>>   store it in the variable projid.
>> - Verify that xfs can store the projid after it is converted into
>>   xfs's user namespace.
>> - Replace uses of fa->fsx_projid with projid throughout
>>   xfs_ioctl_setattr.
>>
>> Cc: Ben Myers <bpm@sgi.com>
>> Cc: Alex Elder <elder@kernel.org>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
>>  1 files changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 016624b..4a55f50 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -925,6 +925,7 @@ xfs_ioctl_setattr(
>>  	struct xfs_dquot	*gdqp = NULL;
>>  	struct xfs_dquot	*olddquot = NULL;
>>  	int			code;
>> +	kprojid_t		projid = INVALID_PROJID;
>>  
>>  	trace_xfs_ioctl_setattr(ip);
>>  
>> @@ -934,11 +935,20 @@ xfs_ioctl_setattr(
>>  		return XFS_ERROR(EIO);
>>  
>>  	/*
>> -	 * Disallow 32bit project ids when projid32bit feature is not enabled.
>> +	 * Verify the specifid project id is valid.
>>  	 */
>> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
>> -			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
>> -		return XFS_ERROR(EINVAL);
>> +	if (mask & FSX_PROJID) {
>> +		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
>> +		if (!projid_valid(projid))
>> +			return XFS_ERROR(EINVAL);
>> +
>> +		/*
>> +		 * Disallow 32bit project ids when projid32bit feature is not enabled.
>> +		 */
>> +		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
>> +		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
>> +			return XFS_ERROR(EINVAL);
>> +	}
> 
> That looks busted. Why does one use current_user_ns() and the other
> &init_user_ns()?
> 

hmm, through this thread had been stopped discussing for a long time, but I'm working on converting
ids to kids for xfs now, and I want to remove the finial dependenciy for user namespace.

Maybe I can explain why.

projid = make_kprojid(current_user_ns(), fa->fsx_projid);

this code translates the projid in current user namespace to the global kernel projid(kprojid_t).

and from_kprojid(&init_user_ns, projid) here is equal to projid.val, since the real value
of global kernel projid and projid is same in init user namespace.

After translating projid to global kernel projid, we should check if the real value of this
global kernel projid is valid.

I think maybe just modifying from_kprojid(&init_user_ns, projid) to projid.val here is easier
to understand.


Thanks!
