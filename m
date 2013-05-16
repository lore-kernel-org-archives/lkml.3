Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3EPEtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:49:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38058 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3EPEtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:49:35 -0400
X-Spam-Score: -100.8
Message-ID: <5194652B.4010209@asianux.com>
Date: Thu, 16 May 2013 12:48:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: need call device_remove_file() when
 failure occurs after called device_create_file()
References: <51922D30.8000809@asianux.com> <20130514151752.GB6795@mtj.dyndns.org> <5192EFE0.4040903@asianux.com> <5193277A.3040506@asianux.com> <20130515212228.GE26222@htj.dyndns.org> <51945384.9060308@asianux.com> <51945D90.8010600@asianux.com>
In-Reply-To: <51945D90.8010600@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 12:16 PM, Chen Gang wrote:
> On 05/16/2013 11:33 AM, Chen Gang wrote:
>> On 05/16/2013 05:22 AM, Tejun Heo wrote:
>>> On Wed, May 15, 2013 at 02:13:14PM +0800, Chen Gang wrote:
>>>>
>>>> In workqueue_sysfs_register(), when failure occurs after called
>>>> device_create_file(), need call device_remove_file() to release the
>>>> related resources, then call device_unregister().
>>>>
>>>> Or it will cause issue.
>>>>
>>>> For individual 'device_attributs' (just like our case), need call
>>>> device_remove_file() explictly and then call device_unregister(),
>>>> please reference drivers/base/*.c (e.g node.c or cpu.c).
>>>
>>> Hmm... isn't this already taken care of by __sysfs_remove_dir() which
>>> device_unregister() calls?  That function removes all non-directory
>>> files under the directory being removed.
>>>
>>

__sysfs_remove_dir() remove all related things, but not deref the count.

For __sysfs_remove_dir() ->
  ...
  sysfs_addrm_start()
  ...
  while() {
    ...
    sysfs_remove_one()  (not deref the related file)
  }
  sysfs_addrm_finish()  (will deref current dir)

For device_remove_file() ->
  sysfs_remove_file() ->
    sysfs_hash_and_remove() ->
      ...
      sysfs_addrm_start()
      ...
      sysfs_remove_one() (not deref the current file)
      sysfs_addrm_finish()  (will deref current file)


So if not call device_remove_file() firstly, the all files under the
directory are removed, but the related resources are not released which
will cause resource leak.


Thanks.

>> It just like what you said:
>>   device_unregister() ->
>>     kobject_del() ->
>>       sysfs_remove_dir() ->
>>         __sysfs_remove_dir() ->
>>           sysfs_remove_one()
>> But:
>>   device_remove_file() ->
>>     sysfs_remove_file() ->
>>       ...
>>       sysfs_attr_ns() ->
>>         ops->namespace()  (such as device_namespace() in workqueue.c)
>>       ...
>>       sysfs_hash_and_remove() ->
>>         sysfs_remove_one().
>>
>> So if not call device_remove_file() explicitly, the device_namespace()
>> may be not called.
>>
> 
> It seems, if not call ops->namespace(), it still is OK. To get a result,
> it still has much details to continue to read.
> 
> But all together, reference the related code of another subsystems, we
> really need device_remove_file() before call device_unregister().
> 
> 
>>
>> Even in device_unregister(), it still call device_remove_file() to
>> release the related attributes firstly, then call kobject_del().
>>
>>
>>
>> Thanks.
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
