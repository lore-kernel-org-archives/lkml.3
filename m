Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3BDKyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:54:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46808 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3BDKyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:54:44 -0500
Message-ID: <510F9371.1060704@arm.com>
Date: Mon, 04 Feb 2013 10:54:41 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/2] staging: android: ashmem: fix ashmem pin/unpin interface
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com> <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com> <20130201161836.GA29021@kroah.com> <510BF365.2010609@arm.com> <20130204014114.GA14058@kroah.com>
In-Reply-To: <20130204014114.GA14058@kroah.com>
X-OriginalArrivalTime: 04 Feb 2013 10:54:41.0718 (UTC) FILETIME=[08F1FD60:01CE02C6]
X-MC-Unique: 113020410544300201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 01:41, Greg KH wrote:
> On Fri, Feb 01, 2013 at 04:55:01PM +0000, Serban Constantinescu wrote:
>> Hi Greg,
>>
>> On 01/02/13 16:18, Greg KH wrote:
>>> On Fri, Feb 01, 2013 at 04:08:00PM +0000, Serban Constantinescu wrote:
>>>> The values exchanged between kernel and userspace through struct
>>>> ashmem_pin should be of type size_t. This change won't affect the
>>>> existing interface but will stand as the basis of 64bit compat layer.
>>>
>>> How do you define size_t with a 64bit kernel and a 32bit userspace
>>> properly?  Doesn't this change open up a bunch of problems?
>>
>> The current ashmem pin/unpin kernel interface uses __u32 to specify
>> the memory region and length in bytes. However these values  should
>> be of type size_t so that they are able to represent the whole range
>> of possible values when compiled for a 64bit platform.
>
> Yes, the issue is, what size is size_t on the system if you have a 32bit
> userspace and a 64bit kernel?  :)
>
> That's why we have specific types for when we cross the user/kernel
> boundry.  Why not use them instead here so that you know it will work
> properly in the future?

The patch set was developed using size_t to avoid the use of a #ifdef
statement that would split the use for 64bit platforms using u64 and
32bit using u32. On a 64/32 system you will have a 32bit size_t in the
user space and a 64bit size_t in the kernel. However in the kernel entry 
- compat_ashmem_ioctl we explicitly cast from compat_size_t (32bit - 
same as the userspace) to size_t (64bit used by the kernel).

 > 695                 pin.offset = (size_t)c_pin.offset;
 > 696                 pin.len = (size_t)c_pin.len;

Same logic was applied for existing size_t ioctls:

 > 46 #define ASHMEM_SET_SIZE         _IOW(__ASHMEMIOC, 3, size_t)

where on a 64/32 system you are using:

 > 57 #define COMPAT_ASHMEM_SET_SIZE          _IOW(__ASHMEMIOC, 3, 
compat_size_t)

This kernel header is not intended to be exported for current Android
userspace (even though we have tested this with success on one of the
latest Android revisions).

>> Android API uses ashmem driver through libcutils, from where I
>> attach the following snippet:
>>
>> <aosp>/system/core/libcutils/ashmem-dev.c
>>
>>    75 int ashmem_pin_region(int fd, size_t offset, size_t len)
>>    76 {
>>    77         struct ashmem_pin pin = { offset, len };
>>    78         return ioctl(fd, ASHMEM_PIN, &pin);
>>    79 }
>
> Again, the 32/64 bit issue is to blame.
>
>> The kernel changes inline with the userspace usage and do not affect
>> existing 32bit Android (we have exported the new kernel header,
>> rebuilt and tested the interface with success).
>>
>> However this change will affect any 64bit userspace using the
>> current faulty interface, but there is none that we know of.
>
> I'd like the Android developers to give some feedback on this, before
> I'll do anything.  I still think you need to change this to use the
> proper kernel types.

If you or the Android developers consider the use of #ifdef u64/u32 is 
better I will rework the patch accordingly.


Thanks,
Serban Constantinescu

