Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3LESfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:35:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56770 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3LESfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:35:11 -0500
Message-ID: <52A0C761.3070405@arm.com>
Date: Thu, 05 Dec 2013 18:35:13 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "irogers@google.com" <irogers@google.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 1/9] staging: android: binder: Move some of the logic
 into subfunction
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com> <1386180581-6710-2-git-send-email-serban.constantinescu@arm.com> <20131205081822.GU28413@mwanda>
In-Reply-To: <20131205081822.GU28413@mwanda>
X-OriginalArrivalTime: 05 Dec 2013 18:35:06.0885 (UTC) FILETIME=[B867F350:01CEF1E8]
X-MC-Unique: 113120518350903201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/13 08:18, Dan Carpenter wrote:
> On Wed, Dec 04, 2013 at 06:09:33PM +0000, Serban Constantinescu wrote:
>> +static void bc_increfs_done(struct binder_proc *proc,
>> +		struct binder_thread *thread, uint32_t cmd,
>> +		void __user *node_ptr, void __user *cookie)
>> +{
>> +	struct binder_node *node;
>> +
>> +	node = binder_get_node(proc, node_ptr);
>> +	if (node == NULL) {
>> +		binder_user_error("%d:%d %s u%p no match\n",
>> +			proc->pid, thread->pid,
>> +			cmd == BC_INCREFS_DONE ?
>> +			"BC_INCREFS_DONE" :
>> +			"BC_ACQUIRE_DONE",
>> +			node_ptr);
>> +		return;
>> +	}
>> +	if (cookie != node->cookie) {
>> +		binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
>> +			proc->pid, thread->pid,
>> +			cmd == BC_INCREFS_DONE ?
>> +			"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
>> +			node_ptr, node->debug_id,
>> +			cookie, node->cookie);
>> +		return;
>> +	}
>> +	if (cmd == BC_ACQUIRE_DONE) {
>> +		if (node->pending_strong_ref == 0) {
>> +			binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
>> +				proc->pid, thread->pid,
>> +				node->debug_id);
>> +			return;
>> +		}
>> +		node->pending_strong_ref = 0;
>> +	} else {
>> +		if (node->pending_weak_ref == 0) {
>> +			binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
>> +				proc->pid, thread->pid,
>> +				node->debug_id);
>> +			return;
>> +		}
>> +		node->pending_weak_ref = 0;
>> +	}
>> +	binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
>> +	binder_debug(BINDER_DEBUG_USER_REFS,
>> +		     "%d:%d %s node %d ls %d lw %d\n",
>> +		     proc->pid, thread->pid,
>> +		     cmd == BC_INCREFS_DONE ?
>> +		     "BC_INCREFS_DONE" :
>> +		     "BC_ACQUIRE_DONE",
>> +		     node->debug_id, node->local_strong_refs,
>> +		     node->local_weak_refs);
>> +	return;
>> +}
>
> This function is 52 lines long but at least 32 of those lines are
> debug code.
>
> Just extra of lines of code means you have increased the number of bugs
> 150%.  But what I know is that from a static analysis perspective, debug
> code has more defects per line then regular code it's worse than that.
> Plus all the extra noise obscures the actual logic and makes the real
> code annoying to look at so it's worse still.
>
> If you want to move this stuff out of staging, then remove all the extra
> crap so it doesn't look like barf.

This patch moves code around so that some of it can be shared with the
compat layer. I agree that due to the abundance of debug code it is, at
times, hard to have a clear idea of what is actually happening and adds
extra obscurities to the logic.

Thanks,
Serban C

