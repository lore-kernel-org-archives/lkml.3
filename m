Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3H0NYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab3H0NYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:24:10 -0400
Date: Tue, 27 Aug 2013 15:23:58 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 3/4] gcov: compile specific gcov implementation based
 on gcc version
Message-ID: <20130827132358.GA2418@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
 <1377247176-13537-4-git-send-email-fhrbata@redhat.com>
 <52177C87.4090003@linux.vnet.ibm.com>
 <20130824191227.GA2365@localhost.localdomain>
 <521B5064.3000605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521B5064.3000605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:56:04PM +0200, Peter Oberparleiter wrote:
> On 24.08.2013 21:12, Frantisek Hrbata wrote:
> > On Fri, Aug 23, 2013 at 05:15:19PM +0200, Peter Oberparleiter wrote:
> >> Also it is my understanding that there are some distribution-specific versions
> >> of GCC that include the 4.7. gcov format code but report GCC version 4.6. With
> >> the auto-detection code implemented like this, gcov-kernel won't work correctly.
> >> For that purpose I've implemented a configuration option to allow users to
> >> force a specific version of gcov format.
> > 
> > Ah, I was not aware of this inconsistency in versioning. This raises a question
> > if it would not be better to deal directly with version in the gcov_info
> > instead of these config options. This would of course mean some kind of gcov
> > operations callbacks per gcov version(you already mentioned the file
> > operations approach).
> 
> Using the version information from gcov_info would make the support easier to use,
> but I see 2 problems with this approach:
> 
> 1. How do you decide which version applies to any given gcov_info struct?
> Since gcov_info is opaque this would require a compatibility check inside
> the version specific code. And each version specific code assumes a different
> layout for gcov_info, so in an (unlikely) worst case scenario, the compatibility
> check might fail (false positive or access beyond end of data structure) due to
> these differences
> 
> 2. There's no easy way to "force" compatibility, for example in the case
> mentioned above where a GCC 4.6 produces GCC 4.7 gcov format data.

Yes, you are right of course. Problem imho is that user-space program is always
linked with the correct libgcov. Meaning the gcov structures and the code
dumping the gcda are tied and known(compatible) at the compilation(link) time.
So there is no need to deal with different gcov_info layouts. After a little bit
more thinking the "per gcov_info version callbacks" does not seem as the right
way to go anymore. At this point I think the easier and probably the safest way
would be the module approach as you originally proposed. Anyway I would leave
this aside for now and we will see if someone requests this in the future. 

For now I would propose to simply support only one gcov version at the time.
Meaning if you want to use gcov, compile your kernel and modules with the same
gcc version. And add the possibility to explicitly select gcov version(3.4 or
4.7) during configuration as you proposed in your patch.

IMHO this should be a good start :)

> 
> >> I'm attaching the corresponding patch below:
> >>
> >> ---
> >> kernel: gcov: make data format configurable
> >>
> >> Make the format of the generated gcov data configurable. This may be
> >> required for example for pre-4.7 GCCs that contain the 4.7 gcov data
> >> format changes.
> >>
> >> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> >> ---
> >>  kernel/gcov/Kconfig  |   30 ++++++++++++++++++++++++++++++
> >>  kernel/gcov/Makefile |   21 +++++++++++++++++++--
> >>  2 files changed, 49 insertions(+), 2 deletions(-)
> >>
> >> --- a/kernel/gcov/Kconfig
> >> +++ b/kernel/gcov/Kconfig
> >> @@ -46,4 +46,34 @@ config GCOV_PROFILE_ALL
> >>  	larger and run slower. Also be sure to exclude files from profiling
> >>  	which are not linked to the kernel image to prevent linker errors.
> >>
> >> +choice
> >> +	prompt "Specify GCOV format"
> >> +	depends on GCOV_KERNEL
> >> +	default GCOV_FORMAT_AUTODETECT
> >> +	---help---
> >> +	The gcov format is usually determined by the GCC version, but there are
> >> +	exceptions where format changes are integrated in lower-version GCCs.
> >> +	In such a case use this option to adjust the format used in the kernel
> >> +	accordingly.
> >> +
> >> +	If unsure, choose "Autodetect".
> >> +
> >> +config GCOV_FORMAT_AUTODETECT
> >> +	bool "Autodetect"
> >> +	---help---
> >> +	Select this option to use the format that corresponds to your GCC
> >> +	version.
> >> +
> >> +config GCOV_FORMAT_3_4
> >> +	bool "GCC 3.4 format"
> >> +	---help---
> >> +	Select this option to use the format defined by GCC 3.4.
> >> +
> >> +config GCOV_FORMAT_4_7
> >> +	bool "GCC 4.7 format"
> >> +	---help---
> >> +	Select this option to use the format defined by GCC 4.7.
> >> +
> >> +endchoice
> >> +
> >>  endmenu
> >> --- a/kernel/gcov/Makefile
> >> +++ b/kernel/gcov/Makefile
> >> @@ -1,5 +1,22 @@
> >>  ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
> >>
> >> +# if-lt
> >> +# Usage VAR := $(call if-lt, $(a), $(b))
> >> +# Returns 1 if (a < b)
> >> +if-lt = $(shell [ $(1) -lt $(2) ] && echo 1)
> >> +
> >> +ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
> >> +  cc-ver := 0304
> >> +else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
> >> +  cc-ver := 0407
> >> +else
> >> +  cc-ver := $(call cc-version)
> >> +endif
> >> +
> >>  obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
> >> -obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -lt, 0407, gcc_3_4.o)
> >> -obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -ge, 0407, gcc_4_7.o)
> >> +
> >> +ifeq ($(call if-lt, $(cc-ver), 0407),1)
> >> +  obj-$(CONFIG_GCOV_KERNEL) += gcc_3_4.o
> >> +else
> >> +  obj-$(CONFIG_GCOV_KERNEL) += gcc_4_7.o
> >> +endif
> >>
> >>
> >> -- 
> >> Peter Oberparleiter
> >> Linux on System z Development - IBM Germany
> >>
> > 
> 
> 
> -- 
> Peter Oberparleiter
> Linux on System z Development - IBM Germany
> 

-- 
Frantisek Hrbata
