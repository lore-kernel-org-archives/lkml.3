Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbaCTTBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:01:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:43353 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:01:43 -0400
Message-ID: <532B3B00.6080201@parallels.com>
Date: Thu, 20 Mar 2014 23:01:20 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Janani Venkataraman <jananive@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <amwang@redhat.com>,
        <procps@freelists.org>, <rdunlap@xenotime.net>,
        <james.hogan@imgtec.com>, <aravinda@linux.vnet.ibm.com>, <hch@lst.de>,
        <mhiramat@redhat.com>, <jeremy.fitzhardinge@citrix.com>,
        <d.hatayama@jp.fujitsu.com>, <coreutils@gnu.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <adobriyan@gmail.com>,
        <util-linux@vger.kernel.org>, <tarundsk@linux.vnet.ibm.com>,
        <vapier@gentoo.org>, <roland@hack.frob.com>,
        <ananth@linux.vnet.ibm.com>, <gorcunov@openvz.org>,
        <avagin@openvz.org>, <oleg@redhat.com>, <eparis@redhat.com>,
        <suzuki@linux.vnet.ibm.com>, <andi@firstfloor.org>, <tj@kernel.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
Subject: Re: [PATCH 04/33] Hold threads
References: <20140320093040.14878.903.stgit@localhost.localdomain> <20140320093931.14878.89112.stgit@localhost.localdomain>
In-Reply-To: <20140320093931.14878.89112.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 01:39 PM, Janani Venkataraman wrote:
> Getting number of threads and their respective IDs through /proc/pid/stat and
> /proc/pid/task.
> 
> The threads are then seized and interrupted. After the dump is taken they are
> detached.
> 
> Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
> ---

> +/* Gets the Thread IDS and siezes them */
> +int seize_threads(int pid)
> +{
> +	char filename[40];
> +	DIR *dir;
> +	int ct = 0, ret = 0, tmp_tid;
> +	struct dirent *entry;
> +	char state;
> +
> +	ret = get_thread_count(pid);
> +	if (ret == -1)
> +		return -1;
> +
> +	cp.thread_count = ret;
> +	cp.t_id = calloc(cp.thread_count, sizeof(int));
> +	if (!cp.t_id) {
> +		status = errno;
> +		gencore_log("Could not allocate memory for thread_ids.\n");
> +		return -1;
> +	}
> +
> +	snprintf(filename, 40, "/proc/%d/task", pid);
> +	dir = opendir(filename);
> +
> +	while ((entry = readdir(dir))) {

This simple loop is not enough -- threads may appear and disappear while
you do the readdir and seize, so you should scan it several times to
make sure you caught all the threads.

You can look at how this is done in CRIU in cr-dump,c:collect_threads().

> +		if (entry->d_type == DT_DIR && entry->d_name[0] != '.') {
> +			tmp_tid = atoi(entry->d_name);
> +			ret = ptrace(PTRACE_SEIZE, tmp_tid, 0, 0);
> +			if (ret) {
> +				state = get_thread_status(tmp_tid);
> +				if (state == 'Z')
> +					goto assign;
> +				status = errno;
> +				gencore_log("Could not seize thread: %d\n",
> +								tmp_tid);
> +				break;
> +			}
> +			ret = ptrace(PTRACE_INTERRUPT, tmp_tid, 0, 0);
> +			if (ret) {
> +				state = get_thread_status(tmp_tid);
> +				if (state == 'Z')
> +					goto assign;
> +				status = errno;
> +				gencore_log("Could not interrupt thread: %d\n",
> +								tmp_tid);
> +				break;
> +			}
> +assign:
> +			/* If a new thread, is created after we fetch the thread_count,
> +			 * we may encounter a buffer overflow situation in the cp_tid.
> +			 * Hence we check this case and re-allocate memory if required.
> +			 */
> +			cp.t_id[ct++] = tmp_tid;
> +		}
> +	}
> +
> +	/* Reassigning based on successful seizes */
> +	cp.thread_count = ct;
> +
> +	closedir(dir);
> +
> +	/* Successful seize and interrupt on all threads makes ret = 0 */
> +	return ret;
> +}
