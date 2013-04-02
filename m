Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3DBOpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:45:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47936 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab3DBOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130402135001.GC29506@redhat.com>
References: <20130401133428.GA13499@redhat.com>
	<5159D2E9.7080707@zytor.com>
	<20130401192606.GA17951@redhat.com>
	<5159F27E.7060300@zytor.com>
	<CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
	<515A03DB.6040107@zytor.com>
	<CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
	<515A083B.7050508@zytor.com>
	<CAE9FiQXwy8nLRQAiZ+P56fokisUXAmTJWA07TZ-gSH61K5FQLA@mail.gmail.com>
	<CAE9FiQW1RzP5A_82qUP7gF_6-G3+Ceay_L1FQf7N=MMbQA4+iw@mail.gmail.com>
	<20130402135001.GC29506@redhat.com>
Date: Tue, 2 Apr 2013 07:45:36 -0700
X-Google-Sender-Auth: cHT2NSMwk1zSxzd8196zuGlTSAI
Message-ID: <CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 6:50 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 01, 2013 at 06:11:38PM -0700, Yinghai Lu wrote:
>> On Mon, Apr 1, 2013 at 3:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Mon, Apr 1, 2013 at 3:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> >> On 04/01/2013 03:17 PM, Yinghai Lu wrote:
>> >>>
>> >>> And his last suggestion is just as his old second suggestion.
>> >>>
>> >>> I just check the code again, it looks it is easy to change it to support:
>> >>> 1. crashkernel=XM
>> >>> 2. crashkernel_high=XM
>> >>> 3. crashkernel_high=XM crashkernel_low=YM
>> >>>
>> >>
>> >> Yes... my objections that you are giving the user the headache of
>> >> dealing with this very much remains, but I don't think we have any good
>> >> options.  However, the <size>,<options>.... syntax is at least
>> >> extensible, which the above syntax is not.
>> >
>> > ok, will check crashkernel=XM,high
>>
>> Please check attached four patches that should get into upstream for 3.9.
>> I sent first and second before.
>> other two is addressing old kexec-tools with kdump on new kernel.
>
> Hi Yinghai,
>
> I think there is still little confusion. What does crashkernel=X,high
> mean. Currently it seems to mean that memory is allocated from region
> above 4G and if it is not available, allocation fails.
>
> I thought what would be more useful if it means that we start search
> for memory from higher range of addresses and continue down till we
> find a suitable memory area.
>
> That means memory could either come from higher memory regions (above
> 4G) or from low memory regions (below 4G) depending on how much physical
> RAM system has.
>
> Similary crashkernel=X or crashkernel=X,low will mean that we start
> scanning for free memory from low memory area first. And if sufficient
> amount of memory is not available below 4G, memory could very well
> come from above 4G.
>
> That way a distribution could decide its default memory requirement
> (say 128M) and they could simply say, crashkernel=128M or
> crashkernel=128M,high (depending on whether they support 64bit bzImage
> or not).
>
> To achieve the behavior where we want to enforce that memory either
> comes from low or high area only otherwise allocation fails, we could
> probably use.
>
> crashkernel=X,high_only
> crashkernel=X,low_only
>
> And crashkernel_low could be replaced with crashkernel=X,low_only
>
> I think it is reasonable to continue to reserve low memory automatically
> for swiotlb if crash memory reservation happens above 4G. Users should
> be able to opt out of it using crashkernel=0M,low_only.

No, that make the logic too complicated.

After those four patches:
if the user still use old kexec-tools, they are still with
crashkernel=X, nothing is changed.
if the user want to use crashkernel=X,high, they should update kexec-tools.
   when high is used, memblock will search from top to low.
   if the allocated one is above 4G, kernel will try to auto allocate
72M under 4G for swiotlb
       user could crashkernel=Y,low to change 72M to other value.

The whole point is:
1. keep the transition from old kexec-tools to new one.
2. keep thing unified when new kexec-tools is used: always high.

Thanks

Yinghai
