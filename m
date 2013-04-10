Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936920Ab3DJWaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:30:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56153 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3DJWaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <516595DC.4090307@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-7-git-send-email-serban.constantinescu@arm.com>
	<CAMP5Xgew5_F2De2+7Ny39iww2Un6hC8B3aYNV7CEawovkFg1Og@mail.gmail.com>
	<516595DC.4090307@arm.com>
Date: Wed, 10 Apr 2013 15:30:13 -0700
Message-ID: <CAMP5XgdrAkt72Ra8J2ecHexo+UcF7eGiLTj2gEL0mOoxHgL_ig@mail.gmail.com>
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

On Wed, Apr 10, 2013 at 9:39 AM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
> On 10/04/13 00:58, Arve Hjønnevåg wrote:
>>
>> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
>> <serban.constantinescu@arm.com> wrote:
>>>
>>> The Android userspace aligns the data written to the binder buffers to
>>> 4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
>>> Android userspace we can have a buffer looking like this:
>>>
>>> platform    buffer(binder_cmd   pointer)      size
>>> 32/32                 32b         32b          8B
>>> 64/32                 32b         64b          12B
>>> 64/64                 32b         64b          12B
>>>
>>> Thus the kernel needs to check that the buffer size is aligned to 4bytes
>>> not to (void *) that will be 8bytes on 64bit machines.
>>>
>>> The change does not affect existing 32bit ABI.
>>>
>>
>> Do we not want the pointers to be 8 byte aligned on 64bit platforms?
>
>
> No since here we do not align pointers we align binder_buffers and offsets
> in a buffer.
>

Do any 64 bit systems align pointers in a struct to 8 bytes? If so, we
should keep the start address of the struct 8 byte aligned as well.

> Let's assume that from the userspace we receive a sequence of BC_INCREFS and
> BC_FREE_BUFFER. According to their definitions the buffer would look like:
>
> Buffer:
> [addr]          [element]
> 0               BC_INCREFS
> 4               __u32
> 8               BC_FREE_BUFFER
> 12              void *        //(8 bytes for 64bit or 4 bytes for 32bit)
>
> Thus the data_size(sizeof(Buffer)) will be 20 bytes for 64bit systems(4bytes
> aligned). Same explanation for offp where it represents the offset form the
> start of the buffer to a flat_binder_object(for example here the offset to
> void* - 12bytes).
>

Does this work on every 64 bit system?

--
Arve Hjønnevåg
