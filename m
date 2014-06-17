Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaFQCr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:47:59 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:42756 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaFQCr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1402928339-29785-1-git-send-email-mmarek@suse.cz>
References: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>
	<1402928339-29785-1-git-send-email-mmarek@suse.cz>
Date: Mon, 16 Jun 2014 19:47:57 -0700
Message-ID: <CAADnVQJakSFP8VHJUwh6Z94XkYH7neuamUxHUZ16Q4-YP7O9OQ@mail.gmail.com>
Subject: Re: [PATCH] deb-pkg: Fix for relative paths
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ilya Dryomov <idryomov@gmail.com>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 7:18 AM, Michal Marek <mmarek@suse.cz> wrote:
> When $srctree or $objtree are relative paths, we cannot change directory
> and refer to them in the same subshell. Do the redirection outside of
> the subshell to fix this.
>
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/package/builddeb | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

this patch didn't help to fix the broken deb-pkg for me:

../scripts/Makefile.build:44: ../../scripts/package/Makefile: No such
file or directory
make[2]: *** No rule to make target `../../scripts/package/Makefile'.  Stop.
make[1]: *** [deb-pkg] Error 2

steps to reproduce:
$ export KBUILD_OUTPUT=/make it out of src tree
$ make deb-pkg

> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index b5f08f7..9a38e85 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -290,13 +290,13 @@ EOF
>  fi
>
>  # Build header package
> -(cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
> -(cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
> -(cd $objtree; find arch/$SRCARCH/include Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
> +(cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl) > "$objtree/debian/hdrsrcfiles"
> +(cd $srctree; find arch/$SRCARCH/include include scripts -type f) >> "$objtree/debian/hdrsrcfiles"
> +(cd $objtree; find arch/$SRCARCH/include Module.symvers include scripts -type f) >> "$objtree/debian/hdrobjfiles"
>  destdir=$kernel_headers_dir/usr/src/linux-headers-$version
>  mkdir -p "$destdir"
> -(cd $srctree; tar -c -f - -T "$objtree/debian/hdrsrcfiles") | (cd $destdir; tar -xf -)
> -(cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
> +(cd $srctree; tar -c -f - -T -) < "$objtree/debian/hdrsrcfiles" | (cd $destdir; tar -xf -)
> +(cd $objtree; tar -c -f - -T -) < "$objtree/debian/hdrobjfiles" | (cd $destdir; tar -xf -)
>  (cd $objtree; cp $KCONFIG_CONFIG $destdir/.config) # copy .config manually to be where it's expected to be
>  ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
>  rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
> --
> 1.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
