Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3KGIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:03:31 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:32925 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3KGIDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:03:17 -0500
Date: Thu, 7 Nov 2013 09:03:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf record: mmap output file - v3
Message-ID: <20131107080313.GB31926@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
 <1383763297-27066-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383763297-27066-5-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> +--out-pages=::
> +	Number of pages to mmap while writing data to file (must be a power of two).
> +	Specification can be appended with unit character - B/K/M/G. The
> +	size is rounded up to have nearest pages power of two value.

So why doesn't the code automatically round down (or up) to the next power 
of 2 limit? We use computers to solve problems, not to introduce 
additional ones! ;-)

> +/* output file mmap'ed N chunks at a time */
> +#define MMAP_OUTPUT_SIZE   (64*1024*1024)

I suspect the --out-pages help text should mention that the default is 
64M?

>  struct perf_record {
>  	struct perf_tool	tool;
>  	struct perf_record_opts	opts;
> +
> +	/* for MMAP based file writes */
> +	void			*mmap_addr;
> +	u64			mmap_offset;     /* current location within mmap */
> +	unsigned int		mmap_out_pages;  /* user configurable option */
> +	size_t			mmap_out_size;   /* size of mmap segments */
> +	bool			use_mmap;

So I think it makes sense for such a group of fields to get its own 
record.mmap sub-structure and be referenced via:

	rec->mmap.addr
	rec->mmap.offset
	rec->mmap.out_pages
	...

Such sub-structures make the semantic grouping easier to see, etc.

> +static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
> +{
> +	struct perf_data_file *file = &rec->file;
> +	u64 remaining;
> +	off_t offset;
> +
> +	if (rec->mmap_addr == NULL) {
> +do_mmap:
> +		offset = rec->session->header.data_offset + rec->bytes_written;
> +		if (offset < (ssize_t) rec->mmap_out_size) {
> +			rec->mmap_offset = offset;
> +			offset = 0;
> +		} else
> +			rec->mmap_offset = 0;

(Nit: unbalanced curly braces.)

> +
> +		/* extend file to include a new mmap segment */
> +		if (ftruncate(file->fd, offset + rec->mmap_out_size) != 0) {
> +			pr_err("ftruncate failed\n");
> +			return -1;
> +		}
> +
> +		rec->mmap_addr = mmap(NULL, rec->mmap_out_size,
> +				      PROT_WRITE | PROT_READ, MAP_SHARED,
> +				      file->fd, offset);
> +
> +		if (rec->mmap_addr == MAP_FAILED) {
> +			pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
> +			/* reset file size */
> +			ftruncate(file->fd, offset);
> +			return -1;
> +		}
> +	}

I think this branch should move into its well-named helper inline 
function.

> +
> +	remaining = rec->mmap_out_size - rec->mmap_offset;
> +
> +	if (size > remaining) {
> +		memcpy(rec->mmap_addr + rec->mmap_offset, buf, remaining);
> +		rec->bytes_written += remaining;
> +
> +		size -= remaining;
> +		buf  += remaining;
> +
> +		munmap(rec->mmap_addr, rec->mmap_out_size);
> +		goto do_mmap;
> +	}
> +
> +	if (size) {
> +		memcpy(rec->mmap_addr + rec->mmap_offset, buf, size);
> +		rec->bytes_written += size;
> +		rec->mmap_offset += size;
> +	}

One-one line of comment that explains what these two branches do would be 
nice.

>  static int write_output(struct perf_record *rec, void *buf, size_t size)
>  {
>  	struct perf_data_file *file = &rec->file;
>  
> +	if (rec->use_mmap)
> +		return do_mmap_output(rec, buf, size);
> +
>  	while (size) {
>  		int ret = write(file->fd, buf, size);

I think to make it symmetric, the !use_mmap case should be moved into a 
helper inline function as well. That way write_output() is just a 
meta-function calling handlers, not a mixture of real logic and 
demultiplexing of operations ...

> @@ -429,6 +498,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  		goto out_delete_session;
>  	}
>  
> +	if (!file->is_pipe && rec->mmap_out_size) {
> +		if (rec->mmap_out_pages)
> +			rec->mmap_out_size = rec->mmap_out_pages * page_size;
> +		rec->use_mmap = true;
> +	}

This should move into a separate inline as well, named mmap_init() or so.

> @@ -544,6 +619,24 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  		}
>  	}
>  
> +	if (rec->use_mmap) {
> +		off_t len = rec->session->header.data_offset + rec->bytes_written;
> +		int fd = rec->file.fd;
> +
> +		rec->use_mmap = false;
> +		munmap(rec->mmap_addr, rec->mmap_out_size);
> +		rec->mmap_addr = NULL;
> +
> +		if (ftruncate(fd, len) != 0)
> +			pr_err("ftruncate failed\n");
> +
> +		/*
> +		 * Set output pointer to end of file
> +		 * eg., needed for buildid processing
> +		 */
> +		lseek(fd, len, SEEK_SET);
> +	}

This should move into an inline as well. We really hate large, mixed-role 
functions! :-)

> +	OPT_CALLBACK(0, "out-pages", &record.mmap_out_pages, "pages",
> +		     "number of pages to use for output chunks.",
> +		     perf_evlist__parse_mmap_pages),

Nit: the short explanation here doesn't mention it at all to the user that 
these 'out pages' are used in mmap.

Shouldn't it say:

		     "number of pages mmap()ed for output chunks."

?

Also, what happens if a user sets it to zero?

Thanks,

	Ingo
