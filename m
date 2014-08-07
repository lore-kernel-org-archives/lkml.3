Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaHGQBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:01:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:28167 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGQBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:01:52 -0400
X-CheckPoint: {53E3A2EF-1-2100090A-C0000000}
Message-ID: <53E3A2EF.1010701@tilera.com>
Date: Thu, 7 Aug 2014 12:01:51 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: new generic strscpy API? (was Re: [PATCH v2] tile: avoid errors from
 truncating long strings in mpipe gxio)
References: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>  <53E13D78.6000903@tilera.com>  <CAFo99gZ1rOqD-RFN7Shx4mWO4kfVLCXpuxUWqOwK5uY6uwAh3Q@mail.gmail.com> <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com> <53E32022.2090006@infradead.org>
In-Reply-To: <53E32022.2090006@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2014 2:43 AM, Randy Dunlap wrote:
> On 08/06/14 11:16, Chris Metcalf wrote:
>> Using strncpy() will just silently truncate long strings; we should
>> instead return an appropriate error.  Using strlcpy() would suffer from
>> the same problem.  Instead, use strnlen()+memcpy(), and add an
>> error-checking step to make sure the lengths are reasonable.
>>
>> I called the convenience wrapper strscpy(), and a case could be made for
>> making it more generic (possibly with a better name), but that seems
>> outside the scope of this initial commit.
> Well, having looked at the function before I read this comment, my first
> thought was that it should be added to lib/string.c for general
> availability.

I'm happy to do that, but it probably shouldn't go through the linux-tile
tree in that case, since I'd be touching platform-independent code.
If someone wants to volunteer to push a new lib/strscpy.c change to Linus
(presumably including the arch/tile caller) I'm happy to redo this commit
in that form.

My guess is that we also haven't hit the mandatory minimum of
bike-shedding around function name and precise semantics yet, anyway :-)

I will hold off on pushing this change until a bit later in the merge
window to see if anyone wants to jump in.

>> diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
>> index 5301a9ffbae1..27a56be8d583 100644
>> --- a/arch/tile/gxio/mpipe.c
>> +++ b/arch/tile/gxio/mpipe.c
>> @@ -29,6 +29,25 @@
>>   /* HACK: Avoid pointless "shadow" warnings. */
>>   #define link link_shadow
>>   
>> +/*
>> + * Use this routine to avoid copying too-long strings.  Unlike strncpy
>> + * or strlcpy, we don't enable programmers who don't check return codes;
>> + * partially-copied strings can be problematic.  The routine returns
>> + * the total number of bytes copied (including the trailing NUL) or
>> + * zero if the buffer wasn't big enough.
>> + */
>> +static size_t strscpy(char *dest, const char *src, size_t size)
>> +{
>> +	size_t ret = strnlen(src, size) + 1;
>> +	if (ret > size) {
>> +		if (size)
>> +			dest[0] = '\0';
>> +		return 0;
>> +	}
>> +	memcpy(dest, src, ret);
>> +	return ret;
>> +}

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

