Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaAJQiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:38:55 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41206 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAJQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:38:50 -0500
Message-ID: <52D0221B.9010107@gmail.com>
Date: Sat, 11 Jan 2014 00:38:51 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggest] arch: metag: compiler: Are they compiler's issues?
References: <52B8F33C.3030808@gmail.com> <52CA85FF.8050604@imgtec.com> <52CD6849.4050007@gmail.com> <52D01860.6060801@gmail.com> <52D019A2.9000705@imgtec.com> <52D01DBE.6010205@gmail.com> <52D02013.8030009@imgtec.com>
In-Reply-To: <52D02013.8030009@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2014 12:30 AM, James Hogan wrote:
> On 10/01/14 16:20, Chen Gang wrote:
>> On 01/11/2014 12:02 AM, James Hogan wrote:
>>> On 10/01/14 15:57, Chen Gang wrote:
>>>> On 01/08/2014 11:01 PM, Chen Gang wrote:
>>>>> On 01/06/2014 06:31 PM, James Hogan wrote:
>>>>>> I suspect this is due to bad assumptions in the code. The metag ABI is
>>>>>> unusual in padding the size of structs to a 32bit boundary even if all
>>>>>> members are <32bit. This is actually permitted by the C standard but
>>>>>> it's a bit of a pain. e.g.
>>>>>>
>>>>>> struct s {
>>>>>> 	short x
>>>>>> 	struct {
>>>>>> 		short x[3];
>>>>>> 	} y;
>>>>>> 	short z;
>>>>>> };
>>>>>>
>>>>>> on x86
>>>>>> 	alignof(s::y) == 2
>>>>>> 	s::y at offset 2
>>>>>> 	sizeof(s::y) == 6
>>>>>> 	s::z at offset 6+2 = 8
>>>>>> 	sizeof(struct s) == 10
>>>>>>
>>>>>> but on metag
>>>>>> 	alignof(s::y) == 4
>>>>>> 	s::y at offset 4
>>>>>> 	sizeof(s::y) == 8 (padding, this is what catches people out)
>>>>>> 	s::z at offset 4+8 = 12
>>>>>> 	sizeof(struct s) == 16 (and here too)
>>>>>>
>>>>>> Adding packed attribute on outer struct reduces sizeof(struct s) to 12
>>>>>> on metag:
>>>>>> 	alignof(s::y) == 4
>>>>>> 	s::y at offset 2 (packed)
>>>>>> 	sizeof(s::y) == 8 (still padded)
>>>>>
>>>>> In my memory, when packed(2), it breaks the C standard (although I am
>>>>> not quit sure).
>>>>>
>>>>> And I guess, all C programmers will assume it will be 6 when within
>>>>> pack(2) or pack(1).
>>>>>
>>>>>> 	s::z at offset 2+8 = 10
>>>>>> 	sizeof(struct s) == 12 (packed)
>>>>>>
>>>>>> Also reduced to 12 if only inner struct is marked packed:
>>>>>> 	alignof(s::y) == 2
>>>>>> 	s::y at offset 2
>>>>>> 	sizeof(s::y) == 6 (packed)
>>>>>> 	s::z at offset 2+6 = 8
>>>>>> 	sizeof(struct s) == 12 (still padded)
>>>>>>
>>>>>> Adding packed attribute on both outer and inner struct reduces
>>>>>> sizeof(struct s) to 10 to match x86.
>>>>>>
>>>>>> Unfortunately it's years too late to change this ABI, so we're stuck
>>>>>> with it.
>>>>>>
>>>>>
>>>>> Unfortunately too, most using cases are related with API (the related
>>>>> structure definition must be the same in binary data).
>>>>>
>>>>> I am sure there are still another ways to bypass this issue, but that
>>>>> will make the code looks very strange (especially they are API).
>>>>>
>>>>> :-(
>>>>>
>>>>
>>>> I guess most C programmers will use this way to describe protocol/data
>>>> format, and keep compatible for it (since it is API).
>>>>
>>>> So even if it really does not break C standard, I still recommend our
>>>> compiler to improve itself to support this features.
>>>
>>> The compiler cannot change this without breaking the ABI.
>>>
>>> If the structure describes a set-in-stone data layout (which it sounds
>>> like it does since it asserts the size of it) then the correct fix is to
>>> pack the structures in such a way as to guarantee the correct offsets
>>> and sizes on all compliant compilers. Otherwise if it's just an internal
>>> programming API it shouldn't be using compile time asserts to enforce
>>> things that vary between ABIs.
>>>
>>
>> OK, thanks, I guess your meaning is:
>>
>> 	struct s {
>> 		short x;
>> 		struct {
>> 			short x[3];
>> 		} y __attribute__ ((packed));
>> 		short z;
>> 	} __attribute__ ((packed));
>>
>> That will satisfy all of compilers (include metag), is it correct?
> 
> Yes, that's what I mean (although probably best to use the __packed
> macro rather than __attribute__ ((packed)) ).
> 

OK, thanks, and excuse me, during these days, I have no quite enough
time for upstream kernel.

So, I plan that I will/should send related patches for it within next
week end (2014-01-19), if it is too long to bear it, please help send
related patches for it, thanks.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
