Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaFRT45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:56:57 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:48448 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaFRT4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <53A1D3A1.70202@gmail.com>
References: <53A1D3A1.70202@gmail.com>
Date: Wed, 18 Jun 2014 12:56:53 -0700
Message-ID: <CAADnVQJVmtkvdGTDmLh9YDvLvDF+-SQ9WW0H_pp7HwfWciLS3A@mail.gmail.com>
Subject: Re: 9da0763 "kbuild: Use relative path ..." Broke my IDE
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Boaz Harrosh <openosd@gmail.com>, Ilya Dryomov <idryomov@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:00 AM, Boaz Harrosh <openosd@gmail.com> wrote:
> Hi Sir Michal
>
> Below patch broke my stupid yet useful IDE tool. I use kdevelop.
>
> kdevelop now gets confused on warnings and errors because it now comes out
> as (for example):
> ../fs/ext4/fsync.c:63:3: error: implicit declaration of function ‘iputddd’ [-Werror=implicit-function-declaration]
>
> From what I understand kdevelop picks up the "[make] cd ..." outputs from make and
> will interpret those for finding gcc files output. But Linux Makefile will suppress
> these messages and kdevelop as no way to interpret the "../xxxx"
>
> I do not know what other IDEs do, but this one here is not smart enough.
>
> Could we please define a new input to Makefile that will revert to
> old behavior. like:
>         KBUILD_FULL_PATH
>
> let me cook up a patch tomorrow (getting late here)
> Thanks
> Boaz
>
> The patch that broke it

Boaz, thanks for the bisect.
reverting it also helps to solve 'make deb-pkg' problem I reported in
the other thread.

> ----
> From 9da0763bdd82572be243fcf5161734f11568960f Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Fri, 25 Apr 2014 23:25:18 +0200
> Subject: [PATCH] kbuild: Use relative path when building in a subdir of the
>  source tree
>
> When doing make O=<subdir>, use '..' to refer to the source tree. This
> allows for more readable compiler messages, and, more importantly, it
> sets the VPATH to '..', so filenames in WARN_ON() etc. will be shorter.
>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 3e134ec..f4702c1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -149,7 +149,17 @@ else
>  _all: modules
>  endif
>
> -srctree                := $(if $(KBUILD_SRC),$(KBUILD_SRC),.)
> +ifeq ($(KBUILD_SRC),)
> +        # building in the source tree
> +        srctree := .
> +else
> +        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
> +                # building in a subdirectory of the source tree
> +                srctree := ..
> +        else
> +                srctree := $(KBUILD_SRC)
> +        endif
> +endif
>  objtree                := .
>  src            := $(srctree)
>  obj            := $(objtree)
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
