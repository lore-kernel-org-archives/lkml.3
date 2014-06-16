Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaFPIG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbaFPIG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:06:57 -0400
Date: Mon, 16 Jun 2014 10:06:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Simon Que <sque@chromium.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] perf: Get kernel start address by symbol name
Message-ID: <20140616080649.GB1148@krava.brq.redhat.com>
References: <1402685121-32267-1-git-send-email-sque@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402685121-32267-1-git-send-email-sque@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:45:21AM -0700, Simon Que wrote:
> The function machine__get_kernel_start_addr() was taking the first symbol
> of kallsyms as the start address. This is incorrect in certain cases
> where the first symbol is something at 0, while the actual kernel
> functions begin at a later point (e.g. 0x80200000).
> 
> This patch fixes machine__get_kernel_start_addr() to search for the
> symbol "_text" or "_stext", which marks the beginning of kernel mapping.
> This was already being done in machine__create_kernel_maps(). Thus, this
> patch is just a refactor, to move that code into
> machine__get_kernel_start_addr().
> 
> Change-Id: I0c38c36f5e8b0f4fb92a6f57211fa45aabe545a6
> Signed-off-by: Simon Que <sque@chromium.org>

hi,
looks good to me, adding Adrian to the loop

thanks,
jirka

> ---
>  tools/perf/util/machine.c | 54 +++++++++++++++++++----------------------------
>  1 file changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 620a198..acda3d2 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -484,18 +484,6 @@ struct process_args {
>  	u64 start;
>  };
>  
> -static int symbol__in_kernel(void *arg, const char *name,
> -			     char type __maybe_unused, u64 start)
> -{
> -	struct process_args *args = arg;
> -
> -	if (strchr(name, '['))
> -		return 0;
> -
> -	args->start = start;
> -	return 1;
> -}
> -
>  static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
>  					   size_t bufsz)
>  {
> @@ -505,27 +493,41 @@ static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
>  		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
>  }
>  
> -/* Figure out the start address of kernel map from /proc/kallsyms */
> -static u64 machine__get_kernel_start_addr(struct machine *machine)
> +const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
> +
> +/* Figure out the start address of kernel map from /proc/kallsyms.
> + * Returns the name of the start symbol in *symbol_name. Pass in NULL as
> + * symbol_name if it's not that important.
> + */
> +static u64 machine__get_kernel_start_addr(struct machine *machine,
> +					  const char** symbol_name)
>  {
>  	char filename[PATH_MAX];
> -	struct process_args args;
> +	int i;
> +	const char* name;
> +	u64 addr;
>  
>  	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
>  
>  	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
>  		return 0;
>  
> -	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
> -		return 0;
> +	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
> +		addr = kallsyms__get_function_start(filename, name);
> +		if (addr)
> +			break;
> +	}
> +
> +	if (symbol_name)
> +		*symbol_name = name;
>  
> -	return args.start;
> +	return addr;
>  }
>  
>  int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
>  {
>  	enum map_type type;
> -	u64 start = machine__get_kernel_start_addr(machine);
> +	u64 start = machine__get_kernel_start_addr(machine, NULL);
>  
>  	for (type = 0; type < MAP__NR_TYPES; ++type) {
>  		struct kmap *kmap;
> @@ -832,23 +834,11 @@ static int machine__create_modules(struct machine *machine)
>  	return 0;
>  }
>  
> -const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
> -
>  int machine__create_kernel_maps(struct machine *machine)
>  {
>  	struct dso *kernel = machine__get_kernel(machine);
> -	char filename[PATH_MAX];
>  	const char *name;
> -	u64 addr = 0;
> -	int i;
> -
> -	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
> -
> -	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
> -		addr = kallsyms__get_function_start(filename, name);
> -		if (addr)
> -			break;
> -	}
> +	u64 addr = machine__get_kernel_start_addr(machine, &name);
>  	if (!addr)
>  		return -1;
>  
> -- 
> 1.8.3.2
> 
