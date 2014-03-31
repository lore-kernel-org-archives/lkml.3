Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaCaNgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:36:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43745 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaCaNgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:36:38 -0400
Date: Mon, 31 Mar 2014 16:36:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
Message-ID: <20140331133637.GA24528@mwanda>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
 <CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 02:56:07PM +0200, Vegard Nossum wrote:
> Ping, Dave? Just making sure this doesn't fall through the cracks. I
> don't see the patch applied anywhere yet and without this patch we
> still have a valid security concern IMO.

Gar.  No...  To recap:

> On 7 March 2014 11:56, Vegard Nossum <vegard.nossum@oracle.com> wrote:
> > Both the in-kernel and BSD strlcpy() require that the source string is
> > NUL terminated.

The *whole point* of strlcpy() is that the source string doesn't have to
be NUL terminated.  The BSD man pages are trying to say that strlcpy()
only works on C-strings as opposed to Vstr or other safer string
implementions.

There is a potential problem in the kernel implementation of strlcpy()
because it does:

lib/string.c
   149  size_t strlcpy(char *dest, const char *src, size_t size)
   150  {
   151          size_t ret = strlen(src);
   152
   153          if (size) {
   154                  size_t len = (ret >= size) ? size - 1 : ret;
   155                  memcpy(dest, src, len);
   156                  dest[len] = '\0';
   157          }
   158          return ret;
   159  }

The strlen() on line 151 could read beyond the end of the source buffer
and if the memory wasn't mapped, it could Oops.

That concern doesn't apply here because the source string is on stack
memory and we will hit a NUL character before we hit unmapped memory.

regards,
dan carpenter
