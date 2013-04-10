Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab3DJOkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:40:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879Ab3DJOkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:40:31 -0400
Message-ID: <516579D3.7060809@suse.cz>
Date: Wed, 10 Apr 2013 16:40:19 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC PATCH] Use target compiler for user binaries in samples/
References: <20130331165327.GA28591@merkur.ravnborg.org>
In-Reply-To: <20130331165327.GA28591@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.3.2013 18:53, Sam Ravnborg wrote:
> The user-space binaries build in samples/ uses the installed
> headers for the kernel.
> Therefore it is wrong that they use the host compiler
> to build the samples.
> 
> Following is an attempt to create some infrastructure
> for building user-space binaries that uses the uapi headers.

Hi Sam,

I like the idea, I only have some minor remarks.


> This adds two new variables to the top-level Makefile:
> UAPICC and UAPICFLAGS
> 
> The architectures that supports both 32 and 64 bit set the
> appropriate flags in UAPICFLAGS.

You can have a 64bit kernel and a 32bit-only userspace. OTOH, newer PPC
distros stopped doing this, and the basic libraries have always been
available in both modes. So using the same bitness for kernel and
samples is probably OK.


> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 5c47726..ee9bcec 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -56,6 +56,7 @@ else
>  
>          KBUILD_AFLAGS += -m64
>          KBUILD_CFLAGS += -m64
> +        UAPICFLAGS    += -m64

You need to add UAPICFLAGS += $(biarch) in the x86_32 case.


> diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
> index 7203e66..0c782bc 100644
> --- a/samples/seccomp/Makefile
> +++ b/samples/seccomp/Makefile
> @@ -1,42 +1,13 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
>  
> -hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
> +uapiprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
>  
> -HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
>  HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
> -HOSTCFLAGS_bpf-helper.o += -I$(objtree)/usr/include
>  HOSTCFLAGS_bpf-helper.o += -idirafter $(objtree)/include
>  bpf-fancy-objs := bpf-fancy.o bpf-helper.o

The remaining HOSTCFLAGS_* assignments lose their meaning, so remove
them all. I actually wonder why there was need for the ./include path,
the samples are supposed to demonstrate usage of the exported headers,
after all. And it builds without the include.


> -# Try to match the kernel target.
> -ifndef CONFIG_64BIT
> -ifndef CROSS_COMPILE
> -
> -# s390 has -m31 flag to build 31 bit binaries
> -ifndef CONFIG_S390
> -MFLAG = -m32
> -else
> -MFLAG = -m31
> -endif

Nice cleanup as a side effect :).


> diff --git a/scripts/Makefile.uapiprogs b/scripts/Makefile.uapiprogs
> new file mode 100644
> index 0000000..e903eca
> --- /dev/null
> +++ b/scripts/Makefile.uapiprogs
[...]
> +__uapiprogs := $(sort $(uapiprogs-y))
> +
> +# sub-directories to visit
> +# uapiprogs-y  := hidraw/ may have been specified. Retrieve directory
> +subdir-uapi    := $(patsubst %/,%,$(filter %/, $(__uapiprogs)))
> +
> +# Drop all subdirs from list
> +__uapiprogs    := $(filter-out %/, $(__uapiprogs))
> +

Is it necessary to add subdirectory logic here? scripts/Makefile.host
does not implement it either. Let's keep the established practice that
subdirectories must be listed in $(obj-y) or $(obj-m). Then
scripts/Makefile.build continues to be the "driver" for the whole build
and includes scripts/Makefile.{host,uapiprogs} as needed. That way, you
simplify this makefile a bit, you don't need to change
scripts/Makefile.build beyond the include statement and you don't need
to touch samples/Makefile.


> +# Link an executable based on list of .o files, all plain c
> +# uapi-cmulti -> executable
> +quiet_cmd_uapi-cmulti	= UAPILD  $@
> +      cmd_uapi-cmulti	= $(UAPICC) -o $@ \
> +			  $(addprefix $(obj)/,$($(@F)-objs))
> +$(uapi-cmulti): $(obj)/%: $(uapi-cobjs) $(uapi-cshlib) FORCE
                                             ^^^^^^^^^^^
Copy&paste artefact from scripts/Makefile.host.

Last but not least, you need to add $(uapiprogs-y) to $(__clean-files)
in scripts/Makefile.clean.

Michal
