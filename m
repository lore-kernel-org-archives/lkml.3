Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaCGMoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:44:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCGMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:44:23 -0500
Message-ID: <5319BF21.6080400@oracle.com>
Date: Fri, 07 Mar 2014 13:44:17 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com> <20140307112655.GJ4774@mwanda> <5319B094.7060709@oracle.com> <20140307115253.GL4774@mwanda>
In-Reply-To: <20140307115253.GL4774@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 12:52 PM, Dan Carpenter wrote:
> On Fri, Mar 07, 2014 at 12:42:12PM +0100, Vegard Nossum wrote:
>> On 03/07/2014 12:26 PM, Dan Carpenter wrote:
>>> On Fri, Mar 07, 2014 at 11:56:04AM +0100, Vegard Nossum wrote:
>>>> Both the in-kernel and BSD strlcpy() require that the source string is
>>>> NUL terminated.
>>>
>>> No.  You're obviously wrong.  What on earth?
>>
>> Well, from lib/string.c:
>>
>> size_t strlcpy(char *dest, const char *src, size_t size)
>> {
>>          size_t ret = strlen(src);
>>
>
> Ah...  So you mean that we could read far beyond the end of the string
> and it would be a DoS because there would be 4 gigs of memory before we
> hit a NUL character.  That won't happen in this case because the user
> only controls a small buffer.  Normal memory is full of NUL chars.

Well, that's true, but what happens if you accidentally read from an 
unmapped page or an mmio page?

I agree that it's not likely to happen in practice, but that's true for 
a lot of kernel bugs that we nevertheless want to fix. Are you saying 
that the patch is bad or wrong?

> I don't know the speed impact of changing the strlen() there to
> strnlen().

I don't think we could or should do that, because it changes the 
semantics of the function.  I think C string operations are probably 
confusing enough already without breaking compatibility with existing 
documentation and other implementations.

Also, the size parameter is the size of the destination buffer, not the 
source string. So even if we could make it safe to use strnlen() in this 
case, it still wouldn't be safe in other cases where the source string 
is shorter than the destination.

>
>> The BSD man page:
>>
>> "Also note that strlcpy() and strlcat() only operate on true ``C''
>> strings.  This means that for strlcpy() src must be NUL-terminated
>> and for strlcat() both src and dst must be NUL-terminated."
>
> It's talking about the kind of strings.  If it's a string which includes
> NUL characters the strlcpy() won't work for that.  Or if it is not
> *supposed* to end in a NUL character then it won't work for that.
>
> We are using C strings here.

I think the man page is quite clear: "for strlcpy() src must be 
NUL-terminated". Without the patch, this is not necessarily the case.


Vegard
