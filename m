Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaL3TS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:18:57 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:42268 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaL3TSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:18:55 -0500
Message-ID: <54A2FA98.3040701@hurleysoftware.com>
Date: Tue, 30 Dec 2014 14:18:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Denis Du <dudenis2000@yahoo.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
CC: Christian Riesch <christian.riesch@omicron.at>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in receive
 path
References: <545CCCFE.1060307@hurleysoftware.com> <1701203607.2805270.1419966143571.JavaMail.yahoo@jws10633.mail.bf1.yahoo.com>
In-Reply-To: <1701203607.2805270.1419966143571.JavaMail.yahoo@jws10633.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 02:02 PM, Denis Du wrote:
> Hi, guys:
> 
> I confirmed the Patch worked great on non-SMP 3.12 kernel. But on SMP it will still have race condition happened.
> 
> Does anyone have another patch for the SMP as mentioned in commit
> 19e2ad6a09f0c06dbca19c98e5f4584269d913dd

My apologies for not cc'ing you on that fix.

https://lkml.org/lkml/2014/12/30/66

However, it requires 3.14+.  I still need to backport it to 3.12.

Regards,
Peter Hurley


> 
> 
>  
> Denis Du
> 
> 
> ----- Original Message -----
> From: Peter Hurley <peter@hurleysoftware.com>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Måns Rullgård <mans@mansr.com>
> Cc: Christian Riesch <christian.riesch@omicron.at>; Jiri Slaby <jslaby@suse.cz>; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Sent: Friday, November 7, 2014 8:45 AM
> Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in receive path
> 
> On 11/06/2014 05:31 PM, Greg Kroah-Hartman wrote:
>> On Thu, Nov 06, 2014 at 10:12:54PM +0000, Måns Rullgård wrote:
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>
>>>> On Thu, Nov 06, 2014 at 09:38:59PM +0000, Måns Rullgård wrote:
>>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>>>
>>>>>> On Thu, Nov 06, 2014 at 09:01:36PM +0000, Måns Rullgård wrote:
>>>>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>>>>>
>>>>>>>> On Thu, Nov 06, 2014 at 08:49:01PM +0000, Måns Rullgård wrote:
>>>>>>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>>>>>>>
>>>>>>>>>> On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
>>>>>>>>>>> The current implementation of put_tty_queue() causes a race condition
>>>>>>>>>>> when re-arranged by the compiler.
>>>>>>>>>>>
>>>>>>>>>>> On my build with gcc 4.8.3, cross-compiling for ARM, the line
>>>>>>>>>>>
>>>>>>>>>>>     *read_buf_addr(ldata, ldata->read_head++) = c;
>>>>>>>>>>>
>>>>>>>>>>> was re-arranged by the compiler to something like
>>>>>>>>>>>
>>>>>>>>>>>     x = ldata->read_head
>>>>>>>>>>>     ldata->read_head++
>>>>>>>>>>>     *read_buf_addr(ldata, x) = c;
>>>>>>>>>>>
>>>>>>>>>>> which causes a race condition. Invalid data is read if data is read
>>>>>>>>>>> before it is actually written to the read buffer.
>>>>>>>>>>
>>>>>>>>>> Really?  A compiler can rearange things like that and expect things to
>>>>>>>>>> actually work?  How is that valid?
>>>>>>>>>
>>>>>>>>> This is actually required by the C spec.  There is a sequence point
>>>>>>>>> before a function call, after the arguments have been evaluated.  Thus
>>>>>>>>> all side-effects, such as the post-increment, must be complete before
>>>>>>>>> the function is called, just like in the example.
>>>>>>>>>
>>>>>>>>> There is no "re-arranging" here.  The code is simply wrong.
>>>>>>>>
>>>>>>>> Ah, ok, time to dig out the C spec...
>>>>>>>>
>>>>>>>> Anyway, because of this, no need for the wmb() calls, just rearrange the
>>>>>>>> logic and all should be good, right?  Christian, can you test that
>>>>>>>> instead?
>>>>>>>
>>>>>>> Weakly ordered SMP systems probably need some kind of barrier.  I didn't
>>>>>>> look at it carefully.
>>>>>>
>>>>>> It shouldn't need a barier, as it is a sequence point with the function
>>>>>> call.  Well, it's an inline function, but that "shouldn't" matter here,
>>>>>> right?
>>>>>
>>>>> Sequence points say nothing about the order in which stores become
>>>>> visible to other CPUs.  That's why there are barrier instructions.
>>>>
>>>> Yes, but "order" matters.
>>>>
>>>> If I write code that does:
>>>>
>>>> 100    x = ldata->read_head;
>>>> 101    &ldata->read_head[x & SOME_VALUE] = y;
>>>> 102    ldata->read_head++;
>>>>
>>>> the compiler can not reorder lines 102 and 101 just because it feels
>>>> like it, right?  Or is it time to go spend some reading of the C spec
>>>> again...
>>>
>>> The compiler can't.  The hardware can.  All the hardware promises is
>>> that at some unspecified time in the future, both memory locations will
>>> have the correct values.  Another CPU might see 'read_head' updated
>>> before it sees the corresponding data value.  A wmb() between the writes
>>> forces the CPU to complete preceding stores before it begins subsequent
>>> ones.
>>
>> Yes, sorry, I'm not talking about other CPUs and what they see, I'm
>> talking about the local one.  I'm not assuming that this is SMP "safe"
>> at all.  If it is supposed to be, then yes, we do have problems, but
>> there should be a lock _somewhere_ protecting this.
>>
>> Peter's emails seem to be bouncing horridly right now, otherwise he
>> would chime in and set me straight as to how this all should be
>> working...
> 
> Sorry for the bouncing emails; something is wrong with my hosting
> because I'm just now seeing these emails but not my inbox mails :/
> 
> I need to spend some time looking at this.
> 
> Regards,
> Peter Hurley
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

