Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaCaNov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:44:51 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43499 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaCaNos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:44:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140331133637.GA24528@mwanda>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
	<CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
	<20140331133637.GA24528@mwanda>
Date: Mon, 31 Mar 2014 15:44:47 +0200
Message-ID: <CAOMGZ=E+zn-XZpfquP6jcCXxFY3CwN9j5X_iC6B_93o5222VHg@mail.gmail.com>
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2014 15:36, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Mar 31, 2014 at 02:56:07PM +0200, Vegard Nossum wrote:
>> Ping, Dave? Just making sure this doesn't fall through the cracks. I
>> don't see the patch applied anywhere yet and without this patch we
>> still have a valid security concern IMO.
>
> Gar.  No...  To recap:
>
>> On 7 March 2014 11:56, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>> > Both the in-kernel and BSD strlcpy() require that the source string is
>> > NUL terminated.
>
> The *whole point* of strlcpy() is that the source string doesn't have to
> be NUL terminated.  The BSD man pages are trying to say that strlcpy()
> only works on C-strings as opposed to Vstr or other safer string
> implementions.

I read the BSD man page differently. Also, if you look at the actual
BSD implementation, it also scans the remaining buffer until it hits a
0.

I quote again: "for strlcpy() src must be NUL-terminated". It doesn't
get much clearer than that.

> There is a potential problem in the kernel implementation of strlcpy()
> because it does:
>
> lib/string.c
>    149  size_t strlcpy(char *dest, const char *src, size_t size)
>    150  {
>    151          size_t ret = strlen(src);
>    152
>    153          if (size) {
>    154                  size_t len = (ret >= size) ? size - 1 : ret;
>    155                  memcpy(dest, src, len);
>    156                  dest[len] = '\0';
>    157          }
>    158          return ret;
>    159  }
>
> The strlen() on line 151 could read beyond the end of the source buffer
> and if the memory wasn't mapped, it could Oops.
>
> That concern doesn't apply here because the source string is on stack
> memory and we will hit a NUL character before we hit unmapped memory.

As before, I agree that it's _likely_ we'll hit a 0 before hitting
unmapped memory, but I don't see at all that we have a guarantee of
it.


Vegard
