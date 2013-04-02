Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab3DBSmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:42:11 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:61345 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761213Ab3DBSmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130402180606.GI29506@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
Date: Tue, 2 Apr 2013 11:42:09 -0700
X-Google-Sender-Auth: KE1VD8k6ph0aLl49XncgEw_ZPyU
Message-ID: <CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 11:06 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 02, 2013 at 10:19:42AM -0700, Yinghai Lu wrote:
>
> [..]
>> Index: linux-2.6/Documentation/kernel-parameters.txt
>> ===================================================================
>> --- linux-2.6.orig/Documentation/kernel-parameters.txt
>> +++ linux-2.6/Documentation/kernel-parameters.txt
>> @@ -603,9 +603,13 @@ bytes respectively. Such letter suffixes
>>                       a memory unit (amount[KMG]). See also
>>                       Documentation/kdump/kdump.txt for an example.
>>
>> +     crashkernel_high=size[KMG]
>> +                     [KNL, x86_64] range could be above 4G. Allow kernel
>> +                     to allocate physical memory region from top, so could
>> +                     be above 4G if system have more than 4G ram installed.
>>       crashkernel_low=size[KMG]
>> -                     [KNL, x86_64] range under 4G. When crashkernel= is
>> -                     passed, kernel allocate physical memory region
>> +                     [KNL, x86_64] range under 4G. When crashkernel_high= is
>> +                     passed, kernel could allocate physical memory region
>>                       above 4G, that cause second kernel crash on system
>>                       that need swiotlb later. Kernel would try to allocate
>>                       some region below 4G automatically. This one let
>
> Hi Yinghai,
>
> I think there are still some issues with crashkernel= semantics.
>
> What if I specify both crashkernel_high= as well as crashkernel_low=.
> Looks like crashkernel_low will be parsed only if crashkernel_high
> reserved memory above 4G.
>
> So if one gives following command line.
>
> crashkernel=256M;high crashkernel=100M;low
>
> Final outcome will vary across systems. If system has all RAM below 4G
> we will see only one 256M chunk reserved otherwise we will see one 256M
> and one 100M chunk reserved. And a user might think that I asked you to
> reserve two chunks. One 256M and otherr 100M.

Yes, that is intentional.

If you like, I could remove that checking, just add the low.

>
> Also interesting is, what if user specifies both crashkernel=X and
> crashkernel=Y;high. Looks like we will ignore crashkernel=X and honor
> only crashkernel=Y;high.

Yes, that is intentional.

>
> So the problem here is, do we want to parse multiple crashkernel=
> command line and support reserving multiple ranges? Till 3.8 kernel
> we did not do that.  If we want to do that, then parsing crashkernel=
> logic needs to be more generic.
>
> - I would say that to keep things simple, we can stick to semantics
>   of 3.8 kernel and say only first crashkernel= option is parsed and
>   acted upon. Rest are ignored. Trying to support multiple ranges will
>   require much more work.

we could do that, but that is not necessary.

>
> - If we say that we will only parse first crashkernel= option, then
>   crashkernel=X;high and crashkernel0;low can not co-exist. I would say
>   use a new option to disable automatically reserved low memory. Say,
>   crashkernel_no_auto_low; That way it can co-exist with other
>   crashkernel= options without any conflict.

I don't see any reason to make them co-exist.

aka:
old kexec-tools stay with "crashkernel=X"
new kexec-tools stay with
1. like old kexec tools
2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
Y could be 100M or 0 etc.

>
>   In fact this will also work with crashkernel=X, if we decide to extend
>   crashkernel=X to look for memory below 4G and look beyond 4G.
>
> - Support crashkernel=X;high as a new crashkernel= option.

Actually we still support only one region that is could be high or low,
and that extra low is just for workaround
buggy system that does not support iommu with kdump.

Thanks

Yinghai
