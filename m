Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab3FTNmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745Ab3FTNmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:42:01 -0400
Date: Thu, 20 Jun 2013 15:41:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Robert Richter <rric@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130620134154.GC1083@krava.brq.redhat.com>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367865614-30876-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
looks like this one is breaking the 'make install' for perf with:

------------------------------------------------------------------------
$ touch Documentation/perf-diff.txt
[jolsa@krava perf]$ touch Documentation/perf-diff.txt 
[jolsa@krava perf]$ make install-doc
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK -D_FORTIFY_SOURCE=2
    CHK bionic
    CHK libelf
    CHK libdw
    CHK -DLIBELF_MMAP
    CHK -DLIBELF_MMAP
    CHK libunwind
config/Makefile:223: No libunwind found, disabling post unwind support.
Please install libunwind-dev[el] >= 0.99
    CHK libaudit
    CHK libslang
    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
    CHK perl
    CHK python
    CHK python version
    CHK libbfd
    CHK -DHAVE_STRLCPY
    CHK -DHAVE_ON_EXIT
    CHK -DBACKTRACE_SUPPORT
    CHK libnuma
    SUBDIR Documentation
    SUBDIR ../
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK -D_FORTIFY_SOURCE=2
    CHK bionic
    CHK libelf
    CHK libdw
    CHK -DLIBELF_MMAP
    CHK -DLIBELF_MMAP
    CHK libunwind
config/Makefile:223: No libunwind found, disabling post unwind support.
Please install libunwind-dev[el] >= 0.99
    CHK libaudit
    CHK libslang
    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
    CHK perl
    CHK python
    CHK python version
    CHK libbfd
    CHK -DHAVE_STRLCPY
    CHK -DHAVE_ON_EXIT
    CHK -DBACKTRACE_SUPPORT
    CHK libnuma
    ASCIIDOC perf-diff.xml
    XMLTO perf-diff.1
usage: xmlto [OPTION]... FORMAT XML
OPTIONs are:
  -v              verbose output (-vv for very verbose)
  -x stylesheet   use the specified stylesheet instead of choosing one
  -m fragment     use the XSL fragment to customize the stylesheet
  -o directory    put output in the specified directory instead of
                  the current working directory
  -p postprocopts pass option to postprocessor
  --extensions    turn on stylesheet extensions for this tool chain
  --noautosize    do not autodetect paper size via locales or paperconf
  --noclean       temp files are not deleted automatically
                  (good for diagnostics)
  --noextensions  do not use passivetex/fop extensions
  --searchpath    colon-separated list of fallback directories
  --skip-validation
                  do not attempt to validate the input before processing
  --stringparam paramname=paramvalue
                  pass a named parameter to the stylesheet from the
                  command line
  --with-fop      use fop for formatting (if fop available)
  --with-dblatex  use dblatex for formatting (if dblatex available)

Available FORMATs depend on the type of the XML file (which is
determined automatically).

For documents of type "fo":
awt  mif  pcl  svg  txt

For documents of type "docbook":
awt  dvi  epub  fo  html  htmlhelp  html-nochunks  javahelp  man  mif
pcl  pdf  ps  svg  txt  xhtml  xhtml-nochunks
make[1]: *** [perf-diff.1] Error 1
make: *** [install-doc] Error 2
------------------------------------------------------------------------

I bistected the issue to this one.. it works after I reverted it

'make -f tests/make' test catches this error ;-)

jirka

On Mon, May 06, 2013 at 08:40:14PM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The OUTPUT directory is wrongly determind leading to:
> 
>  make[3]: *** No rule to make target `.../.build/perf/PERF-VERSION-FILE'.  Stop.
> 
> Fixing this by using the generic approach in script/Makefile.include.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  tools/perf/Documentation/Makefile | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index f751757..1368e88 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -1,12 +1,6 @@
> +include ../../scripts/Makefile.include
>  include ../config/utilities.mak
>  
> -OUTPUT := ./
> -ifeq ("$(origin O)", "command line")
> -  ifneq ($(O),)
> -	OUTPUT := $(O)/
> -  endif
> -endif
> -
>  MAN1_TXT= \
>  	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
>  		$(wildcard perf-*.txt)) \
> -- 
> 1.8.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
