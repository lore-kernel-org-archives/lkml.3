Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3DKTCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:02:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43217 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DKTCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:02:20 -0400
Message-ID: <516708BD.3050804@arm.com>
Date: Thu, 11 Apr 2013 20:02:21 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v2 6/7] staging: android: binder: fix alignment issues
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com> <1365501657-4213-7-git-send-email-serban.constantinescu@arm.com> <CAMP5Xgew5_F2De2+7Ny39iww2Un6hC8B3aYNV7CEawovkFg1Og@mail.gmail.com> <516595DC.4090307@arm.com> <CAMP5XgdrAkt72Ra8J2ecHexo+UcF7eGiLTj2gEL0mOoxHgL_ig@mail.gmail.com>
In-Reply-To: <CAMP5XgdrAkt72Ra8J2ecHexo+UcF7eGiLTj2gEL0mOoxHgL_ig@mail.gmail.com>
X-OriginalArrivalTime: 11 Apr 2013 19:02:16.0705 (UTC) FILETIME=[158A3F10:01CE36E7]
X-MC-Unique: 113041120021801501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 23:30, Arve Hjønnevåg wrote:
> On Wed, Apr 10, 2013 at 9:39 AM, Serban Constantinescu
> <Serban.Constantinescu@arm.com> wrote:
>> On 10/04/13 00:58, Arve Hjønnevåg wrote:
>>>
>>> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
>>> <serban.constantinescu@arm.com> wrote:
>>>>
>>>> The Android userspace aligns the data written to the binder buffers to
>>>> 4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
>>>> Android userspace we can have a buffer looking like this:
>>>>
>>>> platform    buffer(binder_cmd   pointer)      size
>>>> 32/32                 32b         32b          8B
>>>> 64/32                 32b         64b          12B
>>>> 64/64                 32b         64b          12B
>>>>
>>>> Thus the kernel needs to check that the buffer size is aligned to 4bytes
>>>> not to (void *) that will be 8bytes on 64bit machines.
>>>>
>>>> The change does not affect existing 32bit ABI.
>>>>
>>>
>>> Do we not want the pointers to be 8 byte aligned on 64bit platforms?
>>
>>
>> No since here we do not align pointers we align binder_buffers and offsets
>> in a buffer.
>>
>
> Do any 64 bit systems align pointers in a struct to 8 bytes? If so, we
> should keep the start address of the struct 8 byte aligned as well.

Most of 64bit compilers will try to align pointers within a structure to 
natural boundaries. However all 64bit variants of currently supported 
Android architectures can service unaligned accesses(possibly with a 
performance degradation compared to an aligned access).

You can take a look at alignment requirements for AArch64 here 
http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055a/IHI0055A_aapcs64.pdf 
chapter 4.

What we are modifying in this patch is the alignment requirements on the 
buffer size(as seen above - arbitrary size 4byte aligned) and the 
alignment check on offp.

Let's take a look at what offp does. The userspace will write object 
references to a buffer using:

>>  820 status_t Parcel::writeObject(const flat_binder_object& val, bool nullMetaData)
>>  ...
>>  826         *reinterpret_cast<flat_binder_object*>(mData+mDataPos) = val;

Buffer
|---------------------------------------|val
|					|
|->mData				|->mDataPos	

where mData is the start of the buffer and mDataPos the current position 
within the buffer(equivalent to offp in the kernel space). Since the 
buffer is guaranteed to be u32 aligned but not u64 aligned the pointer 
to flat_binder_object might live on a unaligned boundary(offp will 
always be aligned to sizeof(u32) - see Parcel::writeAligned()).

However this will happen only on buffers where at the time we write the
next object reference(val) the buffer cursor(mDataPos) happens not to be 
on a multiple of sizeof(void *).

Adding an alignment check in the userspace might be more costly than
servicing the unaligned access(for AArch64 serviced in hardware). Also 
we will save some memory by not adding the padding.

On the other hand if instead of writing a pointer we write a 64bit mutex 
lock to an unaligned address and than try to read it in the kernel side 
things are not guaranteed to be sane. The compiler could make the 
assumption that the lock is natural aligned and use load/store exclusive 
that will fail on an unaligned address. However for this situation we 
can extend the userspace API and add a mutex write primitive like:


> status_t Parcel::writeMutex(mutex lock)
> ...
> *reinterpret_cast<mutex>(ALIGN_CHECK_AND_PAD(mData+mDataPos)) = lock;

I am not aware of any situation where you will have 64bit mutexes passed 
in a binder buffer but you would probably know more about this. Since 
all writes to the buffer are 32bit aligned a 32bit mutex would not 
suffer any alignment issues.

Let me know what are your thoughts about this.

>> Let's assume that from the userspace we receive a sequence of BC_INCREFS and
>> BC_FREE_BUFFER. According to their definitions the buffer would look like:
>>
>> Buffer:
>> [addr]          [element]
>> 0               BC_INCREFS
>> 4               __u32
>> 8               BC_FREE_BUFFER
>> 12              void *        //(8 bytes for 64bit or 4 bytes for 32bit)
>>
>> Thus the data_size(sizeof(Buffer)) will be 20 bytes for 64bit systems(4bytes
>> aligned). Same explanation for offp where it represents the offset form the
>> start of the buffer to a flat_binder_object(for example here the offset to
>> void* - 12bytes).
>>
>
> Does this work on every 64 bit system?

See above.


Thanks for your feedback,
Serban

