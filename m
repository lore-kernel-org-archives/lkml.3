Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaIDKLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:11:33 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:44986 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbaIDKLc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:11:32 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Date: Thu, 4 Sep 2014 06:11:30 -0400 (EDT)
Subject: =?utf-8?Q?RE=3A_=5BPATCH_v2_4=2F4=5D_clk=3A_Use_ww=5Fmutexes_for_clk=5Fpr?=
 =?utf-8?Q?epare=5F=7Block=2Funlock=7D?=
From: kiran.padwal@smartplayin.com
To: "Stephen Boyd" <sboyd@codeaurora.org>
Cc: "Mike Turquette" <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <1409792466-5092-5-git-send-email-sboyd@codeaurora.org>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org> 
 <1409792466-5092-5-git-send-email-sboyd@codeaurora.org>
Message-ID: <1409825490.812215098@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wednesday, September 3, 2014 9:01pm, "Stephen Boyd" <sboyd@codeaurora.org> said:

> Changing the rate of a "slow" clock can take 10s of milliseconds
> while changing the rate of a "fast" clock can be done in a few

<snip>

> -static void clk_prepare_lock(void)
> +static void __clk_unlock(struct list_head *list)
> +{
> +	struct clk *entry, *temp;
> +
> +	list_for_each_entry_safe (entry, temp, list, ww_list) {

Checkpatch warning for above line,
WARNING: space prohibited between function name and open parenthesis '('

> +		list_del_init(&entry->ww_list);
> +		ww_mutex_unlock(&entry->lock);
> +	}
> +}
> +
> +static void clk_unlock(struct list_head *list, struct ww_acquire_ctx *ctx)
> +{

<snip>

> +	ww_acquire_init(ctx, &prepare_ww_class);
> +	do {
> +		ret = __clk_prepare_lock(clk, list, ctx);
> +	} while (ret == -EDEADLK);
> +	ww_acquire_done(ctx);
> +}
> +
> +static int __clk_unprepare_lock(struct clk *clk, struct list_head *list,
> +			         struct ww_acquire_ctx *ctx)

Checkpatch error for above line,
ERROR: code indent should use tabs where possible

Best Regards,
Kiran Padwal

> +{
> +	int ret;
> +
> +	do {
> +		ret = clk_lock_one(clk, list, ctx);
> +		if (ret == -EDEADLK)
> +			return ret;
> +
> +		if (clk->prepare_count > 1)
> +			break;
> +	} while ((clk = clk->parent));
> +
> +	return 0;
> +}


