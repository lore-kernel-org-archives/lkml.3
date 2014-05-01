Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaEAPU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:20:59 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52574 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaEAPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:20:57 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V1 08/22] vfs: Add permission flags for setting file attributes
In-Reply-To: <20140429001723.GQ15995@dastard>
References: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1398615293-22931-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20140429001723.GQ15995@dastard>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 01 May 2014 20:50:46 +0530
Message-ID: <87ioppbk4x.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050115-8256-0000-0000-00000CE2D8AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Sun, Apr 27, 2014 at 09:44:39PM +0530, Aneesh Kumar K.V wrote:
>> From: Andreas Gruenbacher <agruen@kernel.org>
>> 
>> Some permission models can allow processes to take ownership of a file,
>> change the file permissions, and set the file timestamps.  Introduce new
>> permission mask flags and check for those permissions in
>> inode_change_ok().
>> 
>> Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  fs/attr.c          | 68 ++++++++++++++++++++++++++++++++++++++++++++----------
>>  fs/namei.c         |  2 +-
>>  include/linux/fs.h |  4 ++++
>>  3 files changed, 61 insertions(+), 13 deletions(-)
>> 
>> diff --git a/fs/attr.c b/fs/attr.c
>> index 1d158c972442..e468d4f2dca8 100644
>> --- a/fs/attr.c
>> +++ b/fs/attr.c
>> @@ -16,6 +16,54 @@
>>  #include <linux/evm.h>
>>  #include <linux/ima.h>
>>  
>> +static int richacl_change_ok(struct inode *inode, int mask)
>> +{
>
> acl_change_ok()


Will update.

>
>> +	if (!IS_RICHACL(inode))
>> +		return -EPERM;
>> +
>> +	if (inode->i_op->permission)
>> +		return inode->i_op->permission(inode, mask);
>> +
>> +	return check_acl(inode, mask);
>> +}
>> +
>> +static bool inode_uid_change_ok(struct inode *inode, kuid_t ia_uid)
>> +{
>> +	if (uid_eq(current_fsuid(), inode->i_uid) &&
>> +	    uid_eq(ia_uid, inode->i_uid))
>> +		return true;
>> +	if (uid_eq(current_fsuid(), ia_uid) &&
>> +	    richacl_change_ok(inode, MAY_TAKE_OWNERSHIP) == 0)
>> +		return true;
>> +	if (capable(CAP_CHOWN))
>> +		return true;
>> +	return false;
>> +}
>> +
>> +static bool inode_gid_change_ok(struct inode *inode, kgid_t ia_gid)
>> +{
>> +	int in_group = in_group_p(ia_gid);
>> +	if (uid_eq(current_fsuid(), inode->i_uid) &&
>> +	    (in_group || gid_eq(ia_gid, inode->i_gid)))
>> +		return true;
>> +	if (in_group && richacl_change_ok(inode, MAY_TAKE_OWNERSHIP) == 0)
>> +		return true;
>> +	if (capable(CAP_CHOWN))
>> +		return true;
>> +	return false;
>> +}
>> +
>> +static bool inode_owner_permitted_or_capable(struct inode *inode, int mask)
>> +{
>> +	if (uid_eq(current_fsuid(), inode->i_uid))
>> +		return true;
>> +	if (richacl_change_ok(inode, mask) == 0)
>> +		return true;
>> +	if (inode_capable(inode, CAP_FOWNER))
>> +		return true;
>> +	return false;
>> +}
>
> Some comments on when and why these need to be used instead of
> inode_owner_or_capable() would be useful. I can see people getting
> this wrong in future.
>

Ok.

-aneesh

