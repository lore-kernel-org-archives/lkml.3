Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3DASdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:33:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43564 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab3DASdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:33:37 -0400
Message-ID: <5159D2E9.7080707@zytor.com>
Date: Mon, 01 Apr 2013 11:33:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
References: <20130320163131.GE2273@redhat.com> <1363807329-24975-1-git-send-email-yinghai@kernel.org> <20130325194245.GA7357@redhat.com> <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com> <20130326181418.GA6775@redhat.com> <20130401133428.GA13499@redhat.com>
In-Reply-To: <20130401133428.GA13499@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 06:34 AM, Vivek Goyal wrote:
> On Tue, Mar 26, 2013 at 02:14:18PM -0400, Vivek Goyal wrote:
>> On Mon, Mar 25, 2013 at 02:50:18PM -0700, Yinghai Lu wrote:
>>> On Mon, Mar 25, 2013 at 12:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>> So it is a forgone conclusion that these new kernel changes to
>>>> crashkernel=X in 3.9 are incompatible with older kexec-tools and one
>>>> needs to upgrade kexec-tools.
>>>
>>> I thought that you and hpa all agreed that user need to update kexec-tools with
>>> new kernel v3.9. It that still right?
>>
>> I can update kexec-tools and I don't have problems with that. I am only
>> concerned about some xyz user complaining that new kernel stopped working
>> with old kexec-tools and then possibly face the rant from Linus about
>> breaking user space. :-)
>>
>> To me we could maintain backward compatibility by retaining the existing
>> behavior of crashkernle=X. That is  look for specificied memory below
>> 896M first and then go higher.
>>
>> And hide new semantics behind new kernel parameters or by extending
>> existing parameter (say crashkernel=X:search_high_first) to specify how
>> to search for reserved memory.
>>
>> In both the cases we should probably retain the logic of auto reserving
>> low memory for software iotlb and let user opt out if there is no need.
>>
>> So we don't have a strong reason that why we should break existing
>> kexec-tools. So I would prefer not to break it.
>>
>> But I think this is hpa's decision.
> 
> hpa,
> 
> ping. Any thoughts on this?

Pardon me while I retch.  The whole kdump dependency mess is making me
sick to my stomach.

The fundamental problem you have is that the user has to take an action
that doesn't make any sense, because there isn't any sane method to
backflow the requirements from the crashkernel to the command line.

The only way I can think how to deal with that in a sane way that
doesn't require that the user has to understand a whole bunch of things
about their system that no user should ever have to be burdened with is
to have the packaging system feed back information about the crashkernel
and kexec-tools that will be used.  That interface probably needs
serious architecting.

I wouldn't object to crashkernel=<size>,<option>,<option>... being the
format for that and it has the plus that it doesn't break less.  So
something like "crashkernel=800M,high" (:search_high_first is
inconsistent with other options and completely pointlessly wordy... this
isn't Multics, and the command line space is a limited resource) would
make sense.

However, I really strongly suggest you work on a mechanism to take the
information about the crashkernel and utilities that the kernel can't
know and feed it into the bootloader configuration.  This can be as
simple as a set of scripts.

	-hpa

