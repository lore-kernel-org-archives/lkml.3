Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbaFSKlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:41:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbaFSKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:41:43 -0400
Message-ID: <53A2BE65.2070501@suse.cz>
Date: Thu, 19 Jun 2014 12:41:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boaz Harrosh <openosd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild: support of new KBUILD_FULL_PATH
References: <53A1D3A1.70202@gmail.com> <53A2B7A9.7080605@gmail.com>
In-Reply-To: <53A2B7A9.7080605@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-19 12:12, Boaz Harrosh wrote:
> 
> The commit:
> 
> 	commit 9da0763bdd82572be243fcf5161734f11568960f
> 	Author: Michal Marek <mmarek@suse.cz>
> 	Date:   Fri Apr 25 23:25:18 2014 +0200
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

Parsing make output is a use case I did not think of, so the knob seems
inevitable :-/.


> Is there a document I need to edit for this new parameter?

That would be Documentation/kbuild/kbuild.txt


> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  Makefile | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 97b2861..778732a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -149,11 +149,17 @@ else
>  _all: modules
>  endif
>  
> +# put KBUILD_FULL_PATH=1 if relative path to sources breaks your system
> +ifneq ($(KBUILD_FULL_PATH), 1)
> +	KBUILD_FULL_PATH=""
> +endif
> +
>  ifeq ($(KBUILD_SRC),)
>          # building in the source tree
>          srctree := .
>  else
> -        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
> +        # if KBUILD_FULL_PATH is not empty then condition will fail
> +        ifeq ($(KBUILD_FULL_PATH)$(KBUILD_SRC)/,$(dir $(CURDIR)))

This is an ugly way to express the logic.


>                  # building in a subdirectory of the source tree
>                  srctree := ..
>          else

How about generated sources like asm-offsets.s or the lexer and parser
in scripts/kconfig, does kdevelop figure out where the files live? If
not, you might need to add

-objtree                := .
+ifeq ($(KBUILD_FULL_PATH),1)
+       objtree := $(CURDIR)
+else
+        objtree        := .
+endif

to use the full path also for the O= directory.

Michal
