Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbaAJP5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:57:23 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42625 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAJP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:57:20 -0500
Message-ID: <52D01860.6060801@gmail.com>
Date: Fri, 10 Jan 2014 23:57:20 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggest] arch: metag: compiler: Are they compiler's issues?
References: <52B8F33C.3030808@gmail.com> <52CA85FF.8050604@imgtec.com> <52CD6849.4050007@gmail.com>
In-Reply-To: <52CD6849.4050007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 11:01 PM, Chen Gang wrote:
> On 01/06/2014 06:31 PM, James Hogan wrote:
>> I suspect this is due to bad assumptions in the code. The metag ABI is
>> unusual in padding the size of structs to a 32bit boundary even if all
>> members are <32bit. This is actually permitted by the C standard but
>> it's a bit of a pain. e.g.
>>
>> struct s {
>> 	short x
>> 	struct {
>> 		short x[3];
>> 	} y;
>> 	short z;
>> };
>>
>> on x86
>> 	alignof(s::y) == 2
>> 	s::y at offset 2
>> 	sizeof(s::y) == 6
>> 	s::z at offset 6+2 = 8
>> 	sizeof(struct s) == 10
>>
>> but on metag
>> 	alignof(s::y) == 4
>> 	s::y at offset 4
>> 	sizeof(s::y) == 8 (padding, this is what catches people out)
>> 	s::z at offset 4+8 = 12
>> 	sizeof(struct s) == 16 (and here too)
>>
>> Adding packed attribute on outer struct reduces sizeof(struct s) to 12
>> on metag:
>> 	alignof(s::y) == 4
>> 	s::y at offset 2 (packed)
>> 	sizeof(s::y) == 8 (still padded)
> 
> In my memory, when packed(2), it breaks the C standard (although I am
> not quit sure).
> 
> And I guess, all C programmers will assume it will be 6 when within
> pack(2) or pack(1).
> 
>> 	s::z at offset 2+8 = 10
>> 	sizeof(struct s) == 12 (packed)
>>
>> Also reduced to 12 if only inner struct is marked packed:
>> 	alignof(s::y) == 2
>> 	s::y at offset 2
>> 	sizeof(s::y) == 6 (packed)
>> 	s::z at offset 2+6 = 8
>> 	sizeof(struct s) == 12 (still padded)
>>
>> Adding packed attribute on both outer and inner struct reduces
>> sizeof(struct s) to 10 to match x86.
>>
>> Unfortunately it's years too late to change this ABI, so we're stuck
>> with it.
>>
> 
> Unfortunately too, most using cases are related with API (the related
> structure definition must be the same in binary data).
> 
> I am sure there are still another ways to bypass this issue, but that
> will make the code looks very strange (especially they are API).
> 
> :-(
> 

I guess most C programmers will use this way to describe protocol/data
format, and keep compatible for it (since it is API).

So even if it really does not break C standard, I still recommend our
compiler to improve itself to support this features.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
