Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaJWM4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:56:38 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64386 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaJWM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:56:37 -0400
Message-ID: <5448FB01.1090108@mentor.com>
Date: Thu, 23 Oct 2014 15:56:33 +0300
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] fs: sysfs: return EFBIG on write if offset is
 larger than binary file size
References: <1412876515-12057-1-git-send-email-vladimir_zapolskiy@mentor.com> <20141009184631.GA17554@mtj.dyndns.org>
In-Reply-To: <20141009184631.GA17554@mtj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On 09.10.2014 21:46, Tejun Heo wrote:
> Hello, Vladimir.
> 
> On Thu, Oct 09, 2014 at 08:41:55PM +0300, Vladimir Zapolskiy wrote:
>> According to the user expectations common utilities like dd or sh
>> redirection operator '>' should work correctly over binary files from
>> sysfs. At the moment doing excessive write can not be ever completed
>> (no error is returned), e.g. for 4-byte file:
>>
>>   write(1, "\0\0\0\0\0\0\0\0", 8)         = 4
>>   write(1, "\0\0\0\0", 4)                 = 0
>>   write(1, "\0\0\0\0", 4)                 = 0
>>   write(1, "\0\0\0\0", 4)                 = 0
>>   write(1, "\0\0\0\0", 4)                 = 0
>>   write(1, "\0\0\0\0", 4)                 = 0
>>   .......
>>
>> This is not a successful completion of write(2), so fix the problem by
>> returning EFBIG as described in POSIX.1-2001:
>>
>>   [EFBIG]
>>     The file is a regular file, nbyte is greater than 0, and the
>>     starting position is greater than or equal to the offset maximum
>>     established in the open file description associated with fildes.
>>
>> Note, the write(2) ABI is changed, however
>> 1) write(2) behaviour is corrected in conformance to POSIX, the
>>    existing userspace applications must be aware of possible errors on
>>    a syscall,
>> 2) the return value is changed on error path, so it is an exceptional
>>    situation,
>> 3) the change is related only to binary sysfs files, which is a very
>>    small class of files, mainly representing non-volatile registers or
>>    ram, eeproms etc, many of such files are read-only.
>>
>> Presumably it is safe to apply the change, the described problem is
>> definitely in the kernel and userspace utilities can not be changed to
>> process 0 return value as an error, because it is just not an error
>> according to POSIX.
>>
>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Tejun Heo <tj@kernel.org>
> 
> This is a bit risky but the current behavior is problematic and as you
> pointed out the danger of actual breakge is relatively low.  We might
> as well give it a shot.
> 
>  Cautiously-acked-by: Tejun Heo <tj@kernel.org>
> 
> Please also cc stable.
> 
> Thanks.

have you had time to look at the problem? Understanding the risk of the
change, should the inconsistency with POSIX be documented in
Documentation/ABI/stable/syscalls instead?

With best wishes,
Vladimir
