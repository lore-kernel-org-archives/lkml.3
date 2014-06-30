Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaF3FuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:50:18 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58207 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaF3FuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:50:16 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: Change unregister/apply to WARN() if uprobe/consumer is gone
References: <20140627170116.GA18298@redhat.com>
	<20140627170140.GA18322@redhat.com>
Date: Mon, 30 Jun 2014 14:50:13 +0900
In-Reply-To: <20140627170140.GA18322@redhat.com> (Oleg Nesterov's message of
	"Fri, 27 Jun 2014 19:01:40 +0200")
Message-ID: <87fvin54kq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 19:01:40 +0200, Oleg Nesterov wrote:
> Add WARN_ON's into uprobe_unregister() and uprobe_apply() to ensure
> that nobody tries to play with the dead uprobe/consumer. This helps
> to catch the bugs like the one fixed by the previous patch.
>
> In the longer term we should fix this poorly designed interface.
> uprobe_register() should return "struct uprobe *" which should be
> passed to apply/unregister. Plus other semantic changes, see the
> changelog in commit 41ccba029e94.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  kernel/events/uprobes.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index c445e39..6f3254e 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -846,7 +846,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
>  {
>  	int err;
>  
> -	if (!consumer_del(uprobe, uc))	/* WARN? */
> +	if (WARN_ON(!consumer_del(uprobe, uc)))
>  		return;
>  
>  	err = register_for_each_vma(uprobe, NULL);
> @@ -927,7 +927,7 @@ int uprobe_apply(struct inode *inode, loff_t offset,
>  	int ret = -ENOENT;
>  
>  	uprobe = find_uprobe(inode, offset);
> -	if (!uprobe)
> +	if (WARN_ON(!uprobe))
>  		return ret;
>  
>  	down_write(&uprobe->register_rwsem);
> @@ -952,7 +952,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
>  	struct uprobe *uprobe;
>  
>  	uprobe = find_uprobe(inode, offset);
> -	if (!uprobe)
> +	if (WARN_ON(!uprobe))
>  		return;
>  
>  	down_write(&uprobe->register_rwsem);
