Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab3ICJOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:14:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48169 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760Ab3ICJOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:14:19 -0400
Message-ID: <5225A868.2030005@hitachi.com>
Date: Tue, 03 Sep 2013 18:14:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 2/2] Support to perf to probe on SDT markers:
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073703.4793.32779.stgit@hemant-fedora>
In-Reply-To: <20130903073703.4793.32779.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 16:37), Hemant Kumar wrote:
> This patch enables perf to probe on the marker name specified on the command line.

At least you must show how this works, and how to use in the comment.

Thank you,

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


