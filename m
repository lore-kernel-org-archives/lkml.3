Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaGVLyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:54:03 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37241 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaGVLyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:54:01 -0400
Message-ID: <53CE50CF.3080200@linux.vnet.ibm.com>
Date: Tue, 22 Jul 2014 17:23:51 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora> <20140717055341.19995.97042.stgit@hemant-fedora> <87d2d24kui.fsf@tassilo.jf.intel.com>
In-Reply-To: <87d2d24kui.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072211-9574-0000-0000-00000029415B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 07/18/2014 11:20 PM, Andi Kleen wrote:
> Hemant Kumar <hemant@linux.vnet.ibm.com> writes:
>
> First I should say supporting these probes is very useful. Thanks for
> working on this.

Thanks a lot for the appreciation.

>
>> +
>> +#define SDT_CACHE_DIR "/var/cache/perf/"
> This requires running perf as root, right?

Yes!

>
> It would be better to use the $HOME cache dir, like the recent JSON patches.

Hmm, seems like a good idea! We can use ~/.debug as Masami suggested.

>
>> +#define SDT_CACHE "perf-sdt.cache"
>> +#define SDT_CACHE_TMP "perf-sdt.cache.tmp"
>> +
>> +#define DELIM ':'
>> +
>> +struct path_list {
>> +	char path[PATH_MAX];
>> +	struct list_head list;
>> +} execs;
>> +
>> +/* Write operation for cache */
>> +static void write_cache(FILE *cache, char *buffer)
>> +{
>> +	fprintf(cache, "%s", buffer);
>> +}
>> +
> The function seems redundant.
>

Yeah, right. Will remove it.

>> +/*
>> + * get_sdt_note_info() is the function actually responsible for
>> + * flushing the SDT notes info into the "cache" file or to the
>> + * stdout if "cache" points to NULL. Also, this function finds out
>> + * the build-id of an ELF to be written into "cache".
>> + */
>> +static void get_sdt_note_info(struct list_head *start, const char *target,
>> +			      FILE *cache)
>> +{
>> +	struct sdt_note *pos;
>> +	u8 build_id[BUILD_ID_SIZE];
>> +	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
>> +	char buffer[2 * PATH_MAX];
>> +
>> +	if (list_empty(start))
>> +		return;
>> +
>> +	/* Read the build id of the file */
>> +	if (filename__read_build_id(target, &build_id,
>> +				    sizeof(build_id)) < 0) {
>> +		pr_debug("Couldn't read build-id in %s\n", target);
> pr_info ?

Ok, pr_info will be better.

>> +
>> +/*
>> + * Finds out the libraries present in a system as shown by the command
>> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
>> + * dso path.
>> + */
> This seems like a hack. How would that handle chroot, containers etc. ?

Right now, it doesn't handle chroot, containers and other path related
stuff. We will have to figure that out!

>> +static inline void append_path(char *path, struct list_head *list)
>> +{
>> +	char *res_path = NULL;
>> +	struct path_list *tmp = NULL;
>> +
>> +	res_path = (char *)malloc(sizeof(char) * PATH_MAX);
>> +
>> +	if (!res_path)
>> +		return;
>> +
>> +	memset(res_path, '\0', PATH_MAX);
>> +
>> +	if (realpath(path, res_path) && !is_present_in_list(list, res_path)) {
>
> O^2 algorithm ?

:) Will improve that by using a hash table.

>> +/*
>> + * Obtain the list of paths from the PATH env variable
>> + */
> Same as above. This probably needs to be more configurable to handle
> more ways to find binaries.
>

We can make it more configurable, but by default, it should go for
binaries in these directories. What would you suggest?

Thanks a lot for reviewing the patch. :)

-- 
Thanks,
Hemant Kumar

