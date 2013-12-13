Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LMHj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:39:29 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49040 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3LMHj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:39:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAMP5XgfRNUHcv54oA9fE8PHBcGwHBwzRqnYjDsBwE+6kams1Pw@mail.gmail.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
	<20131204214325.GA19565@kroah.com>
	<CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
	<20131204220247.GA22031@kroah.com>
	<CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
	<CAMoF9u1W4-xUFjtMw+SuwR=wgnpfq4uMucKciqrqp81WK1aNmw@mail.gmail.com>
	<CAMP5XgeGRjK5rPeMFv-LT3u+Bvc8WumtDgMdgnYDXO0t_C__Cw@mail.gmail.com>
	<CAMoF9u2GN0GuD9azO3irU80tY+bnRhBFxUw3fhajEkFYH9ugmg@mail.gmail.com>
	<CAMP5Xgf=R_VuP=EvMFVuwx=XtTNwQ0Gx-+Fa63DoLH_073WiAQ@mail.gmail.com>
	<CAE1zot+Vptdqt5jmfOd5TYehXJFhG3Cj7Xcq_dU8vY6H3TJ2VQ@mail.gmail.com>
	<CAMP5XgfRNUHcv54oA9fE8PHBcGwHBwzRqnYjDsBwE+6kams1Pw@mail.gmail.com>
Date: Fri, 13 Dec 2013 09:39:26 +0200
Message-ID: <CAE1zotJPinZhFZOsGog_Qi_dd=bs0bhrmow+YtChZn9hgHPEdg@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Octavian Purdila <octavian.purdila@intel.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>,
        Rom Lemarchand <romlem@android.com>,
        Dianne Hackborn <hackbod@android.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 7:14 AM, Arve Hjønnevåg <arve@android.com> wrote:
> On Thu, Dec 12, 2013 at 12:45 AM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
>> On Thu, Dec 12, 2013 at 1:00 AM, Arve Hjønnevåg <arve@android.com> wrote:
>>> On Wed, Dec 11, 2013 at 10:10 AM, Octavian Purdila
>>> <octavian.purdila@intel.com> wrote:
>>>> On Wed, Dec 11, 2013 at 5:21 AM, Arve Hjønnevåg <arve@android.com> wrote:
>>>>>
>>>>> Assuming you are talking about a kernel compat layer that translates
>>>>> the flat_binder_object structs as they pass between 32 bit and 64 bit
>>>>> processes, that will not always work. The data portion of the message
>>>>> sometimes contain size values that are invisible to the kernel, but
>>>>> these values will be wrong if the kernel move data to make room for a
>>>>> different size flat_binder_object.
>>>>>
>>>>
>>>> Hi Arve,
>>>>
>>>> Yes, I was talking about translating flat_binder_objects.
>>>>
>>>> I understand the potential issue for the user data payload, however,
>>>> since most applications will use libbinder, the only problematic case
>>>> is readIntPtr/writeIntPtr, which we can deprecate and convert
>>>> applications that use it to readInt64. AFAICS there is only one user
>>>> in the AOSP for this API (libmedia).
>>>>
>>>> If you are referring to data blobs that application parses I don't
>>>> think there is anything we can do, even at libbinder level.
>>>>
>>>> Can you give me an example of the sort of problems you see?
>>>>
>>>> Thanks,
>>>> Tavi
>>>
>>> The specific problem I was told about can be found in
>>> frameworks/base/core/java/android/os/Bundle.java, but there could be
>>> other. The size of the bundle is stored in the parcel so the end of
>>> the bundle will be wrong if the bundle contains a flat_binder_object
>>> that the driver changes the size of. However, since the sending
>>> process gets the parcel size from libbinder, changing libbinder to
>>> always use the 64 bit version of flat_binder_object should work with
>>> this code.
>>>
>>
>> AFAICS the bundle size is stored as an int32 so there is no bit width
>> issues between the sending and receiving process.
>>
>> When I mentioned that flat_binder_objects will be translated, I meant
>> the whole transaction will be translated to preserve its user payload
>> intact. Something like this:
>>
>>         32bit                        64bit
>>   +----------------+    +--------------------+
>>   | o o oo  o    xx| -> | oo oooo  oo    yyyy|
>>   +----------------+    +--------------------+
>>
>> where o are binder objects, spaces are user data and x,y are offsets
>> pointers to binder objects (they are size_t so they need translation
>> as well).
>>
>> As long as the application does not use absolute offsets in the
>> payload and as long as the data types stored in the payload are fixed
>> bit width across the 32bit/64bit ABI (e.g. int32, int64 instead of
>> intptr) doing the translation in kernel should be fine. I checked
>> libbinder and both assumptions seems to be true (except in a few cases
>> for the later which I already mentioned)
>>
>> So, what am I missing?
>
> The bundle size is wrong in the receiving process if the driver change
> the size of a flat_binder_object stored in the bundle.
>
> A simplified example where a flat_binder_object is a single pointer,
> and a bundle only adds a size to the data stored:
> If you send a bundle with an object and an int <inta> followed by an
> int <intb> from a 32 bit process to a 64 bit process you would get
> this transformation of the data (offsets not shown):
> bundle(obj, inta), int(intb) => parcel_32(8,obj,inta,intb) =>
> parcel_64(8,objl,objh,inta,intb) => bundle(obj), int(inta), int(intb)
>
> The first bundle argument is missing an item in the receiving process,
> and the second argument is <inta> instead of <intb>.
>

Thanks Arve, I understand the problem now. When I first looked at the
code I thought that the bundle stores the number of objects instead of
its size.

In this case, changing libbinder (and ServiceManager) to use 64bit
structures when talking with 64bit kernels seems the only reasonable
approach.
