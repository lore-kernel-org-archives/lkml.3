Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaJXDd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:33:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43364 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJXDd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:33:26 -0400
Message-ID: <5449C870.7060509@huawei.com>
Date: Fri, 24 Oct 2014 11:33:04 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: <dedekind1@gmail.com>, <ezequiel.garcia@free-electrons.com>,
        "Richard Weinberger" <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanya,

When I was trying to push this patch to my product, I reviewed this patch
and found some small problems. I wish it's not too late to report these.

The patch I get from linux-ubifs.git is amended a bit by Artem. I'd like to
quote your V5 patch for simplification. Some line numbers may mismatching.

> @@ -1408,20 +1416,20 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
>  		return -EINVAL;
>
>  	if (mtd_devs == UBI_MAX_DEVICES) {
> -		ubi_err("too many parameters, max. is %d\n",
> +		pr_err("UBI error: too many parameters, max. is %d\n",
>  			UBI_MAX_DEVICES);
>  		return -EINVAL;
>  	}
>
>  	len = strnlen(val, MTD_PARAM_LEN_MAX);
>  	if (len == MTD_PARAM_LEN_MAX) {
> -		ubi_err("parameter \"%s\" is too long, max. is %d\n",
> +		pr_err("UBI error: parameter \"%s\" is too long, max. is %d\n",
>  			val, MTD_PARAM_LEN_MAX);
>  		return -EINVAL;
>  	}
>
>  	if (len == 0) {
> -		pr_warn("UBI warning: empty 'mtd=' parameter - ignored\n");
> +		pr_err("UBI warning: empty 'mtd=' parameter - ignored\n");
>  		return 0;
>  	}

Why the last 'pr_warn()' need to be changed into 'pr_err()'? I looked up your
V1 and V2 patches, I think it's not your purpose.



> @@ -176,6 +176,7 @@ static int add_corrupted(struct ubi_attach_info *ai, int pnum, int ec)
>
>  /**
>   * validate_vid_hdr - check volume identifier header.
> + * @ubi: UBI device description object
>   * @vid_hdr: the volume identifier header to check
>   * @av: information about the volume this logical eraseblock belongs to
>   * @pnum: physical eraseblock number the VID header came from

> @@ -48,13 +48,14 @@
>
>  /**
>   * get_exclusive - get exclusive access to an UBI volume.
> + * @ubi: UBI device description object
>   * @desc: volume descriptor
>   *
>   * This function changes UBI volume open mode to "exclusive". Returns previous
>   * mode value (positive integer) in case of success and a negative error code
>   * in case of failure.
>   */

> @@ -660,13 +660,14 @@ static int init_volumes(struct ubi_device *ubi,
>
>  /**
>   * check_av - check volume attaching information.
> + * @ubi: UBI device description object
>   * @vol: UBI volume description object
>   * @av: volume attaching information
>   *
>   * This function returns zero if the volume attaching information is consistent
>   * to the data read from the volume tabla, and %-EINVAL if not.
>   */
> -static int check_av(const struct ubi_volume *vol,
> +static int check_av(const struct ubi_device *ubi, const struct ubi_volume *vol,
>  		    const struct ubi_ainf_volume *av)
>  {
>  	int err;

This patch add 'struct ubi_device *' for 3 functions. We can get 'ubi_device' from
'ubi_volume'. So I think it's because when we call these functions, the '->ubi'
pointer of 'ubi_volume' is not initialized, am I right? This patch use 'vol->ubi'
to indicate a 'struct ubi_device *' pointer in some places, I think you are sure
of using them.



> @@ -1010,28 +1015,28 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
>  	ubi->bgt_thread = kthread_create(ubi_thread, ubi, "%s", ubi->bgt_name);
>  	if (IS_ERR(ubi->bgt_thread)) {
>  		err = PTR_ERR(ubi->bgt_thread);
> -		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
> -			err);
> +		ubi_err(ubi, "cannot spawn \"%s\", error %d",
> +			ubi->bgt_name, err);
>  		goto out_debugfs;
>  	}
>
> -	ubi_msg("attached mtd%d (name \"%s\", size %llu MiB) to ubi%d",
> -		mtd->index, mtd->name, ubi->flash_size >> 20, ubi_num);
> -	ubi_msg("PEB size: %d bytes (%d KiB), LEB size: %d bytes",
> +	ubi_msg(ubi, "attached mtd%d (name \"%s\", size %llu MiB)",
> +		mtd->index, mtd->name, ubi->flash_size >> 20);
> +	ubi_msg(ubi, "PEB size: %d bytes (%d KiB), LEB size: %d bytes",
>  		ubi->peb_size, ubi->peb_size >> 10, ubi->leb_size);

We have the parameter 'ubi_num' for log in some functions like 'ubi_attach_mtd_dev'
before. This patch remove 'ubi_num' in upper changes but keep it in other changes.
Do we have a discussed rule to deal with this situation? It's not a big problem~



> @@ -1798,15 +1803,18 @@ int ubi_thread(void *u)
>  	int failures = 0;
>  	struct ubi_device *ubi = u;
>
> -	ubi_msg("background thread \"%s\" started, PID %d",
> +	ubi_msg(ubi, "background thread \"%s\" started, PID %d",
>  		ubi->bgt_name, task_pid_nr(current));
>
>  	set_freezable();
>  	for (;;) {
>  		int err;
>
> -		if (kthread_should_stop())
> +		if (kthread_should_stop()) {
> +			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
> +				ubi->bgt_name, task_pid_nr(current));
>  			break;
> +		}
>
>  		if (try_to_freeze())
>  			continue;

> @@ -1798,15 +1803,18 @@ int ubi_thread(void *u)
>  	int failures = 0;
>  	struct ubi_device *ubi = u;
>
> -	ubi_msg("background thread \"%s\" started, PID %d",
> +	ubi_msg(ubi, "background thread \"%s\" started, PID %d",
>  		ubi->bgt_name, task_pid_nr(current));
>
>  	set_freezable();
>  	for (;;) {
>  		int err;
>
> -		if (kthread_should_stop())
> +		if (kthread_should_stop()) {
> +			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
> +				ubi->bgt_name, task_pid_nr(current));
>  			break;
> +		}
>
>  		if (try_to_freeze())
>  			continue;

Here are two new adding messages. Maybe a separate patch is better? Just a
suggestion.


> @@ -1415,8 +1418,9 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
>  	return 0;
>
>  fail:
> -	ubi_err("self-check failed for PEB %d", pnum);
> -	ubi_msg("hex dump of the %d-%d region", offset, offset + len);
> +	ubi_err(ubi, "self-check failed for PEB %d", pnum);
> +	ubi_msg(ubi, "hex dump of the %d-%d region",
> +		 offset, offset + len);
>  	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
>  	err = -EINVAL;
>  error:

Artem, I know you have tried to align the message code in different lines, maybe
you can check if you lose this one.


Thanks~!

Hu



