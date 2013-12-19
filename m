Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3LSCkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:40:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LSCkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:40:19 -0500
Date: Wed, 18 Dec 2013 16:55:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [RFC 1/2] CRC32 Add GenWQE CRC to kernel CRC code
Message-ID: <20131219005557.GB32112@kroah.com>
References: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
 <1386780563-1722-1-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386780563-1722-1-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 05:49:22PM +0100, Frank Haverkamp wrote:
> Our GenWQE driver is using a CRC32 polynom, which as far as I could
> see, no one else is using in the kernel. In its original version we
> implemented our own CRC32, but I think it is nicer to use the common
> code as suggested by Greg.
> 
> I did not want to add yet another crc32g_table and waste (1KiB) memory
> when no one else is using it. I tried to externalize the
> crc32init_be_generic and crc32_be_generic functions. I failed. The
> crc32init* I found is used to autogenerate code can is itself not part
> of the resulting kernel.
> 
> As result I gave up on that approach and just added the GenWQE special
> polynom in addition to the other 3 crc tables. I wanted to figure out
> if it is possible in principle to use the generic code.
> 
> Is the consumption of 1KiB for a little table justifyable if it 
> currently has just one user?
> 
> Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> ---
>  include/linux/crc32.h |    2 	2 +	0 -	0 !
>  lib/crc32.c           |   10 	10 +	0 -	0 !
>  lib/crc32defs.h       |    5 	5 +	0 -	0 !
>  lib/gen_crc32table.c  |   39 	31 +	8 -	0 !
>  4 files changed, 48 insertions(+), 8 deletions(-)

What kind of crazy diffstat is that?  What generated it?

> 
> --- a/include/linux/crc32.h
> +++ b/include/linux/crc32.h
> @@ -11,6 +11,8 @@
>  extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
>  extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
>  
> +extern u32  __crc32g_be(u32 crc, unsigned char const *p, size_t len);

Ick, don't export __ functions, that means something is not quite right
with the api, don't you agree?

Why not just export crc32g_be() and make the changes inside the crc32.c
file to handle that?

thanks,

greg k-h
