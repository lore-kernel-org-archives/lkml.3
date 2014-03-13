Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaCMMld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:41:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46813 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaCMMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:41:32 -0400
Date: Thu, 13 Mar 2014 12:38:19 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/7] ftrace: Add arm64 support to recordmcount
Message-ID: <20140313123819.GF12331@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705630-12384-4-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394705630-12384-4-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:13:46AM +0000, AKASHI Takahiro wrote:
> Recordmcount utility under scripts is run, after compiling each object,
> to find out all the locations of calling _mcount() and put them into
> specific seciton named __mcount_loc.
> Then linker collects all such information into a table in the kernel image
> (between __start_mcount_loc and __stop_mcount_loc) for later use by ftrace.
> 
> This patch adds arm64 specific definitions to identify such locations.
> There are two types of implementation, C and Perl. On arm64, only C version
> is used to build the kernel now that CONFIG_HAVE_C_RECORDMCOUNT is on.
> But Perl version is also maintained.
> 
> This patch also contains a workaround just in case where a header file,
> elf.h, on host machine doesn't have definitions of EM_AARCH64 nor
> R_AARCH64_ABS64. Without them, compiling C version of recordmcount will
> fail.

[...]

> diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
> index 9c22317..047c8cd 100644
> --- a/scripts/recordmcount.c
> +++ b/scripts/recordmcount.c
> @@ -40,6 +40,11 @@
>  #define R_METAG_NONE                     3
>  #endif
>  
> +#ifndef EM_AARCH64
> +#define EM_AARCH64	183
> +#define R_AARCH64_ABS64	257
> +#endif
> +
>  static int fd_map;	/* File descriptor for file being modified. */
>  static int mmap_failed; /* Boolean flag. */
>  static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
> @@ -347,6 +352,10 @@ do_file(char const *const fname)
>  	case EM_ARM:	 reltype = R_ARM_ABS32;
>  			 altmcount = "__gnu_mcount_nc";
>  			 break;
> +	case EM_AARCH64:
> +			 reltype = R_AARCH64_ABS64;
> +			 altmcount = "_mcount";

Shouldn't you be setting gpfx = '_' instead of overriding altmcount like
this?

> +			 break;
>  	case EM_IA_64:	 reltype = R_IA64_IMM64;   gpfx = '_'; break;
>  	case EM_METAG:	 reltype = R_METAG_ADDR32;
>  			 altmcount = "_mcount_wrapper";
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 91280b8..397b6b8 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -279,6 +279,11 @@ if ($arch eq "x86_64") {
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24|THM_CALL)" .
>  			"\\s+(__gnu_mcount_nc|mcount)\$";
>  
> +} elsif ($arch eq "arm64") {
> +    $alignment = 3;
> +    $section_type = '%progbits';
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_AARCH64_CALL26\\s+_mcount\$";

What about "mcount" (i.e. no underscore)?

Will
