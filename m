Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726AbaGRRuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:50:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:23625 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030643AbaGRRux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,686,1400050800"; 
   d="scan'208";a="571950655"
From: Andi Kleen <andi@firstfloor.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora>
	<20140717055341.19995.97042.stgit@hemant-fedora>
Date: Fri, 18 Jul 2014 10:50:45 -0700
In-Reply-To: <20140717055341.19995.97042.stgit@hemant-fedora> (Hemant Kumar's
	message of "Thu, 17 Jul 2014 11:25:12 +0530")
Message-ID: <87d2d24kui.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemant Kumar <hemant@linux.vnet.ibm.com> writes:

First I should say supporting these probes is very useful. Thanks for
working on this.

> +
> +#define SDT_CACHE_DIR "/var/cache/perf/"

This requires running perf as root, right?

It would be better to use the $HOME cache dir, like the recent JSON patches.

> +#define SDT_CACHE "perf-sdt.cache"
> +#define SDT_CACHE_TMP "perf-sdt.cache.tmp"
> +
> +#define DELIM ':'
> +
> +struct path_list {
> +	char path[PATH_MAX];
> +	struct list_head list;
> +} execs;
> +
> +/* Write operation for cache */
> +static void write_cache(FILE *cache, char *buffer)
> +{
> +	fprintf(cache, "%s", buffer);
> +}
> +

The function seems redundant.


> +/*
> + * get_sdt_note_info() is the function actually responsible for
> + * flushing the SDT notes info into the "cache" file or to the
> + * stdout if "cache" points to NULL. Also, this function finds out
> + * the build-id of an ELF to be written into "cache".
> + */
> +static void get_sdt_note_info(struct list_head *start, const char *target,
> +			      FILE *cache)
> +{
> +	struct sdt_note *pos;
> +	u8 build_id[BUILD_ID_SIZE];
> +	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
> +	char buffer[2 * PATH_MAX];
> +
> +	if (list_empty(start))
> +		return;
> +
> +	/* Read the build id of the file */
> +	if (filename__read_build_id(target, &build_id,
> +				    sizeof(build_id)) < 0) {
> +		pr_debug("Couldn't read build-id in %s\n", target);

pr_info ?

> +
> +/*
> + * Finds out the libraries present in a system as shown by the command
> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
> + * dso path.
> + */

This seems like a hack. How would that handle chroot, containers etc. ?

> +static inline void append_path(char *path, struct list_head *list)
> +{
> +	char *res_path = NULL;
> +	struct path_list *tmp = NULL;
> +
> +	res_path = (char *)malloc(sizeof(char) * PATH_MAX);
> +
> +	if (!res_path)
> +		return;
> +
> +	memset(res_path, '\0', PATH_MAX);
> +
> +	if (realpath(path, res_path) && !is_present_in_list(list, res_path)) {


O^2 algorithm ?

> +/*
> + * Obtain the list of paths from the PATH env variable
> + */

Same as above. This probably needs to be more configurable to handle
more ways to find binaries.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
