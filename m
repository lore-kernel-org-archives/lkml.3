Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3AWLjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:39:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33214 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3AWLjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:39:05 -0500
Date: Wed, 23 Jan 2013 12:41:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 01/13] scripts/gdb: Add infrastructure
Message-ID: <20130123114157.GB4256@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org
References: <cover.1358787929.git.jan.kiszka@siemens.com>
 <1e49f090f16f3e22711a27f473e2ed604f6a249f.1358787929.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e49f090f16f3e22711a27f473e2ed604f6a249f.1358787929.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 06:06:08PM +0100, Jan Kiszka wrote:
> This provides the basic infrastructure to load kernel-specific python
> helper scripts when debugging the kernel in gdb.
> 
> The loading mechanism is based on gdb loading for <objfile>-gdb.py when
> opening <objfile>. Therefore, this places a corresponding link to the
> main helper script into the output directory that contains vmlinux.
> 
> The main scripts will pull in submodules containing Linux specific gdb
> commands and functions. To avoid polluting the source directory with
> compiled python modules, we link to them from the object directory.
> 
> Due to gdb.parse_and_eval, we depend on gdb >= 7.1. We need to
> pre-process the version string returned by gdb as some distros tend to
> prefix it with their name.
> 
> This feature depends on CONFIG_DEBUG_INFO.
> 
> CC: Michal Marek <mmarek@suse.cz>
> CC: linux-kbuild@vger.kernel.org
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  Makefile                   |    5 ++++-
>  scripts/Makefile           |    3 ++-
>  scripts/gdb/Makefile       |    9 +++++++++
>  scripts/gdb/utils.py       |   17 +++++++++++++++++
>  scripts/gdb/vmlinux-gdb.py |   22 ++++++++++++++++++++++
>  5 files changed, 54 insertions(+), 2 deletions(-)
>  create mode 100644 scripts/gdb/Makefile
>  create mode 100644 scripts/gdb/utils.py
>  create mode 100644 scripts/gdb/vmlinux-gdb.py
> 
> diff --git a/Makefile b/Makefile
> index 253a455..fb18794 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -774,6 +774,9 @@ endif
>  ifdef CONFIG_BUILD_DOCSRC
>  	$(Q)$(MAKE) $(build)=Documentation
>  endif
> +ifdef CONFIG_DEBUG_INFO
> +	$(Q)ln -fsn $(srctree)/scripts/gdb/vmlinux-gdb.py
> +endif

I'm wondering whether it won't be a better idea to make this symlink
creation in the toplevel directory only when a user requires it.. I.e.,
not simply when CONFIG_DEBUG_INFO is enabled (it could be enabled for a
lot and different reasons) but only when user wants to really debug the
kernel with gdb.

Then, having a specific make target could arrange for all the setup like
the symlink, gdb version checking, etc, maybe something like this:

$ make gdb

and all is prepared (or errored out with a sensible message).

Hmm....

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
