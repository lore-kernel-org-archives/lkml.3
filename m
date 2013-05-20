Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3ETXlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:41:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3ETXly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:41:54 -0400
Date: Mon, 20 May 2013 16:41:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
Message-Id: <20130520164152.9148828cc29fab3d3d02be23@linux-foundation.org>
In-Reply-To: <1367270313-18871-4-git-send-email-phdm@macqel.be>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
	<1367270313-18871-4-git-send-email-phdm@macqel.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013 23:18:31 +0200 Philippe De Muyter <phdm@macqel.be> wrote:

> Graft AIX partitions enumeration in partitions/msdos.c
> 
> There is already a AIX disks detection logic in msdos.c.  When an
> AIX disk has been found, and if configured to, call the aix partitions
> recognizer.  This avoids removal of AIX disks protection from msdos.c,
> avoids code duplication, and ensures that AIX partitions enumeration
> is called before plain msdos partitions enumeration.
> 
> ...
>
> --- a/block/partitions/msdos.c
> +++ b/block/partitions/msdos.c
> @@ -23,6 +23,7 @@
>  #include "check.h"
>  #include "msdos.h"
>  #include "efi.h"
> +#include "aix.h"
>  
>  /*
>   * Many architectures don't like unaligned accesses, while
> @@ -462,8 +463,12 @@ int msdos_partition(struct parsed_partitions *state)
>  	 */
>  	if (aix_magic_present(state, data)) {
>  		put_dev_sector(sect);
> +#ifdef CONFIG_AIX_PARTITION
> +		return aix_partition(state);
> +#else
>  		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
>  		return 0;
> +#endif
>  	}
>  
>  	if (!msdos_magic_present(data + 510)) {

hm, what's going on here.

Why does partitions/msdos.c know about AIX at all?  Is there something
special about AIX partitioning which ties it in with msdos?

Now that we have AIX partitioning support, can we simply remove the AIX
code from msdos.c?  So msdos.c will say "I don't know what that is",
and we fall through to aix.c which says "that's mine!"?

