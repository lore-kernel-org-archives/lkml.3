Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3LCUYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:24:47 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:50146 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3LCUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:24:43 -0500
Date: Tue, 3 Dec 2013 17:24:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/7] perf tools: Do not need to read symbols for source
 line lookup
Message-ID: <20131203202421.GA23729@ghostprotocols.net>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
 <1386055390-13757-7-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386055390-13757-7-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 03, 2013 at 09:23:09AM +0200, Adrian Hunter escreveu:
> When using libbfd to lookup source filename and line number,
> libbfd does not need the symbol table.  Removing the symbol
> table reading, doubles the speed of 'perf script' with the
> 'srcline' option.

[root@zoo ~]# gdb perf
run report -s srcline

b00000m

bt
#0  0x000000000050ac60 in read_unsigned_leb128 ()
#1  0x00000000005189f7 in find_abstract_instance_name.isra.20 ()
#2  0x00000000005190e1 in scan_unit_for_symbols ()
#3  0x0000000000519a69 in comp_unit_find_nearest_line ()
#4  0x000000000051a6ff in find_line.part.26 ()
#5  0x0000000000531063 in _bfd_elf_find_nearest_line_discriminator ()
#6  0x000000000053117b in _bfd_elf_find_nearest_line ()
#7  0x00000000004bf22d in find_address_in_section (abfd=0x39de5f0, section=0x3a32c38, data=0x3901950) at util/srcline.c:51
#8  0x000000000050ccdc in bfd_map_over_sections ()
#9  0x00000000004bf48b in addr2line (dso_name=0x39fb830 "/lib/modules/3.13.0-rc1+/kernel/drivers/gpu/drm/drm.ko", addr=20832, 
    file=0x7fffffffcc00, line=0x7fffffffcbfc, dso=0x90f9e0) at util/srcline.c:116
#10 0x00000000004bf608 in get_srcline (dso=0x90f9e0, addr=20832) at util/srcline.c:217
#11 0x00000000004b00fe in sort__srcline_cmp (left=0x1dc76f0, right=0x7fffffffcd70) at util/sort.c:268
#12 0x00000000004b3942 in hist_entry__cmp (left=0x1dc76f0, right=0x7fffffffcd70) at util/hist.c:450
#13 0x00000000004b35f4 in add_hist_entry (hists=0x90f278, entry=0x7fffffffcd70, al=0x7fffffffcf90, period=399301, weight=0)
    at util/hist.c:367
#14 0x00000000004b38d8 in __hists__add_entry (hists=0x90f278, al=0x7fffffffcf90, sym_parent=0x0, bi=0x0, mi=0x0, period=399301, 
    weight=0, transaction=0) at util/hist.c:440
#15 0x000000000042c9da in perf_evsel__add_hist_entry (tool=0x7fffffffd510, evsel=0x90f1d0, al=0x7fffffffcf90, sample=0x7fffffffd140, 
    machine=0x90e6b8) at builtin-report.c:274
#16 0x000000000042cd4f in process_sample_event (tool=0x7fffffffd510, event=0x7ffff17aea30, sample=0x7fffffffd140, evsel=0x90f1d0, 
    machine=0x90e6b8) at builtin-report.c:347
#17 0x000000000049df43 in perf_session__deliver_sample (session=0x90e5e0, tool=0x7fffffffd510, event=0x7ffff17aea30, 
    sample=0x7fffffffd140, evsel=0x90f1d0, machine=0x90e6b8) at util/session.c:930
#18 0x000000000049e107 in perf_session_deliver_event (session=0x90e5e0, event=0x7ffff17aea30, sample=0x7fffffffd140, 
    tool=0x7fffffffd510, file_offset=821808) at util/session.c:984
#19 0x000000000049cfb4 in flush_sample_queue (s=0x90e5e0, tool=0x7fffffffd510) at util/session.c:526
#20 0x000000000049ef53 in __perf_session__process_events (session=0x90e5e0, data_offset=216, data_size=832400, file_size=832616, 
    tool=0x7fffffffd510) at util/session.c:1371
#21 0x000000000049f02e in perf_session__process_events (session=0x90e5e0, tool=0x7fffffffd510) at util/session.c:1389
#22 0x000000000042d605 in __cmd_report (rep=0x7fffffffd510) at builtin-report.c:527
---Type <return> to continue, or q <return> to quit---

Applied all except this one and the other one David commented on,
waiting for that discussion to reach some conclusion.

But with the ones applied 'perf report -s srcline' is _much_ faster,
thanks!

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/srcline.c | 53 +----------------------------------------------
>  1 file changed, 1 insertion(+), 52 deletions(-)
> 
> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
> index 93795f9..e09c9e0 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/perf/util/srcline.c
> @@ -29,54 +29,6 @@ struct a2l_data {
>  	asymbol 	**syms;
>  };
>  
> -static int bfd_error(const char *string)
> -{
> -	const char *errmsg;
> -
> -	errmsg = bfd_errmsg(bfd_get_error());
> -	fflush(stdout);
> -
> -	if (string)
> -		pr_debug("%s: %s\n", string, errmsg);
> -	else
> -		pr_debug("%s\n", errmsg);
> -
> -	return -1;
> -}
> -
> -static int slurp_symtab(bfd *abfd, struct a2l_data *a2l)
> -{
> -	long storage;
> -	long symcount;
> -	asymbol **syms;
> -	bfd_boolean dynamic = FALSE;
> -
> -	if ((bfd_get_file_flags(abfd) & HAS_SYMS) == 0)
> -		return bfd_error(bfd_get_filename(abfd));
> -
> -	storage = bfd_get_symtab_upper_bound(abfd);
> -	if (storage == 0L) {
> -		storage = bfd_get_dynamic_symtab_upper_bound(abfd);
> -		dynamic = TRUE;
> -	}
> -	if (storage < 0L)
> -		return bfd_error(bfd_get_filename(abfd));
> -
> -	syms = malloc(storage);
> -	if (dynamic)
> -		symcount = bfd_canonicalize_dynamic_symtab(abfd, syms);
> -	else
> -		symcount = bfd_canonicalize_symtab(abfd, syms);
> -
> -	if (symcount < 0) {
> -		free(syms);
> -		return bfd_error(bfd_get_filename(abfd));
> -	}
> -
> -	a2l->syms = syms;
> -	return 0;
> -}
> -
>  static void find_address_in_section(bfd *abfd, asection *section, void *data)
>  {
>  	bfd_vma pc, vma;
> @@ -96,7 +48,7 @@ static void find_address_in_section(bfd *abfd, asection *section, void *data)
>  	if (pc < vma || pc >= vma + size)
>  		return;
>  
> -	a2l->found = bfd_find_nearest_line(abfd, section, a2l->syms, pc - vma,
> +	a2l->found = bfd_find_nearest_line(abfd, section, NULL, pc - vma,
>  					   &a2l->filename, &a2l->funcname,
>  					   &a2l->line);
>  }
> @@ -122,9 +74,6 @@ static struct a2l_data *addr2line_init(const char *path)
>  	if (a2l->input == NULL)
>  		goto out;
>  
> -	if (slurp_symtab(abfd, a2l))
> -		goto out;
> -
>  	return a2l;
>  
>  out:
> -- 
> 1.7.11.7
