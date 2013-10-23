Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3JWGfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:35:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:37464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3JWGfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:35:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397140290"
Message-ID: <52676DFC.9030402@intel.com>
Date: Wed, 23 Oct 2013 09:34:36 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] perf tools: Add perf_data_file__open interface to
 data object
References: <1381847254-28809-1-git-send-email-jolsa@redhat.com> <1381847254-28809-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1381847254-28809-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/13 17:27, Jiri Olsa wrote:
> Adding perf_data_file__open interface to data object
> to open the perf.data file for both read and write.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> ---
>  tools/perf/Makefile.perf    |   1 +
>  tools/perf/builtin-record.c |  34 +------------
>  tools/perf/builtin-top.c    |   9 +---
>  tools/perf/util/data.c      | 120 ++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/data.h      |   4 ++
>  tools/perf/util/session.c   |  95 +++++++++++------------------------
>  tools/perf/util/session.h   |   2 +-
>  7 files changed, 158 insertions(+), 107 deletions(-)
>  create mode 100644 tools/perf/util/data.c
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index c873e03..326a26e 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -365,6 +365,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
>  LIB_OBJS += $(OUTPUT)util/stat.o
>  LIB_OBJS += $(OUTPUT)util/record.o
>  LIB_OBJS += $(OUTPUT)util/srcline.o
> +LIB_OBJS += $(OUTPUT)util/data.o

Also needs:

	LIB_H += util/data.h

>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 37088f9..d83d54a 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -345,8 +345,6 @@ out:
>  
>  static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  {
> -	struct stat st;
> -	int flags;
>  	int err, feat;
>  	unsigned long waking = 0;
>  	const bool forks = argc > 0;
> @@ -355,7 +353,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	struct perf_record_opts *opts = &rec->opts;
>  	struct perf_evlist *evsel_list = rec->evlist;
>  	struct perf_data_file *file = &rec->file;
> -	const char *output_name = file->path;
>  	struct perf_session *session;
>  	bool disabled = false;
>  
> @@ -367,35 +364,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	signal(SIGUSR1, sig_handler);
>  	signal(SIGTERM, sig_handler);
>  
> -	if (!output_name) {
> -		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
> -			file->is_pipe = true;
> -		else
> -			file->path = output_name = "perf.data";
> -	}
> -	if (output_name) {
> -		if (!strcmp(output_name, "-"))
> -			file->is_pipe = true;
> -		else if (!stat(output_name, &st) && st.st_size) {
> -			char oldname[PATH_MAX];
> -			snprintf(oldname, sizeof(oldname), "%s.old",
> -				 output_name);
> -			unlink(oldname);
> -			rename(output_name, oldname);
> -		}
> -	}
> -
> -	flags = O_CREAT|O_RDWR|O_TRUNC;
> -
> -	if (file->is_pipe)
> -		file->fd = STDOUT_FILENO;
> -	else
> -		file->fd = open(output_name, flags, S_IRUSR | S_IWUSR);
> -	if (file->fd < 0) {
> -		perror("failed to create output file");
> -		return -1;
> -	}
> -
>  	session = perf_session__new(file, false, NULL);
>  	if (session == NULL) {
>  		pr_err("Not enough memory for reading perf file header\n");
> @@ -586,7 +554,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	fprintf(stderr,
>  		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
>  		(double)rec->bytes_written / 1024.0 / 1024.0,
> -		output_name,
> +		file->path,
>  		rec->bytes_written / 24);
>  
>  	return 0;
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 752bebe..d934f70 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -929,15 +929,8 @@ static int __cmd_top(struct perf_top *top)
>  	struct perf_record_opts *opts = &top->record_opts;
>  	pthread_t thread;
>  	int ret;
> -	struct perf_data_file file = {
> -		.mode = PERF_DATA_MODE_WRITE,
> -	};
>  
> -	/*
> -	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
> -	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
> -	 */
> -	top->session = perf_session__new(&file, false, NULL);
> +	top->session = perf_session__new(NULL, false, NULL);
>  	if (top->session == NULL)
>  		return -ENOMEM;
>  
> diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
> new file mode 100644
> index 0000000..7d09faf
> --- /dev/null
> +++ b/tools/perf/util/data.c
> @@ -0,0 +1,120 @@
> +#include <linux/compiler.h>
> +#include <linux/kernel.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <string.h>
> +
> +#include "data.h"
> +#include "util.h"
> +
> +static bool check_pipe(struct perf_data_file *file)
> +{
> +	struct stat st;
> +	bool is_pipe = false;
> +	int fd = perf_data_file__is_read(file) ?
> +		 STDIN_FILENO : STDOUT_FILENO;
> +
> +	if (!file->path) {
> +		if (!fstat(fd, &st) && S_ISFIFO(st.st_mode))
> +			is_pipe = true;
> +	} else {
> +		if (!strcmp(file->path, "-"))
> +			is_pipe = true;
> +	}
> +
> +	if (is_pipe)
> +		file->fd = fd;
> +
> +	return file->is_pipe = is_pipe;
> +}
> +
> +static int check_backup(struct perf_data_file *file)
> +{
> +	struct stat st;
> +
> +	if (!stat(file->path, &st) && st.st_size) {
> +		/* TODO check errors properly */
> +		char oldname[PATH_MAX];
> +		snprintf(oldname, sizeof(oldname), "%s.old",
> +			 file->path);
> +		unlink(oldname);
> +		rename(file->path, oldname);
> +	}
> +
> +	return 0;
> +}
> +
> +static int open_file_read(struct perf_data_file *file)
> +{
> +	struct stat st;
> +	int fd;
> +
> +	fd = open(file->path, O_RDONLY);
> +	if (fd < 0) {
> +		int err = errno;
> +
> +		pr_err("failed to open %s: %s", file->path, strerror(err));
> +		if (err == ENOENT && !strcmp(file->path, "perf.data"))
> +			pr_err("  (try 'perf record' first)");
> +		pr_err("\n");
> +		return -err;
> +	}
> +
> +	if (fstat(fd, &st) < 0)
> +		goto out_close;
> +
> +	if (!file->force && st.st_uid && (st.st_uid != geteuid())) {
> +		pr_err("file %s not owned by current user or root\n",
> +		       file->path);
> +		goto out_close;
> +	}
> +
> +	if (!st.st_size) {
> +		pr_info("zero-sized file (%s), nothing to do!\n",
> +			file->path);
> +		goto out_close;
> +	}
> +
> +	file->size = st.st_size;
> +	return fd;
> +
> + out_close:
> +	close(fd);
> +	return -1;
> +}
> +
> +static int open_file_write(struct perf_data_file *file)
> +{
> +	if (check_backup(file))
> +		return -1;
> +
> +	return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> +}
> +
> +static int open_file(struct perf_data_file *file)
> +{
> +	int fd;
> +
> +	fd = perf_data_file__is_read(file) ?
> +	     open_file_read(file) : open_file_write(file);
> +
> +	file->fd = fd;
> +	return fd < 0 ? -1 : 0;
> +}
> +
> +int perf_data_file__open(struct perf_data_file *file)
> +{
> +	if (check_pipe(file))
> +		return 0;
> +
> +	if (!file->path)
> +		file->path = "perf.data";
> +
> +	return open_file(file);
> +}
> +
> +void perf_data_file__close(struct perf_data_file *file)
> +{
> +	close(file->fd);
> +}
> diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
> index ffa0186..d6c262e 100644
> --- a/tools/perf/util/data.h
> +++ b/tools/perf/util/data.h
> @@ -13,6 +13,7 @@ struct perf_data_file {
>  	int fd;
>  	bool is_pipe;
>  	bool force;
> +	unsigned long size;
>  	enum perf_data_mode mode;
>  };
>  
> @@ -26,4 +27,7 @@ static inline bool perf_data_file__is_write(struct perf_data_file *file)
>  	return file->mode == PERF_DATA_MODE_WRITE;
>  }
>  
> +int perf_data_file__open(struct perf_data_file *file);
> +void perf_data_file__close(struct perf_data_file *file);
> +
>  #endif /* __PERF_DATA_H */
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 8b551a5..061e81f 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -16,73 +16,35 @@
>  #include "perf_regs.h"
>  #include "vdso.h"
>  
> -static int perf_session__open(struct perf_session *self, bool force)
> +static int perf_session__open(struct perf_session *self)
>  {
> -	struct stat input_stat;
> -
> -	if (!strcmp(self->filename, "-")) {
> -		self->fd_pipe = true;
> -		self->fd = STDIN_FILENO;
> -
> +	if (self->fd_pipe) {
>  		if (perf_session__read_header(self) < 0)
>  			pr_err("incompatible file format (rerun with -v to learn more)");
> -
>  		return 0;
>  	}
>  
> -	self->fd = open(self->filename, O_RDONLY);
> -	if (self->fd < 0) {
> -		int err = errno;
> -
> -		pr_err("failed to open %s: %s", self->filename, strerror(err));
> -		if (err == ENOENT && !strcmp(self->filename, "perf.data"))
> -			pr_err("  (try 'perf record' first)");
> -		pr_err("\n");
> -		return -errno;
> -	}
> -
> -	if (fstat(self->fd, &input_stat) < 0)
> -		goto out_close;
> -
> -	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
> -		pr_err("file %s not owned by current user or root\n",
> -		       self->filename);
> -		goto out_close;
> -	}
> -
> -	if (!input_stat.st_size) {
> -		pr_info("zero-sized file (%s), nothing to do!\n",
> -			self->filename);
> -		goto out_close;
> -	}
> -
>  	if (perf_session__read_header(self) < 0) {
>  		pr_err("incompatible file format (rerun with -v to learn more)");
> -		goto out_close;
> +		return -1;
>  	}
>  
>  	if (!perf_evlist__valid_sample_type(self->evlist)) {
>  		pr_err("non matching sample_type");
> -		goto out_close;
> +		return -1;
>  	}
>  
>  	if (!perf_evlist__valid_sample_id_all(self->evlist)) {
>  		pr_err("non matching sample_id_all");
> -		goto out_close;
> +		return -1;
>  	}
>  
>  	if (!perf_evlist__valid_read_format(self->evlist)) {
>  		pr_err("non matching read_format");
> -		goto out_close;
> +		return -1;
>  	}
>  
> -	self->size = input_stat.st_size;
>  	return 0;
> -
> -out_close:
> -	close(self->fd);
> -	self->fd = -1;
> -	return -1;
>  }
>  
>  void perf_session__set_id_hdr_size(struct perf_session *session)
> @@ -110,35 +72,35 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
>  				       bool repipe, struct perf_tool *tool)
>  {
>  	struct perf_session *self;
> -	const char *filename = file->path;
> -	struct stat st;
> -	size_t len;
> -
> -	if (!filename || !strlen(filename)) {
> -		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
> -			filename = "-";
> -		else
> -			filename = "perf.data";
> -	}
>  
> -	len = strlen(filename);
> -	self = zalloc(sizeof(*self) + len);
> -
> -	if (self == NULL)
> +	self = zalloc(sizeof(*self));
> +	if (!self)
>  		goto out;
>  
> -	memcpy(self->filename, filename, len);
>  	self->repipe = repipe;
>  	INIT_LIST_HEAD(&self->ordered_samples.samples);
>  	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
>  	INIT_LIST_HEAD(&self->ordered_samples.to_free);
>  	machines__init(&self->machines);
>  
> -	if (perf_data_file__is_read(file)) {
> -		if (perf_session__open(self, file->force) < 0)
> +	if (file) {
> +		if (perf_data_file__open(file))
>  			goto out_delete;
> -		perf_session__set_id_hdr_size(self);
> -	} else if (perf_data_file__is_write(file)) {
> +
> +		self->fd       = file->fd;
> +		self->fd_pipe  = file->is_pipe;
> +		self->filename = file->path;
> +		self->size     = file->size;
> +
> +		if (perf_data_file__is_read(file)) {
> +			if (perf_session__open(self) < 0)
> +				goto out_close;
> +
> +			perf_session__set_id_hdr_size(self);
> +		}
> +	}
> +
> +	if (!file || perf_data_file__is_write(file)) {
>  		/*
>  		 * In O_RDONLY mode this will be performed when reading the
>  		 * kernel MMAP event, in perf_event__process_mmap().
> @@ -153,10 +115,13 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
>  		tool->ordered_samples = false;
>  	}
>  
> -out:
>  	return self;
> -out_delete:
> +
> + out_close:
> +	perf_data_file__close(file);
> + out_delete:
>  	perf_session__delete(self);
> + out:
>  	return NULL;
>  }
>  
> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
> index f2f6251..e1ca2d0 100644
> --- a/tools/perf/util/session.h
> +++ b/tools/perf/util/session.h
> @@ -39,7 +39,7 @@ struct perf_session {
>  	bool			fd_pipe;
>  	bool			repipe;
>  	struct ordered_samples	ordered_samples;
> -	char			filename[1];
> +	const char		*filename;
>  };
>  
>  #define PRINT_IP_OPT_IP		(1<<0)
> 

