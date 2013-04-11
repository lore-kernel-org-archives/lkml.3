Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3DKVk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:40:59 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43273 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3DKVk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <516708BD.3050804@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-7-git-send-email-serban.constantinescu@arm.com>
	<CAMP5Xgew5_F2De2+7Ny39iww2Un6hC8B3aYNV7CEawovkFg1Og@mail.gmail.com>
	<516595DC.4090307@arm.com>
	<CAMP5XgdrAkt72Ra8J2ecHexo+UcF7eGiLTj2gEL0mOoxHgL_ig@mail.gmail.com>
	<516708BD.3050804@arm.com>
Date: Thu, 11 Apr 2013 14:40:56 -0700
Message-ID: <CAMP5XgfBvoxZZ8Xa3s6Tvz_yhP-zSg_oyv09E0Q9CLiiR-6yUA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] staging: android: binder: fix alignment issues
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

On Thu, Apr 11, 2013 at 12:02 PM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
> On 10/04/13 23:30, Arve Hjønnevåg wrote:
>>
>> On Wed, Apr 10, 2013 at 9:39 AM, Serban Constantinescu
>> <Serban.Constantinescu@arm.com> wrote:
>>>
>>> On 10/04/13 00:58, Arve Hjønnevåg wrote:
>>>>
>>>>
>>>> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
>>>> <serban.constantinescu@arm.com> wrote:
>>>>>
>>>>>
>>>>> The Android userspace aligns the data written to the binder buffers to
>>>>> 4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
>>>>> Android userspace we can have a buffer looking like this:
>>>>>
>>>>> platform    buffer(binder_cmd   pointer)      size
>>>>> 32/32                 32b         32b          8B
>>>>> 64/32                 32b         64b          12B
>>>>> 64/64                 32b         64b          12B
>>>>>
>>>>> Thus the kernel needs to check that the buffer size is aligned to
>>>>> 4bytes
>>>>> not to (void *) that will be 8bytes on 64bit machines.
>>>>>
>>>>> The change does not affect existing 32bit ABI.
>>>>>
>>>>
>>>> Do we not want the pointers to be 8 byte aligned on 64bit platforms?
>>>
>>>
>>>
>>> No since here we do not align pointers we align binder_buffers and
>>> offsets
>>> in a buffer.
>>>
>>
>> Do any 64 bit systems align pointers in a struct to 8 bytes? If so, we
>> should keep the start address of the struct 8 byte aligned as well.
>
>
> Most of 64bit compilers will try to align pointers within a structure to
> natural boundaries. However all 64bit variants of currently supported
> Android architectures can service unaligned accesses(possibly with a
> performance degradation compared to an aligned access).
>
> You can take a look at alignment requirements for AArch64 here
> http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055a/IHI0055A_aapcs64.pdf
> chapter 4.
>
> What we are modifying in this patch is the alignment requirements on the
> buffer size(as seen above - arbitrary size 4byte aligned) and the alignment
> check on offp.
>

OK, relaxing the alignment requirement for *offp to what the hardware
requires makes sense. Is there any macros in the kernel to help with
this, instead of hard-coding it to 4 bytes?

I don't think there is any reason to not keep the binder_buffer and
offsets buffer that the kernel allocates aligned to 8 bytes on a 64
bit system. Also, I don't see any changes to where the offsets buffer
starts in this patch, so if datasize is not 8 bytes aligned you seem
to allocate less memory than you use.

> Let's take a look at what offp does. The userspace will write object
> references to a buffer using:
>
>>>  820 status_t Parcel::writeObject(const flat_binder_object& val, bool
>>> nullMetaData)

>>>  ...
>>>  826         *reinterpret_cast<flat_binder_object*>(mData+mDataPos) =
>>> val;
>
>
> Buffer
> |---------------------------------------|val
> |                                       |
> |->mData                                |->mDataPos
>
> where mData is the start of the buffer and mDataPos the current position
> within the buffer(equivalent to offp in the kernel space). Since the buffer
> is guaranteed to be u32 aligned but not u64 aligned the pointer to
> flat_binder_object might live on a unaligned boundary(offp will always be
> aligned to sizeof(u32) - see Parcel::writeAligned()).
>
> However this will happen only on buffers where at the time we write the
> next object reference(val) the buffer cursor(mDataPos) happens not to be on
> a multiple of sizeof(void *).
>
> Adding an alignment check in the userspace might be more costly than
> servicing the unaligned access(for AArch64 serviced in hardware). Also we
> will save some memory by not adding the padding.
>
> On the other hand if instead of writing a pointer we write a 64bit mutex
> lock to an unaligned address and than try to read it in the kernel side
> things are not guaranteed to be sane. The compiler could make the assumption
> that the lock is natural aligned and use load/store exclusive that will fail
> on an unaligned address. However for this situation we can extend the
> userspace API and add a mutex write primitive like:
>
>
>> status_t Parcel::writeMutex(mutex lock)
>> ...
>> *reinterpret_cast<mutex>(ALIGN_CHECK_AND_PAD(mData+mDataPos)) = lock;
>
>
> I am not aware of any situation where you will have 64bit mutexes passed in
> a binder buffer but you would probably know more about this. Since all
> writes to the buffer are 32bit aligned a 32bit mutex would not suffer any
> alignment issues.
>
> Let me know what are your thoughts about this.
>

Storing a mutex in a parcel does not make sense. The data in the
parcel is a copy of the data passed in, and the parcel seen by the
remote process is a copy of the parcel that sender created.

--
Arve Hjønnevåg
