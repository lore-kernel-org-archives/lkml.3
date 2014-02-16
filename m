Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaBPXFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:05:39 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55195 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaBPXFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:05:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140216204754.GA16757@kroah.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com> <20140216204754.GA16757@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 17 Feb 2014 00:05:15 +0100
Message-ID: <CAPXgP12qGJwzmDw_Zf0N-sp6FQ3-0M8rK2QEwUGivD+j0siS0g@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Debabrata Banerjee <dbanerje@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, dbavatar@gmail.com, johunt@akamai.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 9:47 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Feb 16, 2014 at 11:28:36AM -0800, Linus Torvalds wrote:
>> Adding Kay and Greg, since the original code is from commit
>> 7ff9554bb578 ("printk: convert byte-buffer to variable-length record
>> buffer") and all the "prev" flag tweaks end up building on top of
>> that.
>>
>> The whole "prev flags" is messed up, and LOG_CONT is done very confusingly.
>>
>> Why are *those* particular two "prev = msg->flags" incorrect, when
>> every other case where we walk the messages they are required?
>>
>> The code/logic makes no sense. You remove the "prev = msg->flags" at
>> line 1070, when the *identical* loop just above it has it. So now the
>> two loops count the number of characters differently. That makes no
>> sense.
>>
>> So I don't think this fixes the fundamental problem. I'm more inclined
>> to believe that LOG_CONT is wrongly set somewhere, for example because
>> a continuation wasn't actually originally printed due to coming from
>> different users or something like that.
>>
>> Or at the very least I want a coherent explanation why one loop would
>> do this and the other would not, and why counting up *different*
>> numbers could possibly make sense.
>>
>> Because as it is, there clearly is some problem, but the patch does
>> not look sensible to me.
>
> Yeah, it doesn't make much sense to me either.
>
> Kay had a printk() test module that would stress these types of paths
> out a bunch, Kay, is that module around somewhere that we could maybe
> add it to the kernel tree so it could be used to test changes like this?

The module hack only tested the new stuff, not the legacy syslog() interface.

There is a bug in syslog_print_all(). We calculate the size of the
entire buffer for the plain text output including all the needed
headers, then we start to drop messages from the start, until the
result fits into the output buffer, and we start copying it.

Some of the lines get a header printed, cont lines don't. While
dropping messages from the start, if we end up at a line that did not
get a header added in the size calculation, we still add the header
now when copying it out as the first line.

We don't account for the size of this one additional header, and
therefore might end up writing up to 18 chars (syslog + time) to many.

I'll fix that tomorrow. Dropping the prev = in the loop avoids the
problem, but it will also result in fewer messages to be copied than
we could. We only have to account for the first header.

Thanks,
Kay
