Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3LESoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:44:54 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47544 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3LESow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:44:52 -0500
Message-ID: <52A0C9A7.4050405@arm.com>
Date: Thu, 05 Dec 2013 18:44:55 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "irogers@google.com" <irogers@google.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 2/9] staging: android: binder: Add binder_copy_to_user()
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com> <1386180581-6710-3-git-send-email-serban.constantinescu@arm.com> <20131204231745.GA10410@kroah.com>
In-Reply-To: <20131204231745.GA10410@kroah.com>
X-OriginalArrivalTime: 05 Dec 2013 18:44:49.0198 (UTC) FILETIME=[137DDCE0:01CEF1EA]
X-MC-Unique: 113120518445100201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/13 23:17, Greg KH wrote:
> On Wed, Dec 04, 2013 at 06:09:34PM +0000, Serban Constantinescu wrote:
>> This patch adds binder_copy_to_user() to be used for copying binder
>> commands to user address space. This way we can abstract away the
>> copy_to_user() calls and add separate handling for the compat layer.
>>
>> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
>> ---
>>   drivers/staging/android/binder.c |   39 ++++++++++++++++++++------------------
>>   1 file changed, 21 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
>> index 233889c..6fbb340 100644
>> --- a/drivers/staging/android/binder.c
>> +++ b/drivers/staging/android/binder.c
>> @@ -2117,6 +2117,18 @@ static int binder_has_thread_work(struct binder_thread *thread)
>>   		(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN);
>>   }
>>
>> +static int binder_copy_to_user(uint32_t cmd, void *parcel,
>> +			       void __user **ptr, size_t size)
>> +{
>> +	if (put_user(cmd, (uint32_t __user *)*ptr))
>> +		return -EFAULT;
>> +	*ptr += sizeof(uint32_t);
>> +	if (copy_to_user(*ptr, parcel, size))
>> +		return -EFAULT;
>> +	*ptr += size;
>> +	return 0;
>> +}
>
> I know what you are trying to do here, but ick, why not just use the
> structure involved in the copying out here?  Or just copy the thing out
> in one "chunk", not two different calls, which should make this go
> faster, right?

Ick... agree. I do this split here for the compat handling added in the
next patches, where the cmd will have to be converted to a 32bit compat
cmd and the size, parcel ,passed here will change to a 32bit compat
size, parcel.

This patch makes more sense when looking at the following snippet:

*<snippet from patch 9/9>*

> +static int binder_copy_to_user(uint32_t cmd, void *parcel,
> +                              void __user **ptr, size_t size)
> +{
> +       if (!is_compat_task()) {
> +               if (put_user(cmd, (uint32_t __user *)*ptr))
> +                       return -EFAULT;
> +               *ptr += sizeof(uint32_t);
> +               if (copy_to_user(*ptr, parcel, size))
> +                       return -EFAULT;
> +               *ptr += size;
> +               return 0;
> +       }
> +       switch (cmd) {
> +       case BR_INCREFS:
> +       case BR_ACQUIRE:
> +       case BR_RELEASE:
> +       case BR_DECREFS: {
> +               struct binder_ptr_cookie *fp;
> +               struct compat_binder_ptr_cookie tmp;
> +
> +               cmd = compat_change_size(cmd, sizeof(tmp));

Passing the cmd, and the structure to be copied to binder_copy_to_user()
allows me to add this extra handling here. Where, first, cmd is changed
to a compat cmd, and then copied to userspace - i.e:

I change

> cmd = BR_INCREFS = _IOR('r', 7, struct binder_ptr_cookie)

to

> cmd = COMPAT_BR_INCREFS = _IOR('r', 7, struct compat_binder_ptr_cookie)

where

> struct binder_ptr_cookie {
> 	void* ptr;
> 	void* cookie;
> };

and

> struct compat_binder_ptr_cookie {
> 	compat_uptr_t ptr;
> 	compat_uptr_t cookie;
> };

Thus BR_INCREFS will be different between 32bit userspace and 64bit kernel.

> +               BUG_ON((cmd != COMPAT_BR_INCREFS) &&
> +                      (cmd != COMPAT_BR_ACQUIRE) &&
> +                      (cmd != COMPAT_BR_RELEASE) &&
> +                      (cmd != COMPAT_BR_DECREFS));
> +
> +               fp = (struct binder_ptr_cookie *) parcel;
> +               tmp.ptr = ptr_to_compat(fp->ptr);
> +               tmp.cookie = ptr_to_compat(fp->cookie);
> +               if (put_user(cmd, (uint32_t __user *)*ptr))
> +                       return -EFAULT;
> +               *ptr += sizeof(uint32_t);
> +               if (copy_to_user(*ptr, &tmp, sizeof(tmp)))
> +                       return -EFAULT;
> +               *ptr += sizeof(tmp);

Also, since the size of the parcel will differ when copied to a compat
task (32bit userspace) I increment the buffer ptr here, rather then
doing this in binder_thread_read().

This way we can safely move to the next cmd, by incrementing the buffer
ptr accordingly whether 32 or 64bit structures are needed.

*</sippet from patch 9/9>*


>> +
>>   static int binder_thread_read(struct binder_proc *proc,
>>   			      struct binder_thread *thread,
>>   			      void  __user *buffer, size_t size,
>> @@ -2263,15 +2275,12 @@ retry:
>>   				node->has_weak_ref = 0;
>>   			}
>>   			if (cmd != BR_NOOP) {
>> -				if (put_user(cmd, (uint32_t __user *)ptr))
>> -					return -EFAULT;
>> -				ptr += sizeof(uint32_t);
>> -				if (put_user(node->ptr, (void * __user *)ptr))
>> -					return -EFAULT;
>> -				ptr += sizeof(void *);
>> -				if (put_user(node->cookie, (void * __user *)ptr))
>> +				struct binder_ptr_cookie tmp;
>> +
>> +				tmp.ptr = node->ptr;
>> +				tmp.cookie = node->cookie;
>> +				if (binder_copy_to_user(cmd, &tmp, &ptr, sizeof(struct binder_ptr_cookie)))
>>   					return -EFAULT;
>> -				ptr += sizeof(void *);
>
> Are you sure this is correct?  You are now no longer incrementing ptr
> anymore, is that ok with the larger loop here?

Obscure, I should document this in the commit message! It is correct, I
increment the buffer in binder_copy_to_user() with a different size,
depending on whether the structures are copied to 32bit or 64bit
userspace. See above explanation for more detail.

>
>
>>
>>   				binder_stat_br(proc, thread, cmd);
>>   				binder_debug(BINDER_DEBUG_USER_REFS,
>> @@ -2306,12 +2315,10 @@ retry:
>>   				cmd = BR_CLEAR_DEATH_NOTIFICATION_DONE;
>>   			else
>>   				cmd = BR_DEAD_BINDER;
>> -			if (put_user(cmd, (uint32_t __user *)ptr))
>> -				return -EFAULT;
>> -			ptr += sizeof(uint32_t);
>> -			if (put_user(death->cookie, (void * __user *)ptr))
>> +
>> +			if (binder_copy_to_user(cmd, &death->cookie, &ptr, sizeof(void *)))
>>   				return -EFAULT;
>> -			ptr += sizeof(void *);
>> +
>
> Same here, no more ptr incrementing.

See above.
>
>
>>   			binder_stat_br(proc, thread, cmd);
>>   			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
>>   				     "%d:%d %s %p\n",
>> @@ -2373,12 +2380,8 @@ retry:
>>   					ALIGN(t->buffer->data_size,
>>   					    sizeof(void *));
>>
>> -		if (put_user(cmd, (uint32_t __user *)ptr))
>> -			return -EFAULT;
>> -		ptr += sizeof(uint32_t);
>> -		if (copy_to_user(ptr, &tr, sizeof(tr)))
>> +		if (binder_copy_to_user(cmd, &tr, &ptr, sizeof(struct binder_transaction_data)))
>>   			return -EFAULT;
>> -		ptr += sizeof(tr);
>
> And here, no more ptr incrementing.
See above.

Thanks for your feedback Greg,
Serban C

