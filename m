Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439Ab3IEHmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:42:52 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39466 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab3IEHmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:42:49 -0400
Message-ID: <52283590.8070003@linux.vnet.ibm.com>
Date: Thu, 05 Sep 2013 13:11:04 +0530
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Roland McGrath <roland@hack.frob.com>,
        Amerigo Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, avagin@openvz.org, gorcunov@openvz.org,
        James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "Randy.Dunlap" <rdunlap@xenotime.net>, Eric Paris <eparis@redhat.com>,
        ananth@in.ibm.com, suzuki@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com> <5225A02B.6080901@linux.vnet.ibm.com> <5225BA91.6080904@parallels.com> <5225BE3A.3090602@linux.vnet.ibm.com> <5225C001.2010208@parallels.com> <5227110D.8030100@linux.vnet.ibm.com> <52271A72.8080008@parallels.com>
In-Reply-To: <52271A72.8080008@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090507-2674-0000-0000-00000A86164B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 05:03 PM, Pavel Emelyanov wrote:
> On 09/04/2013 02:53 PM, Janani Venkataraman wrote:
>> On 09/03/2013 04:24 PM, Pavel Emelyanov wrote:
>>> On 09/03/2013 02:47 PM, Janani Venkataraman wrote:
>>>> On 09/03/2013 04:01 PM, Pavel Emelyanov wrote:
>>>>> On 09/03/2013 12:39 PM, Janani Venkataraman wrote:
>>>>>> Hello,
>>>>>>
>>>>>> We are working on an infrastructure to create a system core file of a specific
>>>>>> process at run-time, non-disruptively. It can also be extended to a case where
>>>>>> a process is able to take a self-core dump.
>>>>>
>>>>> This is very close to what we're trying to do in CRIU. And although image files
>>>>> containing info about processes are not ELF files, an ability to generate ELF-cores
>>>>> out of existing CRIU images is one of the features that we were asked for.
>>>>>
>>>>>> 2) CRIU Approach :
>>>>>>
>>>>>> This makes use of the CRIU tool and checkpoints when a dump is called, collects
>>>>>> the required details and continues the running process.
>>>>>> * A self dump cannot be initiated using the command line CRIU which is similar
>>>>>> to the limitation of gcore.
>>>>>
>>>>> This is something we're trying to fix at the moment, as people ask for 'self-dump'
>>>>> ability as well. We plan to have this implemented in v0.8 (the v0.7 is coming out
>>>>> today/tomorrow) in about a month.
>>>>>
>>>>> I can shed more light on this, if required.
>>>>>
>>>>>> * A system call to do the same is being implemented which would help us create
>>>>>> a self dump.The system call is not upstream yet. We could explore that option as
>>>>>> well.
>>>>>
>>>>> Thanks,
>>>>> Pavel
>>>>>
>>>> Hi,
>>>>
>>>> I would like to know more about the "self-dump" ability of CRIU. This is
>>>> the implementation using system calls if I am not wrong.
>>>
>>> Not exactly.
>>>
>>> In CRIU project since it's earliest days, we had to heavily patch the kernel
>>> to make it provide additional APIs for getting more info about running tasks
>>> and kernel objects. You can find all the patches we've created on the page
>>> http://criu.org/Commits
>>>
>>> For almost all the new APIs we proposed the community asked us to restrict them
>>> with CAP_SYS_ADMIN checks, so CRIU even for very basic stuff should be run from
>>> root. The intention was to create the proof-of-concept with maximal and most
>>> strict protection, and then think harder about less strict checks.
>>>
>>> With this the self-dump functionality cannot be implemented as just "CRIU in a
>>> .so file", since this would only be usable by root processes. So, instead of
>>> just wrapping the whole CRIU stuff into a library, we use a trickier approach.
>>> It's described here -- http://criu.org/Self_dump
>>>
>>> Briefly -- we will implement the CRIU service, which is a daemon running from
>>> root and listening on a unix socket. When a task wants to dump himself, it sends
>>> to the service a "dump me" message. The service then goes and dumps the process.
>>>
>>> Thanks,
>>> Pavel
>>>
>>
>> Hi,
>>
>> What we require for our infrastructure is just a register snapshot and a
>> memory dump.Do we require CAP_SYS privileges,if we want to dump the only
>> regset and memory ?
>
> For registers and just the contents of memory you should just have enough
> rights to attach to the "victim" with the debugger. This usually means
> uid-s equivalence or CAP_SYS_PTRACE capability otherwise.
>
>> Is it possible to librarize the dump generation routine so that it is
>> transparent to the user. Also, ideally a single API for dump generation
>> is preferred for generating the dump, irrespective of whether it is a
>> self dump or not.
>
> We're currently developing a protobuf-RPC protocol to talk to criu service.
> Additionally there will be a .so library, that will provide C API above this
> protocol.
>
>> One another aspect we might want to look at is the DoS attacks. Are
>> there any cases where it is prone to such attacks.
>
> Well, checkpoint takes time, memory and disk, so if performed too often, may
> cause starvation on these resources.
>
>> We also looked into the Self-dump page you had mentioned and we would
>> like to know more. Is there any additional information/prototype which
>> you share with us .Also would it be possible for us to test a few
>> patches for the self dump case ?
>
> Currently this is work-in-progress, you can check criu mailing list
> archives at http://lists.openvz.org/pipermail/criu/, the patches from
> Ruslan Kuprieiev <kupruser@> are mostly about it.
>
>> If converting the dump,to ELF-core format from the existing CRIU Image
>> format has not yet been done,we would be happy to contribute towards it.
>
> Oh, that's great! The criu images format is described at http://criu.org/Images,
> feel free to ask questions if you find this information not enough.

    I will look into this and get back to you at the earliest.
>
> Thanks,
> Pavel
>
Thanks,
Janani

