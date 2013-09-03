Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3ICJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:16:56 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:34021 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab3ICJQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:16:54 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Manfred Spraul <manfred@colorfullife.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        "Jonathan Gonzalez" <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7?
Thread-Topic: ipc-msg broken again on 3.11-rc7?
Thread-Index: AQHOpZ5oa2zPW4yZMkWQwZduFtEUDA==
Date: Tue, 3 Sep 2013 09:16:41 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514165E@IN01WEMBXA.internal.synopsys.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
 <1372202983.1888.22.camel@buesod1.americas.hpqcorp.net>
 <521DE5D7.4040305@synopsys.com>
 <CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com>
 <C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com>
 <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
 <52205597.3090609@synopsys.com>
 <CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
 <C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
 <CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
 <CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
 <CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com>
 <C2D7FE5348E1B147BCA15975FBA230751413F4@IN01WEMBXA.internal.synopsys.com>
 <5224BCF6.2080401@colorfullife.com>
 <C2D7FE5348E1B147BCA15975FBA23075141642@IN01WEMBXA.internal.synopsys.com>
 <5225A466.2080303@colorfullife.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 02:27 PM, Manfred Spraul wrote:
> On 09/03/2013 10:44 AM, Vineet Gupta wrote:
>>> b) Could you check that it is not just a performance regression?
>>>       Does ./msgctl08 1000 16 hang, too?
>> Nope that doesn't hang. The minimal configuration that hangs reliably is msgctl
>> 50000 2
>>
>> With this config there are 3 processes.
>> ...
>>    555   554 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
>>    554   551 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
>>    551   496 root     S     1208  0.4   0  0.0 ./msgctl08 50000 2
>> ...
>>
>> [ARCLinux]$ cat /proc/551/stack
>> [<80aec3c6>] do_wait+0xa02/0xc94
>> [<80aecad2>] SyS_wait4+0x52/0xa4
>> [<80ae24fc>] ret_from_system_call+0x0/0x4
>>
>> [ARCLinux]$ cat /proc/555/stack
>> [<80c2950e>] SyS_msgrcv+0x252/0x420
>> [<80ae24fc>] ret_from_system_call+0x0/0x4
>>
>> [ARCLinux]$ cat /proc/554/stack
>> [<80c28c82>] do_msgsnd+0x116/0x35c
>> [<80ae24fc>] ret_from_system_call+0x0/0x4
>>
>> Is this a case of lost wakeup or some such. I'm running with some more diagnostics
>> and will report soon ...
> What is the output of ipcs -q? Is the queue full or empty when it hangs?
> I.e. do we forget to wake up a receiver or forget to wake up a sender?
/ # ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages   
0x72d83160 163841     root       600        0            0      


