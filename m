Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaLaPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:50:57 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:43779 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaLaPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:50:56 -0500
X-Greylist: delayed 5660 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2014 10:50:55 EST
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1420040119-32669-1-git-send-email-mmarek@suse.cz>
References: <54A40743.8080401@suse.cz>
	<1420040119-32669-1-git-send-email-mmarek@suse.cz>
Date: Wed, 31 Dec 2014 16:50:54 +0100
Message-ID: <CA+icZUUpYCGTJ7mC1jCNUQi7fgw4qSAa+ga8JGPXhkYEK+Bmtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: Fix removal of the debian/ directory
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, max@stro.at,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 4:35 PM, Michal Marek <mmarek@suse.cz> wrote:
> scripts/Makefile.clean treats absolute path specially, but
> $(objtree)/debian is no longer an absolute path since 7e1c0477 (kbuild:
> Use relative path for $(objtree). Work around this by checking if the
> path starts with $(objtree)/.
>
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Fixes: 7e1c0477 (kbuild: Use relative path for $(objtree)
> Signed-off-by: Michal Marek <mmarek@suse.cz>

After applying your patchset, thing work as expected.

Feel free to add my Tested-by.

Hope this will get into v3.19-rc3?

- Sedat -

[1] https://patchwork.kernel.org/patch/5555911/
[2] https://patchwork.kernel.org/patch/5555931/

P.S.: Testing new patchset (especially 1/2).

$ make distclean
  CLEAN   .
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/realmode/rm
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   crypto/asymmetric_keys
  CLEAN   drivers/tty/vt
  CLEAN   kernel/debug/kdb
  CLEAN   kernel/time
  CLEAN   kernel
  CLEAN   lib/raid6
  CLEAN   lib
  CLEAN   security/apparmor
  CLEAN   security/selinux
  CLEAN   usr
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   arch/x86/tools
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/genksyms
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts/selinux/genheaders
  CLEAN   scripts/selinux/mdp
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated
arch/x86/include/generated
  CLEAN   .config .config.old .version
include/generated/uapi/linux/version.h Module.symvers signing_key.priv
signing_key.x509 x509.genkey

$ git am ../patches/kbuild-fixes-3.19-rc2/1*
Wende an: kbuild: Fix removal of the debian/ directory

$ git am ../patches/kbuild-fixes-3.19-rc2/2*
Wende an: kbuild: Drop support for clean-rule

$ ls debian/*tmp
debian/fwtmp:
DEBIAN  lib  usr

debian/hdrtmp:
DEBIAN  lib  usr

debian/headertmp:
DEBIAN  usr

debian/tmp:
boot  DEBIAN  etc  lib  usr

$ make distclean
  CLEAN   ./debian/

$ LC_ALL=C ls debian/*tmp
ls: cannot access debian/*tmp: No such file or directory
- EOT .


> ---
>  scripts/Makefile.clean | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
> index 1bca180..627f8cb 100644
> --- a/scripts/Makefile.clean
> +++ b/scripts/Makefile.clean
> @@ -42,19 +42,19 @@ __clean-files       := $(extra-y) $(extra-m) $(extra-)       \
>
>  __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
>
> -# as clean-files is given relative to the current directory, this adds
> -# a $(obj) prefix, except for absolute paths
> +# clean-files is given relative to the current directory, unless it
> +# starts with $(objtree)/ (which means "./", so do not add "./" unless
> +# you want to delete a file from the toplevel object directory).
>
>  __clean-files   := $(wildcard                                               \
> -                   $(addprefix $(obj)/, $(filter-out /%, $(__clean-files))) \
> -                  $(filter /%, $(__clean-files)))
> +                  $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(__clean-files))) \
> +                  $(filter $(objtree)/%, $(__clean-files)))
>
> -# as clean-dirs is given relative to the current directory, this adds
> -# a $(obj) prefix, except for absolute paths
> +# same as clean-files
>
>  __clean-dirs    := $(wildcard                                               \
> -                   $(addprefix $(obj)/, $(filter-out /%, $(clean-dirs)))    \
> -                  $(filter /%, $(clean-dirs)))
> +                  $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(clean-dirs)))    \
> +                  $(filter $(objtree)/%, $(clean-dirs)))
>
>  # ==========================================================================
>
> --
> 2.1.2
>
