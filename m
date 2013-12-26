Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3LZOij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:38:39 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:46284 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3LZOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:38:37 -0500
Message-ID: <52BC3F4A.1030203@gmail.com>
Date: Thu, 26 Dec 2013 09:38:02 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 2/2] perf-probe: Support basic dwarf-based operations
 on uprobe events
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal> <20131226054152.22364.47021.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131226054152.22364.47021.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13, 12:41 AM, Masami Hiramatsu wrote:
> And this shows the available variables at the given line of
> the function.
> ----
> # ./perf probe -x perf --vars map__load:8
> Available variables at map__load:8
>          @<map__load+96>
>                  char*   name
>                  struct map*     map
>                  symbol_filter_t filter
>          @<map__find_symbol+112>
>                  char*   name
>                  symbol_filter_t filter
>          @<map__find_symbol_by_name+136>
>                  char*   name
>                  symbol_filter_t filter
>          @<map_groups__find_symbol_by_name+176>
>                  char*   name
>                  struct map*     map
>                  symbol_filter_t filter

Still limitations. This is Fedora 18:

# rpm -qa | grep debug
glibc-debuginfo-common-2.16-34.fc18.x86_64
glibc-debuginfo-2.16-34.fc18.x86_64

# /tmp/perf/perf probe -V malloc -x /lib64/libc-2.16.so
Failed to find variables at malloc (0)

So probing on system libraries does not benefit from this patch.

> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 5681266..20b3e15 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -425,7 +425,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>   	}
>
>   #ifdef HAVE_DWARF_SUPPORT
> -	if (params.show_lines && !params.uprobes) {
> +	if (params.show_lines) {
>   		if (params.mod_events) {
>   			pr_err("  Error: Don't use --line with"
>   			       " --add/--del.\n");

Unrelated change.


> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 05be5de..2f82267 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -172,6 +172,52 @@ const char *kernel_get_module_path(const char *module)
>   	return (dso) ? dso->long_name : NULL;
>   }
>
> +/* Copied from unwind.c */
> +static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
> +				    GElf_Shdr *shp, const char *name)
> +{
> +	Elf_Scn *sec = NULL;
> +
> +	while ((sec = elf_nextscn(elf, sec)) != NULL) {
> +		char *str;
> +
> +		gelf_getshdr(sec, shp);
> +		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> +		if (!strcmp(name, str))
> +			break;
> +	}
> +
> +	return sec;
> +}

Why copy it? With unwind.c and util/symbol-elf.c we now have 2 copies. 
How about exporting one of those?

> +
> +static int get_text_start_address(const char *exec, unsigned long *address)
> +{
> +	Elf *elf;
> +	GElf_Ehdr ehdr;
> +	GElf_Shdr shdr;
> +	int fd, ret = -ENOENT;
> +
> +	fd = open(exec, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +
> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> +	if (elf == NULL)
> +		return -EINVAL;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> +		goto out;
> +
> +	if (!elf_section_by_name(elf, &ehdr, &shdr, ".text"))
> +		goto out;
> +
> +	*address = shdr.sh_addr - shdr.sh_offset;
> +	ret = 0;
> +out:
> +	elf_end(elf);
> +	return ret;
> +}
> +
>   static int init_user_exec(void)
>   {
>   	int ret = 0;
> @@ -186,6 +232,37 @@ static int init_user_exec(void)
>   	return ret;
>   }
>
> +static int convert_exec_to_group(const char *exec, char **result)
> +{
> +	char *ptr1, *ptr2, *exec_copy;
> +	char buf[64];
> +	int ret;
> +
> +	exec_copy = strdup(exec);
> +	if (!exec_copy)
> +		return -ENOMEM;
> +
> +	ptr1 = basename(exec_copy);
> +	if (!ptr1) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ptr2 = strpbrk(ptr1, "-._");
> +	if (ptr2)
> +		*ptr2 = '\0';
> +	ret = e_snprintf(buf, 64, "%s_%s", PERFPROBE_GROUP, ptr1);
> +	if (ret < 0)
> +		goto out;
> +
> +	*result = strdup(buf);
> +	ret = *result ? 0 : -ENOMEM;
> +
> +out:
> +	free(exec_copy);
> +	return ret;
> +}
> +
>   static int convert_to_perf_probe_point(struct probe_trace_point *tp,
>   					struct perf_probe_point *pp)
>   {
> @@ -261,6 +338,40 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
>   	return 0;
>   }
>
> +static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
> +					  int ntevs, const char *exec)
> +{
> +	int i, ret = 0;
> +	unsigned long offset, stext = 0;
> +	char buf[32];
> +
> +	if (!exec)
> +		return 0;
> +
> +	ret = get_text_start_address(exec, &stext);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < ntevs && ret >= 0; i++) {
> +		offset = tevs[i].point.address - stext;
> +		offset += tevs[i].point.offset;
> +		tevs[i].point.offset = 0;
> +		free(tevs[i].point.symbol);
> +		ret = e_snprintf(buf, 32, "0x%lx", offset);
> +		if (ret < 0)
> +			break;
> +		tevs[i].point.module = strdup(exec);
> +		tevs[i].point.symbol = strdup(buf);
> +		if (!tevs[i].point.symbol || !tevs[i].point.module) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +		tevs[i].uprobes = true;
> +	}
> +
> +	return ret;
> +}
> +

More strdup's. This is library code and we need methods to free that 
memory as well.

David
