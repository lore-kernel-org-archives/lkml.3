Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbbABXfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:35:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:35:38 -0500
Date: Fri, 2 Jan 2015 15:35:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH akpm/next] lib: crc32: conditionally constify crc32
 lookup table
Message-Id: <20150102153537.2251ca287e96446eaf229ae2@linux-foundation.org>
In-Reply-To: <1420052608-30515-1-git-send-email-dborkman@redhat.com>
References: <1420052608-30515-1-git-send-email-dborkman@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2014 20:03:28 +0100 Daniel Borkmann <dborkman@redhat.com> wrote:

> Commit 8f243af42ade ("sections: fix const sections for crc32 table")

The 8f243af42ade changelog is rather poor :(.  With the help of this
changelog I can now see what 8f243af42ade was doing.  I must have been
asleep at the time.

> removed the compile-time generated crc32 tables from the RO sections,
> because it conflicts with the definition of __cacheline_aligned
> which puts all such aligned data into .data..cacheline_aligned section
> optimized for wasting less space, and causes const align issues with
> some GCC versions (see #52181, for example).

(searches several bugzilla databases)

"https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52181" would be more
reader-friendly.

> We can fix that in two steps: 1) by using the ____cacheline_aligned
> version, which only aligns the data but doesn't move it into specific
> sections, 2) test GCC and in problematic cases fall back to the current
> code, otherwise use const and proper alignment for the lookup tables.
> 
> After patch tables are in RO:
> 
> $ nm -v lib/crc32.o | grep -1 -E "crc32c?table"
> 0000000000000000 t arch_local_irq_enable
> 0000000000000000 r crc32ctable_le
> 0000000000000000 t crc32_exit
> --
> 0000000000000960 t test_buf
> 0000000000002000 r crc32table_be
> 0000000000004000 r crc32table_le
> 000000001d1056e5 A __crc_crc32_be
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Joe Mario <jmario@redhat.com>
> ---
>  Makefile                   |  5 +++++
>  lib/Makefile               |  3 +++
>  lib/gen_crc32table.c       | 21 +++++++++++++++------
>  scripts/gcc-const-align.sh | 21 +++++++++++++++++++++
>  4 files changed, 44 insertions(+), 6 deletions(-)

Seems a lot of fuss.  Why are these tables cacheline aligned anyway? 
To avoid one cache miss (most of the time, presumably) in a 16k table. 
Pretty marginal benefit, I suspect.

> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -171,6 +171,9 @@ obj-$(CONFIG_FONT_SUPPORT) += fonts/
>  hostprogs-y	:= gen_crc32table
>  clean-files	:= crc32table.h
>  
> +# We need to transfer this flag to the host compiler if present
> +HOSTCFLAGS_gen_crc32table.o := $(findstring -DCC_HAVE_CONST_ALIGN,$(KBUILD_CFLAGS))
> +
>  $(obj)/crc32.o: $(obj)/crc32table.h
>  
>  quiet_cmd_crc32 = GEN     $@
> diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
> index 71fcfcd..2f06893 100644
> --- a/lib/gen_crc32table.c
> +++ b/lib/gen_crc32table.c
> @@ -21,6 +21,14 @@
>  # define BE_TABLE_SIZE (1 << CRC_BE_BITS)
>  #endif
>  
> +#ifdef CC_HAVE_CONST_ALIGN
> +# define TABLE_CONST_ATTR "const"
> +# define TABLE_ALIGNMENT  "____cacheline_aligned"
> +#else
> +# define TABLE_CONST_ATTR ""
> +# define TABLE_ALIGNMENT  "__cacheline_aligned"
> +#endif

Pity out poor readers, trying to work out what all this does and why it
is here.  It is totally unobvious that this is working around some gcc
bug.  Can we please have a nice comment which explains everything?


