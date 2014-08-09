Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaHIOTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:19:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaHIOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:19:32 -0400
Date: Sat, 9 Aug 2014 07:18:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
Message-ID: <20140809141847.GC21639@kroah.com>
References: <20140808075316.GA21919@www.outflux.net>
 <CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
 <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:06:41PM -0700, Kees Cook wrote:
> On Fri, Aug 8, 2014 at 10:11 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> > On Fri, Aug 8, 2014 at 3:53 AM, Kees Cook <keescook@chromium.org> wrote:
> >> To avoid potential format string expansion via module parameters,
> >> do not use the zpool type directly in request_module() without a
> >> format string. Additionally, to avoid arbitrary modules being loaded
> >> via zpool API (e.g. via the zswap_zpool_type module parameter) add a
> >> "zpool-" prefix to the requested module, as well as module aliases for
> >> the existing zpool types (zbud and zsmalloc).
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  mm/zbud.c     | 1 +
> >>  mm/zpool.c    | 2 +-
> >>  mm/zsmalloc.c | 1 +
> >>  3 files changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/zbud.c b/mm/zbud.c
> >> index a05790b1915e..aa74f7addab1 100644
> >> --- a/mm/zbud.c
> >> +++ b/mm/zbud.c
> >> @@ -619,3 +619,4 @@ module_exit(exit_zbud);
> >>  MODULE_LICENSE("GPL");
> >>  MODULE_AUTHOR("Seth Jennings <sjenning@linux.vnet.ibm.com>");
> >>  MODULE_DESCRIPTION("Buddy Allocator for Compressed Pages");
> >> +MODULE_ALIAS("zpool-zbud");
> >
> > If we keep this, I'd recommend putting this inside the #ifdef
> > CONFIG_ZPOOL section, to keep all the zpool stuff together in zbud and
> > zsmalloc.
> >
> >> diff --git a/mm/zpool.c b/mm/zpool.c
> >> index e40612a1df00..739cdf0d183a 100644
> >> --- a/mm/zpool.c
> >> +++ b/mm/zpool.c
> >> @@ -150,7 +150,7 @@ struct zpool *zpool_create_pool(char *type, gfp_t gfp, struct zpool_ops *ops)
> >>         driver = zpool_get_driver(type);
> >>
> >>         if (!driver) {
> >> -               request_module(type);
> >> +               request_module("zpool-%s", type);
> >
> > I agree with a change of (type) to ("%s", type), but what's the need
> > to prefix "zpool-"?  Anyone who has access to modify the
> > zswap_zpool_type parameter is already root and can just as easily load
> > any module they want.  Additionally, the zswap_compressor parameter
> > also runs through request_module() (in crypto/api.c) and could be used
> > to load any kernel module.
> 
> Yeah, the "%s" should be the absolute minimum. :)
> 
> > I'd prefer to leave out the "zpool-" prefix unless there is a specific
> > reason to include it.
> 
> The reason is that the CAP_SYS_MODULE capability is supposed to be
> what controls the loading of arbitrary modules, and that's separate
> permission than changing module parameters via sysfs
> (/sys/modules/...). Which begs the question: maybe those parameters
> shouldn't be writable without CAP_SYS_MODULE? Greg, any thoughts here?
> kobjects don't seem to carry any capabilities checks.

Some module parameters are ment to be set by anyone, without any
capability permissions, that's why they have a file mode set on them by
the module author.  Adding a CAP_SYS_MODULE check would probably not be
a good idea.

thanks,

greg k-h
