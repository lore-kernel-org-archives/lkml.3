Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3LDWWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:22:15 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59825 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3LDWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131204220247.GA22031@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
	<20131204214325.GA19565@kroah.com>
	<CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
	<20131204220247.GA22031@kroah.com>
Date: Wed, 4 Dec 2013 14:22:13 -0800
X-Google-Sender-Auth: h7NlRSOE59qBs4J8IZCUy9KZNlE
Message-ID: <CAMbhsRQnY6+Ahs-itSeALNQ27tsWAJT8wUtXNGZE--44URp2-A@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>, romlem@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 2:02 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Dec 04, 2013 at 01:55:34PM -0800, Colin Cross wrote:
>> On Wed, Dec 4, 2013 at 1:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Dec 04, 2013 at 12:46:42PM -0800, Colin Cross wrote:
>> >> On Wed, Dec 4, 2013 at 10:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> <snip>
>> >>
>> >> > And finally, is this all really needed?  Why not just fix the structures
>> >> > to be "correct", and then fix userspace to use the correct structures as
>> >> > well, thereby not needing a compat layer at all?
>> >>
>> >> Some of the binder ioctls take userspace pointers.  Are you suggesting
>> >> storing those pointers in a __u64 to avoid having to have a
>> >> compat_ioctl?
>> >
>> > Yes, that's the best way to solve the issue, right?
>>
>> It's the least code, but in exchange you lose all the type safety and
>> warnings when copying in and out of the pointers, as well as sparse
>> checking on the __user attribute.
>
> Not if you make the cast right at the beginning, when you first "touch"
> the data, but yes, it does take some of the type saftey away, at the
> expense of simpler code to mess up :)
>
>> That doesn't seem like a good tradeoff to me.  In addition it requires
>> modifying the existing heavily used 32 bit api, which means a
>> mostly-equivalent compat layer added in libbinder to support old
>> kernels.
>
> Wait, I thought that libbinder would have to be changed anyway here, to
> handle 64bit kernels (in both 32 and 64bit userspace).  Since you are
> already changing it, why not just "do it correctly"?

libbinder will need changes to support 64-bit userspace and especially
a mixed 64-bit and 32-bit userspace, but this patch series is only
addressing a pure 32-bit userspace on a 64-bit kernel.  Support for a
64-bit userspace in Android is obviously going to require a future
version of Android including, among other things, libbinder changes.
As far as I know, those changes won't need to change the ioctl api,
only the layout of the buffers that are passed through the ioctl api.

> Or does this patch series mean that no userspace code is changed?  Is
> that a "requirement" here?

Since this series only addresses 32-bit userspace on 64-bit kernel
support there are no associated userspace changes.  Changing the
32-bit api here means that combining the KitKat branch from
http://android.googlesource.com with a newer kernel version will not
work.
