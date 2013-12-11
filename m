Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LKDVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:21:13 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60638 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKDVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:21:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAMoF9u1W4-xUFjtMw+SuwR=wgnpfq4uMucKciqrqp81WK1aNmw@mail.gmail.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
	<CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
	<20131204214325.GA19565@kroah.com>
	<CAMbhsRSkYuNBOt57PothjUO_6=vyJQAYsLmasq4Y-QVCT7fqZA@mail.gmail.com>
	<20131204220247.GA22031@kroah.com>
	<CAMP5Xgd-n4dgPsGN9KnD1c6WQ-CTAU1-3Z3mWgg=vqZQeru+UA@mail.gmail.com>
	<CAMoF9u1W4-xUFjtMw+SuwR=wgnpfq4uMucKciqrqp81WK1aNmw@mail.gmail.com>
Date: Tue, 10 Dec 2013 19:21:11 -0800
Message-ID: <CAMP5XgeGRjK5rPeMFv-LT3u+Bvc8WumtDgMdgnYDXO0t_C__Cw@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Octavian Purdila <tavi.purdila@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>,
        Rom Lemarchand <romlem@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 7:01 PM, Octavian Purdila <tavi.purdila@gmail.com> wrote:
> On Thu, Dec 5, 2013 at 4:02 AM, Arve Hjønnevåg <arve@android.com> wrote:
>> On Wed, Dec 4, 2013 at 2:02 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Wed, Dec 04, 2013 at 01:55:34PM -0800, Colin Cross wrote:
>>>> On Wed, Dec 4, 2013 at 1:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>> > On Wed, Dec 04, 2013 at 12:46:42PM -0800, Colin Cross wrote:
>>>> >> On Wed, Dec 4, 2013 at 10:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>> >> <snip>
>>>> >>
>>>> >> > And finally, is this all really needed?  Why not just fix the structures
>>>> >> > to be "correct", and then fix userspace to use the correct structures as
>>>> >> > well, thereby not needing a compat layer at all?
>>>> >>
>>>> >> Some of the binder ioctls take userspace pointers.  Are you suggesting
>>>> >> storing those pointers in a __u64 to avoid having to have a
>>>> >> compat_ioctl?
>>>> >
>>>> > Yes, that's the best way to solve the issue, right?
>>>>
>>>> It's the least code, but in exchange you lose all the type safety and
>>>> warnings when copying in and out of the pointers, as well as sparse
>>>> checking on the __user attribute.
>>>
>>> Not if you make the cast right at the beginning, when you first "touch"
>>> the data, but yes, it does take some of the type saftey away, at the
>>> expense of simpler code to mess up :)
>>>
>>>> That doesn't seem like a good tradeoff to me.  In addition it requires
>>>> modifying the existing heavily used 32 bit api, which means a
>>>> mostly-equivalent compat layer added in libbinder to support old
>>>> kernels.
>>>
>>> Wait, I thought that libbinder would have to be changed anyway here, to
>>> handle 64bit kernels (in both 32 and 64bit userspace).  Since you are
>>> already changing it, why not just "do it correctly"?
>>>
>>
>> Yes libbinder will have to be changed to support calls between 32 bit
>> and 64 bit processes, so I don't see much value in a patchset that
>> only supports all 32 bit or all 64 bit processes. If user space is
>> fixed to use 64 bit pointers on a 64 bit system, then much of the code
>> added in this patchset becomes useless (and probably harmful as it
>> appears to prevent 32 bit processes from communicating with 64 bit
>> processes).
>>
>
> Hi,
>
> Coincidentally, I have been working on a compat layer myself lately.
> It is implemented in the binder driver with no changes in libbinder
> and it includes support for mixed mode.
>
> Unless you think that the kernel compat layer is a dead end, I can
> post the patches here for review. IMO the kernel compat layer gives
> you greater flexibility because it keeps the 32bit ABI unchanged. Of
> course it comes with the price of increased complexity.
>
> Thanks,
> Tavi

Assuming you are talking about a kernel compat layer that translates
the flat_binder_object structs as they pass between 32 bit and 64 bit
processes, that will not always work. The data portion of the message
sometimes contain size values that are invisible to the kernel, but
these values will be wrong if the kernel move data to make room for a
different size flat_binder_object.

-- 
Arve Hjønnevåg
