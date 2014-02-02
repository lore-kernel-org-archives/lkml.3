Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaBBCkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:40:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43749 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaBBCkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:40:43 -0500
Message-ID: <52EDB022.5070101@hitachi.com>
Date: Sun, 02 Feb 2014 11:40:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hskinnemoen@gmail.com,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        egtvedt@samfundet.no
Subject: Re: [PATCH] kernel/kprobes.c: move cleanup_rp_inst() to where CONFIG_KRETPROBES
 enabled
References: <52ECE5D8.6090209@gmail.com>
In-Reply-To: <52ECE5D8.6090209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/01 21:17), Chen Gang wrote:
> When CONFIG_KRETPROBES disabled, cleanup_rp_inst() is useless too. It
> is only called by unregister_kretprobes() which is in CONFIG_KRETPROBES
> enabled area.
> 
> The related warning (allmodconfig under avr32):
> 
>   kernel/kprobes.c:1181: warning: 'cleanup_rp_inst' defined but not used

This patch itself looks good to me.
And it seems that not only the cleanup_rp_inst, but also other
kretprobe related functions should be moved (free_rp_inst,etc)

Thank you,

> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  kernel/kprobes.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index ceeadfc..18a520d 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1178,26 +1178,6 @@ static inline void free_rp_inst(struct kretprobe *rp)
>  	}
>  }
>  
> -static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
> -{
> -	unsigned long flags, hash;
> -	struct kretprobe_instance *ri;
> -	struct hlist_node *next;
> -	struct hlist_head *head;
> -
> -	/* No race here */
> -	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
> -		kretprobe_table_lock(hash, &flags);
> -		head = &kretprobe_inst_table[hash];
> -		hlist_for_each_entry_safe(ri, next, head, hlist) {
> -			if (ri->rp == rp)
> -				ri->rp = NULL;
> -		}
> -		kretprobe_table_unlock(hash, &flags);
> -	}
> -	free_rp_inst(rp);
> -}
> -
>  /*
>  * Add the new probe to ap->list. Fail if this is the
>  * second jprobe at the address - two jprobes can't coexist
> @@ -1885,6 +1865,26 @@ void __kprobes unregister_kretprobe(struct kretprobe *rp)
>  }
>  EXPORT_SYMBOL_GPL(unregister_kretprobe);
>  
> +static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
> +{
> +	unsigned long flags, hash;
> +	struct kretprobe_instance *ri;
> +	struct hlist_node *next;
> +	struct hlist_head *head;
> +
> +	/* No race here */
> +	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
> +		kretprobe_table_lock(hash, &flags);
> +		head = &kretprobe_inst_table[hash];
> +		hlist_for_each_entry_safe(ri, next, head, hlist) {
> +			if (ri->rp == rp)
> +				ri->rp = NULL;
> +		}
> +		kretprobe_table_unlock(hash, &flags);
> +	}
> +	free_rp_inst(rp);
> +}
> +
>  void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
>  {
>  	int i;
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


