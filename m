Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936124Ab3DKPN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:13:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51022 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3DKPNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:13:24 -0400
Message-ID: <5166D314.1090508@arm.com>
Date: Thu, 11 Apr 2013 16:13:24 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v2 3/7] staging: android: binder: fix binder interface
 for 64bit compat layer
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com> <1365501657-4213-4-git-send-email-serban.constantinescu@arm.com> <CAMP5XgdNi4BV-aWDGhmFgNGceGoT2msdU_rA4U=wqs6xtYRc_A@mail.gmail.com> <516562C5.2050306@arm.com> <CAMP5XgcvwxWkQV3BJyMz+JSSFRmMj_1a+q_t9htPZ6ZvGd5foQ@mail.gmail.com>
In-Reply-To: <CAMP5XgcvwxWkQV3BJyMz+JSSFRmMj_1a+q_t9htPZ6ZvGd5foQ@mail.gmail.com>
X-OriginalArrivalTime: 11 Apr 2013 15:13:20.0042 (UTC) FILETIME=[19D9D0A0:01CE36C7]
X-MC-Unique: 113041116132204801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 23:12, Arve Hjønnevåg wrote:
>>>> struct flat_binder_object {
>>>> /* 8 bytes for large_flat_header. */
>>>> - unsigned long type;
>>>> - unsigned long flags;
>>>> + __u32 type;
>>>> + __u32 flags;
>>>>
>>>> /* 8 bytes of data. */
>>>> union {
>>>> void __user *binder; /* local object */
>>>> - signed long handle; /* remote object */
>>>> + __s32 handle; /* remote object */
>>>
>>>
>>> Why limit the handle to 32 bits when the pointer that it shares
>>> storage with need to be 64 bit on 64 bit systems?
>>
>>
>> Here I have mirrored the type being passed in handle - a file
>> descriptor(when type == BINDER_TYPE_FD) or a handle - 32bit(when type ==
>> BINDER_TYPE_HANDLE). This will avoid some casting when handle is used inside
>> the kernel/userspace(as 32bit value on 64bit systems). However this change
>> does not limit the extension of the API since we can read the value as 64bit
>> - binder(on 64bit systems).
>>
>> I can remove this change if you consider that is the better solution.
>>
>
> I was asking if we should just use 64 bit handles on 64 bit systems,
> not adding casts. It would require another union member for a file
> descriptor however.

I will leave this handle as __s32 for this patch set but I will take a 
look into what and if we need to change this for a 64bit system. From a 
top level perspective(a look at binder_*_ref() functions and the 
userspace equivalent) this should work fine as 32bit.

>>
>>>> };
>>>>
>>>> /* extra data associated with local object */
>>>> @@ -67,18 +67,18 @@ struct flat_binder_object {
>>>> */
>>>>
>>>> struct binder_write_read {
>>>> - signed long write_size; /* bytes to write */
>>>> - signed long write_consumed; /* bytes consumed by driver */
>>>> + size_t write_size; /* bytes to write */
>>>> + size_t write_consumed; /* bytes consumed by driver */
>>>> unsigned long write_buffer;
>>>> - signed long read_size; /* bytes to read */
>>>> - signed long read_consumed; /* bytes consumed by driver */
>>>> + size_t read_size; /* bytes to read */
>>>> + size_t read_consumed; /* bytes consumed by driver */
>>>
>>>
>>> What is this change for? You changed from a signed type to an unsigned
>>> type which seems unrelated to adding 64 bit support.
>>
>>
>> See above explanation for binder_thread_write() change, I will break this
>> into its own patch.
>>
>>
>>>> unsigned long read_buffer;
>>>> };
>>>>
>>>> /* Use with BINDER_VERSION, driver fills in fields. */
>>>> struct binder_version {
>>>> /* driver protocol version -- increment with incompatible change */
>>>> - signed long protocol_version;
>>>> + __s32 protocol_version;
>>>
>>>
>>> How does user-space know if it should use 32 bit or 64 bit pointers.
>>> Without this change, the BINDER_VERSION ioctl would only match when
>>> the size of long matches.
>>
>>
>> The userspace can check the values returned by uname(). That will determine
>> if the kernel is 32 or 64bit and depending on this select what binder
>> structures to use. Next a BINDER_VERSION ioctl will fail on 64bit kernels
>> using protocol_version as 64bit signed long(that is old kernel versions with
>> no 64bit support).
>>
>> Leaving this value as signed long would mean that older versions of the
>> binder(without 64bit support) will pass the check. Furthermore the protocol
>> version will probably never exceed the values that could be represented on
>> 32bit. It will also mean that BINDER_VERSION will have a different
>> userspace/kernel handler for 64/32 systems.
>>
>> Let me know what are your thoughts related to these changes,
>> Thanks for your feedback,
>> Serban
>>
>
> I think user-space should get the binder pointer size from the binder
> driver, not elsewhere. Since the current driver does not appear to be
> functional on a 64 bit system, I think adding an ioctl to get the
> size, or encoding it into the binder version (use an unsigned type if
> you do this), would be best.

I will think about the best way of getting the pointer size and add it 
to the patch set for binder compat. For this patch set I will only 
modify the protocol_version from long to __s32.

Thanks for your feedback,
Serban

