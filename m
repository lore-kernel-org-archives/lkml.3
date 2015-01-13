Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbAMHLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:11:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbAMHLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:11:20 -0500
Date: Tue, 13 Jan 2015 08:10:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jolsa@kernel.org, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@kernel.org,
        masami.hiramatsu.pt@hitachi.com, jean.pihet@linaro.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] perf: fix dwarf unwind using libunwind.
Message-ID: <20150113071059.GA32634@krava.brq.redhat.com>
References: <1421117677-51536-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421117677-51536-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:54:37AM +0800, Wang Nan wrote:

SNIP

>  
> +static int elf_is_exec(int fd, const char *name)
> +{
> +	Elf *elf;
> +	GElf_Ehdr ehdr;
> +	int retval = 0;
> +
> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> +	if (elf == NULL)
> +		return 0;
> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> +		goto out;
> +
> +	retval = (ehdr.e_type == ET_EXEC);
> +
> +out:
> +	elf_end(elf);
> +	pr_debug("unwind: elf_is_exec(%s): %d\n", name, retval);
> +	return retval;
> +
> +}

yuou need to add stub for 'NO_LIBUNWIND_DEBUG_FRAME=1', otherwise:

  CC       util/dwarf-aux.o
  CC       util/unwind-libunwind.o
util/unwind-libunwind.c:188:12: error: ‘elf_is_exec’ defined but not used [-Werror=unused-function]
 static int elf_is_exec(int fd, const char *name)
            ^
cc1: all warnings being treated as errors
make[1]: *** [util/unwind-libunwind.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2

jirka

> +
>  struct table_entry {
>  	u32 start_ip_offset;
>  	u32 fde_offset;
> @@ -322,8 +343,12 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
>  #ifndef NO_LIBUNWIND_DEBUG_FRAME
>  	/* Check the .debug_frame section for unwinding info */
>  	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
> +		int fd = dso__data_fd(map->dso, ui->machine);
> +		int is_exec = elf_is_exec(fd, map->dso->name);
> +		unw_word_t base = is_exec ? 0 : map->start;
> +
>  		memset(&di, 0, sizeof(di));
> -		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
> +		if (dwarf_find_debug_frame(0, &di, ip, base, map->dso->name,
>  					   map->start, map->end))
>  			return dwarf_search_unwind_table(as, ip, &di, pi,
>  							 need_unwind_info, arg);
> -- 
> 1.8.4
> 
