Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaC1KNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:13:38 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37443 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbaC1KNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:13:37 -0400
Date: Fri, 28 Mar 2014 10:13:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3 2/4] kmemleak: allow freeing internal objects after
 kmemleak was disabled
Message-ID: <20140328101315.GB21330@arm.com>
References: <5335384A.2000000@huawei.com>
 <5335387E.2050005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335387E.2050005@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More nitpicks ;)

On Fri, Mar 28, 2014 at 08:53:18AM +0000, Li Zefan wrote:
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index 6dc8013..a7e6a06 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -51,7 +51,8 @@ Memory scanning parameters can be modified at run-time by writing to the
>  		  (default 600, 0 to stop the automatic scanning)
>    scan		- trigger a memory scan
>    clear		- clear list of current memory leak suspects, done by
> -		  marking all current reported unreferenced objects grey
> +		  marking all current reported unreferenced objects grey.
> +		  Or free all kmemleak objects if kmemleak has been disabled.

Comma after "unreferenced objects grey" and lower-case "or free ..."

> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index be7ecc0..6631df8 100644
[...]
> @@ -1690,17 +1711,16 @@ static const struct file_operations kmemleak_fops = {
>   */
>  static void kmemleak_do_cleanup(struct work_struct *work)
>  {
> -	struct kmemleak_object *object;
> -
>  	mutex_lock(&scan_mutex);
>  	stop_scan_thread();
>  
> -	if (!kmemleak_has_leaks) {
> -		rcu_read_lock();
> -		list_for_each_entry_rcu(object, &object_list, object_list)
> -			delete_object_full(object->pointer);
> -		rcu_read_unlock();
> -	}
> +	if (!kmemleak_has_leaks)
> +		__kmemleak_do_cleanup();
> +	else
> +		pr_info("Disable kmemleak without freeing internal objects, "
> +			"so you may still check information on memory leaks. "
> +			"You may reclaim memory by writing \"clear\" to "
> +			"/sys/kernel/debug/kmemleak\n");

Alternative text:

		pr_info("Kmemleak disabled without freeing internal data. "
			"Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\"\n");

(I'm wouldn't bother with long lines in printk strings)

Otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.
