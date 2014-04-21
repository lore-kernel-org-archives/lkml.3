Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaDUOB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:01:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaDUOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:01:56 -0400
Message-ID: <535524BE.7070704@oracle.com>
Date: Mon, 21 Apr 2014 22:01:34 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: Fix wrong error codes being returned
References: <1398074687-26548-1-git-send-email-tuomas.tynkkynen@iki.fi>	<5355132F.4070303@oracle.com> <20140421130931.GB24813@bfoster.bfoster>
In-Reply-To: <20140421130931.GB24813@bfoster.bfoster>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/21 2014 21:09 PM, Brian Foster wrote:
> On Mon, Apr 21, 2014 at 08:46:39PM +0800, Jeff Liu wrote:
>> Hi Tuomas,
>>
>> On 04/21 2014 18:04 PM, Tuomas Tynkkynen wrote:
>>> xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
>>> sign in some cases. While at it, make sure ENOMEM is returned instead of
>>> E2BIG if kmalloc fails.
>>>
>>> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
>>> ---
>>> Compile tested only. For the ERANGE case, I also wonder if it should
>>> be assigning to ops[i].am_error instead of error, and/or have a break.
>>
>> If I understand right, ops[i].am_error is used to save the internal operation result,
>> i.e, xfs_attrmult_attr_get{set}... but error is used for the ioctl call results.
>> Therefore, assign ERANGE to error is compatible with the VFS set{get}xattr syscalls in
>> case of "if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)".
>>
> 
> But we set 'error' in this case and effectively try to continue the operation
> whereas the traditional vfs path returns...

So the error would always be set to ERANGE if one or more attrname is/are invalid.

> 
>> It seems that we don't need to have a break in this case because xfs_attrmulti_by_handle()
>> is used to process multiple attrs.  Hence if a given attrname in ops array is invalid,
>> the am_error will indicate that with ENOATTR or EFAULT...but it should proceed to loop
>> through the left array members.
>>
> 
> Perhaps so if am_error == 0, but it depends on what attr_name contains
> at that point (stale data?). Otherwise, we try to proceed with a
> truncated name. It looks like the consistent thing to do would be set
> am_error to ERANGE and continue (i.e., skip the op and move on to the
> next).

If we continue to process a truncated name in case of MAXNAMELEN, it would return
EFAULT for SET/REMOVE operations, and ENOATTR for GET operation, which would be
set back to am_error, but error still keep as ERANGE which is consistently.


Thanks,
-Jeff
