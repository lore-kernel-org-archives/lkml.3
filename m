Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3LIFnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:43:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3LIFnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:43:15 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9219971"
Message-ID: <52A60ED6.9050903@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 13:41:26 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A5DFC9.6020105@cn.fujitsu.com> <52A53C3A.2090107@gmail.com> <52A5FA13.9000000@cn.fujitsu.com> <52A547F4.6080904@gmail.com> <52A60695.1020504@cn.fujitsu.com>
In-Reply-To: <52A60695.1020504@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 13:42:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 13:42:58,
	Serialize complete at 2013/12/09 13:42:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:06 PM, Dongsheng Yang wrote:
> On 12/08/2013 11:32 PM, David Ahern wrote:
>> On 12/9/13, 10:12 AM, Dongsheng Yang wrote:
>>> On 12/08/2013 10:42 PM, David Ahern wrote:
>>>> On 12/9/13, 8:20 AM, Dongsheng Yang wrote:
>>>>> How about introduce an option named --guestpid? Then we can make the
>>>>> usage of perf kvm
>>>>> more clear:
>>>>>      * perf kvm --guestkallsyms --guestmodules --guestpid
>>>>> [top|record|report]
>>>>>          This usage is for only one guest and will not resolve the
>>>>> symbols from other guests.
>>>>
>>>> If there is only 1 guest then there should not be a problem right? You
>>>> give perf a single guest kallsyms as the "default" and it works.
>>>> --guestpid adds no value in that case.
>>>
>>> Yes, if there is only one guest is running, "default" guest is "the"
>>> guest. Then with my patch in this thread applied, it works well.
>>>
>>> But consider this scenario, there are two guests are running, but we
>>> need to record-report one of them.
>>>
>>> --guestmount can achieve this request, but as a shortcut of guestmount,
>>> --guest{kallysms, modules} dose not
>>> support it well, right? So, I think we can discard the default guest,
>>> and use guestpid in record-report.
>>
>> No.
>>
>> Use cases:
>> 1. one guest
>> --guestkallsyms and --guestmodules apply to default guest; user 
>> should supply files that apply to the one guest. Supplying any other 
>> kallsyms is just nonsense. *NO* other arguments are needed.
>>
>> 2. more than 1 VM, *ALL* VMs running the same kernel
>> --guestkallsyms and --guestmodules apply to default guest; user 
>> should supply files that apply to all of guests. No other arguments 
>> are needed.
>>
>> 3. more than 1 VM, VMs running different kernels. 1+ VMs running the 
>> same kernel
>> --guestmount allows user to supply files that apply to all of guests 
>> based on pid. --guestkallsyms/guestmodules is used for any guest not 
>> showing up in guestmount.
>>
>
> When more than 1 VM, the cases you provided is all about record-report 
> the symbols from __all__ guests. How about I want to record-report one 
> of them?
> Example:
>     There are 2 guests are running different kernels, I want to 
> record-report VM1.
>
> Currently, we can use --guestmount to get the symbols of VM1, but we 
> can not remove the symbols of VM2 from report. It means the percentage 
> of each symbol is not  the symbol only in this VM1.
>
> What I want with introducing guestpid is to record-report the symbols 
> only from VM1, and ignore VM2.
>

Besides, as we provide two usages of perf-kvm in manpage, guestmount-way 
and guest{kallsyms,modules}-way, but the guest{kallsyms, modules} is not 
used when
there is only one guest is running, the guestmount is used in all 
situations, it seems not reasonable. I think we can provide a guestpid 
to make the guestkallsyms-way can be used in any situation.

This way, user can understand and choose the usage easily.

1. one or more guests you want to record-report, --guestmount-way. It 
provides the full functionality of perf kvm.

2. only one guest you want to record-report, --guestmount is also 
available, and there is another usage for this most used case as a 
shortcut , --guest{kallsyms, modules, pid}.

Then the relationship between the two kinds of usage is more clear, 
right? And in this way, we can make the result of perf-kvm more 
foreseeable to user.

>> David
>>
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

