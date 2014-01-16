Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaAPLI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:08:29 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:53442 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaAPLIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:08:25 -0500
Message-ID: <52D7BDA3.2000407@mev.co.uk>
Date: Thu, 16 Jan 2014 11:08:19 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Hartley Sweeten <HartleyS@visionengravers.com>
CC: Chase Southwood <chase.southwood@yahoo.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com> <20140115035849.GA13127@kroah.com> <DC148C5AA1CEBA4E87973D432B1C2D8817E79783@P3PWEX4MB008.ex4.secureserver.net> <20140116023040.GB31275@kroah.com>
In-Reply-To: <20140116023040.GB31275@kroah.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-16 02:30, Greg KH wrote:
> On Wed, Jan 15, 2014 at 06:29:21PM +0000, Hartley Sweeten wrote:
>> On Tuesday, January 14, 2014 8:59 PM, Greg KH wrote:
>>> Sleep for at least 10, as I think that's the smallest time delay you can
>>> sleep for anyway (meaning it will be that long no matter what number you
>>> put there less than 10, depending on the hardware used of course.)
>>
>> A bit off topic here but I have a somewhat related question about timeouts.
>>
>> There are a number of comedi drivers that do a "wait for end-of-conversion"
>> as part of the (*insn_read) for an analog input subdevice or (*insn_write) for
>> an analog output subdevice. These functions return an errno if a timeout occurs.
>>
>> Currently either -ETIME or -ETIMEDOUT is returned. This errno ends up getting
>> returned to the user as the result of the unlocked_ioctl file operation. What is
>> the more appropriate errno? Or is there is better one that should be used?
>
> I think they should all be -ETIMEDOUT, -ETIME is used for something
> else, and shouldn't be sent to userspace as I don't think it knows what
> to do with it.

Linux libc ought to deal with both.  glibc 2.17 has the following error 
strings in the "C" locale:

ETIMEDOUT --> "Connection timed out"
ETIME --> "Timer expired"

I think BSD has:

ETIMEDOUT --> "Operation timed out"
ETIME doesn't exist

so -ETIMEDOUT is better, even though the error string is a bit dodgy in 
some cases under Linux.  This betrays the original purpose of the 
ETIMEDOUT error code, in the same way that the identifier and original 
purpose of the ENOTTY error code is betrayed by the original error 
string "Not a typewriter" (which is now "Inappropriate ioctl for device" 
in current glibc).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
