Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111Ab3IDHAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:00:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43293 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762016Ab3IDHAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:00:49 -0400
X-AuditID: 9c93017e-b7c76ae000003897-c9-5226da9f0694
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 2/2] Support to perf to probe on SDT markers:
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	<20130903073703.4793.32779.stgit@hemant-fedora>
Date: Wed, 04 Sep 2013 16:00:47 +0900
In-Reply-To: <20130903073703.4793.32779.stgit@hemant-fedora> (Hemant Kumar's
	message of "Tue, 03 Sep 2013 13:07:03 +0530")
Message-ID: <8761uht6jk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep 2013 13:07:03 +0530, Hemant Kumar wrote:
> This patch enables perf to probe on the marker name specified on the command line.

It looks like you didn't consider prelinked libraries.  You need to check
the address of .stapsdt.base section too.  And obviously this patch
ignores any argument the SDT has which I think pretty important info.
But we can add it later once the uprobes arg fetch patches are in.

Also please see my previous comment on mixed usage of 'note' and
'marker'.

Thanks,
Namhyung


> ---
>  tools/perf/builtin-probe.c    |    7 +++
>  tools/perf/util/probe-event.c |   11 ++++
>  tools/perf/util/symbol-elf.c  |  112 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h      |    5 ++
>  4 files changed, 135 insertions(+)
>
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 3d8dcdf..8382853 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -378,6 +378,13 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  				       " (%d)\n", ret);
>  			return ret;
>  		}
> +		params.uprobes = true;
> +		ret = probe_marker(params.target,
> +				   params.events[0].point.function);
> +		if (ret < 0)
> +			pr_err("Could not probe at %s marker\n",
> +			       params.events[0].point.function);
> +		return ret;
>  	}
>  
>  	if (params.list_events) {
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 7f846f9..014d642 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2378,3 +2378,14 @@ int show_available_markers(const char *target)
>  	setup_pager();
>  	return list_markers(target);
>  }
> +
> +int probe_marker(const char *name, char *mark)
> +{
> +	int fd;
> +
> +	fd = open_uprobe_events(true);
> +	if (fd == -1)
> +		return fd;
> +	else
> +		return probe__marker(name, mark, fd);
> +}
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index f3630f2..60938a5 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -1040,6 +1040,118 @@ out_ret:
>  	return ret;
>  }
>  
> +static void extract_first_name(const char *target, char *fname)
> +{
> +	int i, len;
> +	char *file;
> +
> +	file = strrchr(target, DIR_SEP);
> +	file++;
> +	len = strlen(file);
> +	for (i = 0; i <= len; i++) {
> +		if (!isalpha(file[i]))
> +			break;
> +		fname[i] = file[i];
> +	}
> +	fname[i] = '\0';
> +}
> +
> +static int probe_at_note(struct sdt_note *r_note, const char *target, bool exec,
> +			 int fd)
> +{
> +	char buf[MAX_CMDLEN];
> +	int len, err = -1;
> +	Elf64_Addr offset;
> +	char *fname = NULL;
> +
> +	if (exec)
> +		offset = r_note->addr.a64[0] - TEXT_SCN;
> +	else
> +		offset = r_note->addr.a64[0];
> +
> +	fname = (char *)zalloc(sizeof(char) * strlen(target));
> +	if (fname == NULL) {
> +		pr_err("Error in allocating memory to fname\n");
> +		goto out_ret;
> +	}
> +
> +	extract_first_name(target, fname);
> +	len = snprintf(buf, MAX_CMDLEN, "%c:%s%s/%s %s:0x%x", 'p', "probe_",
> +		       fname, r_note->name, target, (unsigned)offset);
> +
> +	len = write(fd, buf, MAX_CMDLEN);
> +	if (len < 0) {
> +		pr_err("Couldn't write into uprobe_events!\n");
> +		goto out_close;
> +	} else {
> +		printf("Added new event :\n");
> +		printf("event = %s \t (on 0x%x)\n\n", r_note->name,
> +		       (unsigned)offset);
> +		printf("You can now use it on all perf tools such as :\n\n");
> +		printf("\t perf record -e %s%s:%s -aR sleep 1\n\n", "probe_", fname, r_note->name);
> +		err = 0;
> +	}
> +
> +out_close:
> +	close(fd);
> +	free(fname);
> +out_ret:
> +	return err;
> +}
> +
> +static int search_and_probe_at_note(char *key, struct sdt_note **start,
> +				    const char *target, bool exec, int fd)
> +{
> +	int ret = -1;
> +	struct sdt_note *req;
> +
> +	for (req = (*start); req != NULL; req = req->next) {
> +		if (!strcmp(key, req->name))
> +			break;
> +	}
> +	if (!req) {
> +		pr_err("Could not find marker %s\n", key);
> +		return ret;
> +	}
> +
> +	ret = probe_at_note(req, target, exec, fd);
> +	return ret;
> +}
> +
> +int probe__marker(const char *name, char *mark, int evfd)
> +{
> +	int ret = -1, fd;
> +	Elf *elf;
> +	bool exec = false;
> +	struct sdt_note *head = NULL;
> +
> +	fd = open(name, O_RDONLY);
> +	if (fd < 0) {
> +		pr_err("Failed to open the file\n");
> +		goto out_ret;
> +	}
> +
> +	symbol__elf_init();
> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> +	if (elf == NULL) {
> +		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
> +		goto out_close;
> +	}
> +
> +	head = get_elf_markers(elf, &exec, true);
> +	if (head) {
> +		ret = search_and_probe_at_note(mark, &head, name, exec, evfd);
> +		cleanup_notes(head);
> +	}
> +
> +	elf_end(elf);
> +
> +out_close:
> +	close(fd);
> +out_ret:
> +	return ret;
> +}
> +
>  void cleanup_notes(struct sdt_note *start)
>  {
>  	struct sdt_note *tmp;
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index f2d17b7..95289fd 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -262,8 +262,13 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
>  int show_available_markers(const char *module);
>  int list_markers(const char *name);
>  void cleanup_notes(struct sdt_note *start);
> +int probe_marker(const char *name, char *mark);
> +int probe__marker(const char *name, char *mark, int fd);
>  
>  #define SDT_NOTE_TYPE 3
>  #define NOTE_SCN ".note.stapsdt"
> +#define TEXT_SCN 0x400000
> +#define DIR_SEP '/'
> +#define MAX_CMDLEN 256
>  
>  #endif /* __PERF_SYMBOL */
