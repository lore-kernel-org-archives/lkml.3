Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3G3GcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:32:18 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:58280 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752220Ab3G3GcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:32:17 -0400
X-QQ-mid: bizesmtp1t1375165929t393t037
X-QQ-SSF: 01400000000000F0FPF2000A0000000
Message-ID: <51F75E90.2090908@tnsoft.com.cn>
Date: Tue, 30 Jul 2013 14:34:56 +0800
From: Dennis Chen <xschen@tnsoft.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] race condition fixing in sysfs_create_dir
References: <51F24612.6030509@tnsoft.com.cn> <51F24864.7070306@tnsoft.com.cn> <20130726133856.GD3013@htj.dyndns.org>
In-Reply-To: <20130726133856.GD3013@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-FName: 1F6B3B272C454818BBAA4513DE3EA50D
X-QQ-LocalIP: 163.177.66.155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 09:38 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Jul 26, 2013 at 05:59:00PM +0800, Dennis Chen wrote:
>> On 07/26/2013 05:49 PM, Dennis Chen wrote:
>>
>>> The patch is trying its best to avoid creating a dir under a parent dir which is removing from
>>> the system:
>>>      PATH0 (create a dir under 'PARENT/...')         PATH1 (remove the 'PARENT/...')
>>>           sysfs_create_dir() {                         sysfs_remove_dir() {
>>>           ...                                          ...
>>>           if (kobj->parent)                            spin_lock(&sysfs_assoc_lock);
>>>          parent_sd = kobj->parent->sd;  <----- kobj->sd = NULL;
>>>       else                                         spin_unlock(&sysfs_assoc_lock);
>>>          parent_sd = &sysfs_root;
>>> Suppose PATH1 enter the critical section first, then PATH0 begin to execute before kobj->sd
>>> has been reset to NULL, possibly PATH0 will get a non-NULL parent_sd since lack of the
>>> sysfs_assoc_lock protection in PATH0. In this case, PATH0 think it has a valid parent_sd which
>>> can be freed by PATH1 in the followed, refer to the comments in the patch. Maybe we need
>>> to figure out a perfect solution to solve the race condition, although the codes in question are
>>> in slow path...
> I don't think sysfs is supposed to handle multiple actors trying to
> populate and destroy the directory at the same time at all, so this
> seems kinda moot.  Do you have a case where this actually matters?
>
> Thanks.
>
hello,Tejun. Nice. But seems I still have different opinion :). If you look at the 'sysfs_do_create_link_sd()'
code, you will find a comment "target->sd can go away beneath us but is protected with sysfs_assoc_lock.
Fetch target_sd from it", don't you think the sysfs_create_dir is the same as the sysfs_do_create_link_sd()
essentially? if the answer is yes meaning the parent dir can go away when its sub-dir is creating by sysfs_create_dir,
then the similar action should be taken as sysfs_create_link does. right?

  

