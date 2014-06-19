Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbaFSO74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:59:56 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47611 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaFSO7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:59:55 -0400
Message-ID: <53A2FAE8.8080908@plexistor.com>
Date: Thu, 19 Jun 2014 17:59:52 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: support of new KBUILD_FULL_PATH
References: <53A1D3A1.70202@gmail.com> <53A2B7A9.7080605@gmail.com> <53A2BE65.2070501@suse.cz> <53A2D0FC.7040309@plexistor.com> <53A2E22F.6060100@suse.cz> <53A2F949.9090100@plexistor.com>
In-Reply-To: <53A2F949.9090100@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 05:52 PM, Boaz Harrosh wrote:
> 
> The commit 9da0763bdd82572be243fcf5161734f11568960f
> 
> 	kbuild: Use relative path when building in a subdir of the source tree
> 
> 	When doing make O=<subdir>, use '..' to refer to the source tree. This
> 	allows for more readable compiler messages, and, more importantly, it
> 	sets the VPATH to '..', so filenames in WARN_ON() etc. will be shorter.
> 
> 	Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 	Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> Broke IDEs and other tools which analyze the make output.
> Introduce a new KBUILD_FULL_PATH switch to Makefile that will revert
> to the old output if KBUILD_FULL_PATH=1 is specified.
> The default is KBUILD_FULL_PATH=0
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

Thanks Sir Michal

Please feel free to check out my broken grammar and change
what you see fit.

BTW: The old system was sensitive to absolute paths so if
I compile on local machine say at:
	/home/boaz/dev/lin/
but then go to a network station and do "make install" in:
	/mnt/boaz/home/boaz/dev/lin/

The build would attempt to rebuild everything what I do
is cd /net/boaz/home/boaz/dev on local and remote so the
make just works. Your patch actually fixed that ;-)

Thanks
Boaz

> ---
>  Documentation/kbuild/kbuild.txt |  9 +++++++++
>  Makefile                        | 13 ++++++++-----
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
> index 6466704..9133b47 100644
> --- a/Documentation/kbuild/kbuild.txt
> +++ b/Documentation/kbuild/kbuild.txt
> @@ -77,6 +77,15 @@ Specify the output directory when building the kernel.
>  The output directory can also be specified using "O=...".
>  Setting "O=..." takes precedence over KBUILD_OUTPUT.
>  
> +KBUILD_FULL_PATH
> +--------------------------------------------------
> +Since Linux v3.16-rc1 the Kernel build system prefers to use
> +relative paths when supplying file-paths to gcc and other
> +tools. This will break IDEs and other environments that would
> +parse the gcc output to find files and lines.
> +Use KBUILD_FULL_PATH=1 on make command line to revert to old
> +way of feeding tools with full-paths.
> +
>  KBUILD_DEBARCH
>  --------------------------------------------------
>  For the deb-pkg target, allows overriding the normal heuristics deployed by
> diff --git a/Makefile b/Makefile
> index 97b2861..51fcebd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -153,11 +153,14 @@ ifeq ($(KBUILD_SRC),)
>          # building in the source tree
>          srctree := .
>  else
> -        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
> -                # building in a subdirectory of the source tree
> -                srctree := ..
> -        else
> -                srctree := $(KBUILD_SRC)
> +        srctree := $(KBUILD_SRC)
> +
> +        # if KBUILD_FULL_PATH=1 then do not use relative path
> +	ifneq ($(KBUILD_FULL_PATH), 1)
> +                ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
> +                        # building in a subdirectory of the source tree
> +                        srctree := ..
> +                endif
>          endif
>  endif
>  objtree		:= .
> 

