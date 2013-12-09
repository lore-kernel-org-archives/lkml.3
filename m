Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303Ab3LIRKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:10:12 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34186 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856Ab3LIRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:10:07 -0500
Message-ID: <52A5F96A.6030900@hurleysoftware.com>
Date: Mon, 09 Dec 2013 12:10:02 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>, Pavel Machek <pavel@ucw.cz>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, Caylan Van Larson <i@caylan.net>
Subject: Re: [PATCH v3] n_tty: Fix buffer overruns with larger-than-4k pastes
References: <529F7B35.4050509@list.ru> <1386600604-5092-1-git-send-email-peter@hurleysoftware.com> <52A5EF3F.2070805@list.ru>
In-Reply-To: <52A5EF3F.2070805@list.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 11:26 AM, Stas Sergeev wrote:
> 09.12.2013 18:50, Peter Hurley пишет:
>>   	if (found && read_buf(ldata, eol) == __DISABLED_CHAR) {
>>   		n--;
>>   		eof_push = !n && ldata->read_tail != ldata->line_start;
>> +		ldata->push = 0;
>>   	}
> Will this work if the last (and only) char written in raw
> mode appear to be \0 (__DISABLED_CHAR)?

That would have triggered an EOF in older kernels so not a
regression.

>
>> -		ldata->line_start = ldata->read_tail;
>> +		if (!ldata->push)
>> +			ldata->line_start = ldata->read_tail;
>> +		else
>> +			ldata->push = 0;
> Will this work if more that one "fake" EOF is accumulated
> in bitmap because of multiple icanon switches?

Not possible. The read_flags and push indicator are reset
with icanon -> !icanon switches.

> Also, I am a bit surprised with the presence of the code
> like this:
> ---
>
> |	if  (n>  4096)
> 		n+=  4096;
> |
>
> ---
> Am I the only one thinking it is unclear what it does?
> Doesn't it deserve the comment at least?
>
> Or this:
> ---
>
> |eof_push= !n&&  ldata->read_tail!=  ldata->line_start;|
>
> ---
> If eof_push means that the EOL mark was found not at the
> line start, then it is completely confusing why !n is here
> (one have to read a lot of context to find out why).|||
> When I created the patch, the code was much more easy
> to follow than now.

The previous kernels did byte-by-byte copy with lock/unlock
for every byte, into the input buffer and back out of the input
buffer. Simple, but inefficient.

This version has roughly 4n-2 fewer bus locks. The necessary
unsigned arithmetic and additional condition checks make the
code somewhat more complex.

But please feel free to submit patches that fix or clarify
anything you find.

Regards,
Peter Hurley
