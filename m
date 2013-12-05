Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab3LESbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:31:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53669 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3LESbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:31:38 -0500
Message-ID: <52A0C67D.90809@arm.com>
Date: Thu, 05 Dec 2013 18:31:25 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Colin Cross <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>	<20131204183554.GA16693@kroah.com>	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>	<20131204214325.GA19565@kroah.com>	<CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>	<20131204220247.GA22031@kroah.com> <CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
In-Reply-To: <CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
X-OriginalArrivalTime: 05 Dec 2013 18:31:35.0016 (UTC) FILETIME=[3A1F4E80:01CEF1E8]
X-MC-Unique: 113120518313503501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thanks for your feedback! Sadly enough, being in a different time-zone, 
is not useful.

Sorry for the confusion related to why is this patch needed or not. I
should highlight a bit more what is the patch enabling and what would be 
the different alternatives, at least from my perspective.

*64bit kernel/ 32bit userspace*

This patch series adds support for 32bit userspace running on 64bit 
kernels. Thus by applying this patch to your kernel you will be able to 
use any existing 32bit Android userspace on your 64bit platform, running 
a 64bit kernel. That is pure 32bit userspace with no 64bit support!

This means *no modifications to the 32bit userspace*. Therefore any 
applications or userspace side drivers, that uses the binder interface 
at a native level will not have to be modified. These kind of 
applications are not "good citizens" - the native binder API is not 
exposed in the Android NDK. However I do not know how many applications 
do this and if breaking the compatibility is a concernt for 32bit 
userspace running on 64bit kernels.

Below you will find more information on one of the alternative 
solutions, the userspace compat.

*32bit kernel/ 32bit userspace*
*64bit kernel/ 64bit userspace*

My last series of binder patches, accepted into 3.12 revision of the 
Linux kernel, audits the binder interface for 64bit. A kernel with these 
changes applied can be used with a pure 64bit userspace (this does not 
include support for 32bit applications coexisting with 64bit ones). The 
userspace side needs trivial changes to libbinder.so and servicemanager, 
that I will upstream ASAP to AOSP, and that work for 32/32 systems and 
64/64 systems without modifying the existing 32bit interface ABI (most 
of the changes are related to uint32_t != void *).

> Author: Serban Constantinescu <serban.constantinescu@arm.com>
> Date:   Thu Jul 4 10:54:48 2013 +0100
>
> staging: android: binder: fix binder interface for 64bit compat layer

*64bit kernel/ 64bit coexisting with 32bit userspace

Please note that *none of the above solutions fix this yet*. To 
understand why this is a special case please take a look at
how the binder driver works, seen from a high level perspective:

>           ServiceManager
> App1  <---------------------> App2

Thus, for two apps to exchange information between each other they will 
have to communicate with the userspace governor, ServiceManager. All the 
interaction between App1, App2 and ServiceManager is done through a 
combination of libbinder.so (Userspace HAL) and the binder driver. Note 
that there can only been one ServiceManager process, that is set during 
the userspace boot process.

Now lets consider the case that Arve described earlier 32bit 
Applications coexisting with 64bit ones. In this case all the commands 
and interface used will have to be the same, the ones used by the 64bit 
ServiceManager. For this the kernel entry point for 32bit compat will 
have to be changed to:

> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -3893,9 +3893,13 @@ static const struct file_operations binder_fops = {
>         .owner = THIS_MODULE,
>         .poll = binder_poll,
>         .unlocked_ioctl = binder_ioctl,
> -#ifdef CONFIG_COMPAT
> +#if defined(CONFIG_COMPAT) && !defined(COEXIST_32BIT_64BIT)
>         .compat_ioctl = compat_binder_ioctl,
>  #endif
> +
> +#if defined(COEXIST_32BIT_64BIT)
> +       .compat_ioctl = binder_ioctl,
> +#endif
>         .mmap = binder_mmap,
>         .open = binder_open,
>         .flush = binder_flush,

thus from the perspective of a kernel that works with a 64bit userspace 
where 64bit applications coexist with 32bit applications the handling 
will be the same for both 32bit and 64bit processes. This will also 
involve modifying libbinder.so to use 64bit structures like:

> --- a/libs/binder/IPCThreadState.cpp
> +++ b/libs/binder/IPCThreadState.cpp
> +#if defined(COEXIST_32BIT_64BIT) && !defined(__LP64__)
> +/*
> + * For running 32-bit processes on a 64-bit system, make the interaction with the
> + * binder driver the same from this, when built for 32-bit, as for a 64-bit process.
> + */
> +struct coexist_binder_write_read {
> +    uint64_t    write_size;     /* __LP64__ size_t: bytes to write */
> +    uint64_t    write_consumed; /* __LP64__ size_t: bytes consumed by driver */
> +    uint64_t    write_buffer;   /* __LP64__ unsigned long */
> +    uint64_t    read_size;      /* __LP64__ size_t: bytes to read */
> +    uint64_t    read_consumed;  /* __LP64__ size_t: bytes consumed by driver */
> +    uint64_t    read_buffer;    /* __LP64__ unsigned long */
> +};

"Good citizen" Android applications will go through these changes (since 
they should only use the binder Java API), and so shouldn't encounter 
any problem. Any 32bit applications that use the binder interface at a 
native level will not work with this model (they should not do so!)· 
This is exactly what the kernel compat "guarantees" *only* for 64/32bit 
systems.

The cleaner solution from the binder kernel perspective is to hook the 
compat_ioctl to binder_ioctl and do all this clean-up in the userspace. 
This way the same userspace compat can be used for  64bit kernel/32 bit 
userspace, 64bit kernel/ 64 bit coexisting with 32bit userspace. Note - 
this will mean that 64bit systems with 32bit userspace will be tied to a 
Android version >= the version with COEXIST_32BIT_64BIT support, and if 
the binder interface is used at a lower level than it should be your app 
will not work!

>> Or does this patch series mean that no userspace code is changed?  Is
>> that a "requirement" here?

This is what this series boils down to... Do we need to keep this 
compatibility for 64/32 and aford breaking it for 64/64-32 ?

>>
>
> I don't think we need to support old 32 bit userspace framework code
> on a 64 bit system. I think it is more important to not prevent mixed
> mode systems.

See above snippet for:
> static const struct file_operations binder_fops.
a kernel build flag could differentiate between your target.

Plese let me know if I have missed any other solution and if there is a 
better alternative. Overall I intend to find a solution rather then 
create more mess. The binder driver is complicated as it is and does not 
need more complexity added, however moving forward we will have to 
support some of these systems.

Thanks for all your feedback,
Let me know your thoughts on this,
Serban Constantinescu

