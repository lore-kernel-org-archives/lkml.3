Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaCYG6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 02:58:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58500 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaCYG6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 02:58:21 -0400
Message-ID: <533128F8.7030102@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2014 12:28:00 +0530
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: linux-kernel@vger.kernel.org, amwang@redhat.com, procps@freelists.org,
        rdunlap@xenotime.net, james.hogan@imgtec.com,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, d.hatayama@jp.fujitsu.com,
        coreutils@gnu.org, kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 04/33] Hold threads
References: <20140320093040.14878.903.stgit@localhost.localdomain> <20140320093931.14878.89112.stgit@localhost.localdomain> <532B3B00.6080201@parallels.com>
In-Reply-To: <532B3B00.6080201@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032506-5490-0000-0000-0000053DF579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/21/2014 12:31 AM, Pavel Emelyanov wrote:
> On 03/20/2014 01:39 PM, Janani Venkataraman wrote:
>> Getting number of threads and their respective IDs through /proc/pid/stat and
>> /proc/pid/task.
>>
>> The threads are then seized and interrupted. After the dump is taken they are
>> detached.
>>
>> Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
>> ---
>> +/* Gets the Thread IDS and siezes them */
>> +int seize_threads(int pid)
>> +{
>> +	char filename[40];
>> +	DIR *dir;
>> +	int ct = 0, ret = 0, tmp_tid;
>> +	struct dirent *entry;
>> +	char state;
>> +
>> +	ret = get_thread_count(pid);
>> +	if (ret == -1)
>> +		return -1;
>> +
>> +	cp.thread_count = ret;
>> +	cp.t_id = calloc(cp.thread_count, sizeof(int));
>> +	if (!cp.t_id) {
>> +		status = errno;
>> +		gencore_log("Could not allocate memory for thread_ids.\n");
>> +		return -1;
>> +	}
>> +
>> +	snprintf(filename, 40, "/proc/%d/task", pid);
>> +	dir = opendir(filename);
>> +
>> +	while ((entry = readdir(dir))) {
> This simple loop is not enough -- threads may appear and disappear while
> you do the readdir and seize, so you should scan it several times to
> make sure you caught all the threads.
I will look into this.
> You can look at how this is done in CRIU in cr-dump,c:collect_threads().
Yes I will look into that function. Thanks.

Thanks.
Janani
>> +		if (entry->d_type == DT_DIR && entry->d_name[0] != '.') {
>> +			tmp_tid = atoi(entry->d_name);
>> +			ret = ptrace(PTRACE_SEIZE, tmp_tid, 0, 0);
>> +			if (ret) {
>> +				state = get_thread_status(tmp_tid);
>> +				if (state == 'Z')
>> +					goto assign;
>> +				status = errno;
>> +				gencore_log("Could not seize thread: %d\n",
>> +								tmp_tid);
>> +				break;
>> +			}
>> +			ret = ptrace(PTRACE_INTERRUPT, tmp_tid, 0, 0);
>> +			if (ret) {
>> +				state = get_thread_status(tmp_tid);
>> +				if (state == 'Z')
>> +					goto assign;
>> +				status = errno;
>> +				gencore_log("Could not interrupt thread: %d\n",
>> +								tmp_tid);
>> +				break;
>> +			}
>> +assign:
>> +			/* If a new thread, is created after we fetch the thread_count,
>> +			 * we may encounter a buffer overflow situation in the cp_tid.
>> +			 * Hence we check this case and re-allocate memory if required.
>> +			 */
>> +			cp.t_id[ct++] = tmp_tid;
>> +		}
>> +	}
>> +
>> +	/* Reassigning based on successful seizes */
>> +	cp.thread_count = ct;
>> +
>> +	closedir(dir);
>> +
>> +	/* Successful seize and interrupt on all threads makes ret = 0 */
>> +	return ret;
>> +}

