Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464Ab3DJWMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:12:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60128 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3DJWMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <516562C5.2050306@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-4-git-send-email-serban.constantinescu@arm.com>
	<CAMP5XgdNi4BV-aWDGhmFgNGceGoT2msdU_rA4U=wqs6xtYRc_A@mail.gmail.com>
	<516562C5.2050306@arm.com>
Date: Wed, 10 Apr 2013 15:12:31 -0700
Message-ID: <CAMP5XgcvwxWkQV3BJyMz+JSSFRmMj_1a+q_t9htPZ6ZvGd5foQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] staging: android: binder: fix binder interface for
 64bit compat layer
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 6:01 AM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
> On 10/04/13 00:48, Arve Hjønnevåg wrote:
>>>
>>> diff --git a/drivers/staging/android/binder.c
>>> b/drivers/staging/android/binder.c
>>> index 5794cf6..a2cdd9e 100644
>>> --- a/drivers/staging/android/binder.c
>>> +++ b/drivers/staging/android/binder.c
>>
>> ...
>>>
>>> @@ -1700,7 +1700,7 @@ err_no_context_mgr_node:
>>> }
>>>
>>> int binder_thread_write(struct binder_proc *proc, struct binder_thread
>>> *thread,
>>> - void __user *buffer, int size, signed long *consumed)
>>> + void __user *buffer, size_t size, size_t *consumed)
>>
>>
>> What is this change for? You changed from a signed type to an unsigned
>> type which seems unrelated to adding 64 bit support.
>
>
> This change is related to the userspace handling of the struct
> binder_write_read. The userspace writes write_size and read_size as size_t
> values(size_t Parcel::dataSize(), size_t Parcel::dataCapacity()).
>
> On return from a BINDER_WRITE_READ ioctl write_consumed and read_consumed
> are checked against positive values(these values will represent the
> difference between the start of the buffer cursor and the current buffer
> start - positive values since buffer cursor = buffer start ++).
>
> However if there is any plan for these values to be handled as signed longs
> at some point we can change the patch such that we modify just the function
> prototype to:
>
>> int binder_thread_write(struct binder_proc *proc, struct binder_thread
>> *thread,
>>  -               void __user *buffer, int size, signed long *consumed)
>>  +               void __user *buffer, signed long size, signed long
>> *consumed)
>
>
> I will break this change into its own patch such that it is easier to grasp.
>

OK.

>
>>
>> ...
>>>
>>> diff --git a/drivers/staging/android/binder.h
>>> b/drivers/staging/android/binder.h
>>> index dbe81ce..8012921 100644
>>> --- a/drivers/staging/android/binder.h
>>> +++ b/drivers/staging/android/binder.h
>>> @@ -48,13 +48,13 @@ enum {
>>> */
>>> struct flat_binder_object {
>>> /* 8 bytes for large_flat_header. */
>>> - unsigned long type;
>>> - unsigned long flags;
>>> + __u32 type;
>>> + __u32 flags;
>>>
>>> /* 8 bytes of data. */
>>> union {
>>> void __user *binder; /* local object */
>>> - signed long handle; /* remote object */
>>> + __s32 handle; /* remote object */
>>
>>
>> Why limit the handle to 32 bits when the pointer that it shares
>> storage with need to be 64 bit on 64 bit systems?
>
>
> Here I have mirrored the type being passed in handle - a file
> descriptor(when type == BINDER_TYPE_FD) or a handle - 32bit(when type ==
> BINDER_TYPE_HANDLE). This will avoid some casting when handle is used inside
> the kernel/userspace(as 32bit value on 64bit systems). However this change
> does not limit the extension of the API since we can read the value as 64bit
> - binder(on 64bit systems).
>
> I can remove this change if you consider that is the better solution.
>

I was asking if we should just use 64 bit handles on 64 bit systems,
not adding casts. It would require another union member for a file
descriptor however.

>
>>> };
>>>
>>> /* extra data associated with local object */
>>> @@ -67,18 +67,18 @@ struct flat_binder_object {
>>> */
>>>
>>> struct binder_write_read {
>>> - signed long write_size; /* bytes to write */
>>> - signed long write_consumed; /* bytes consumed by driver */
>>> + size_t write_size; /* bytes to write */
>>> + size_t write_consumed; /* bytes consumed by driver */
>>> unsigned long write_buffer;
>>> - signed long read_size; /* bytes to read */
>>> - signed long read_consumed; /* bytes consumed by driver */
>>> + size_t read_size; /* bytes to read */
>>> + size_t read_consumed; /* bytes consumed by driver */
>>
>>
>> What is this change for? You changed from a signed type to an unsigned
>> type which seems unrelated to adding 64 bit support.
>
>
> See above explanation for binder_thread_write() change, I will break this
> into its own patch.
>
>
>>> unsigned long read_buffer;
>>> };
>>>
>>> /* Use with BINDER_VERSION, driver fills in fields. */
>>> struct binder_version {
>>> /* driver protocol version -- increment with incompatible change */
>>> - signed long protocol_version;
>>> + __s32 protocol_version;
>>
>>
>> How does user-space know if it should use 32 bit or 64 bit pointers.
>> Without this change, the BINDER_VERSION ioctl would only match when
>> the size of long matches.
>
>
> The userspace can check the values returned by uname(). That will determine
> if the kernel is 32 or 64bit and depending on this select what binder
> structures to use. Next a BINDER_VERSION ioctl will fail on 64bit kernels
> using protocol_version as 64bit signed long(that is old kernel versions with
> no 64bit support).
>
> Leaving this value as signed long would mean that older versions of the
> binder(without 64bit support) will pass the check. Furthermore the protocol
> version will probably never exceed the values that could be represented on
> 32bit. It will also mean that BINDER_VERSION will have a different
> userspace/kernel handler for 64/32 systems.
>
> Let me know what are your thoughts related to these changes,
> Thanks for your feedback,
> Serban
>

I think user-space should get the binder pointer size from the binder
driver, not elsewhere. Since the current driver does not appear to be
functional on a 64 bit system, I think adding an ioctl to get the
size, or encoding it into the binder version (use an unsigned type if
you do this), would be best.

--
Arve Hjønnevåg
