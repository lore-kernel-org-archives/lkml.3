Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaCYFzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:55:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47205 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCYFzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:55:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Message-ID: <53311A12.50506@jp.fujitsu.com>
Date: Tue, 25 Mar 2014 14:54:26 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: rostedt@goodmis.org, masami.hiramatsu.pt@hitachi.com
CC: fweisbec@gmail.com, mingo@redhat.com, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>	<5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home>
In-Reply-To: <20140324105939.7f823b81@gandalf.local.home>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/24 23:59), Steven Rostedt wrote:
> On Mon, 24 Mar 2014 20:26:05 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> Thank you for reporting with this pretty backtrace :)
>> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).
> 
> Looks to be more of a module issue than a ftrace issue.
> 
>>
>> If the ftrace can set loading module text read only before the module subsystem
>> expected, I think it should be protected by the module subsystem itself
>> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
>>
> 
> Does this patch fix it?

Yep, I tested using my reproducer and confirmed that this patch fixed
this issue, thanks!

Thanks,
Takao Indoh

> 
> In-review-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 5a50539..a1acabf 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -207,10 +207,11 @@ struct module_use {
>   };
>   
>   enum module_state {
> -	MODULE_STATE_LIVE,	/* Normal state. */
> -	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> -	MODULE_STATE_GOING,	/* Going away. */
> -	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> +	MODULE_STATE_LIVE,		/* Normal state. */
> +	MODULE_STATE_COMING,		/* Full formed, running module_init. */
> +	MODULE_STATE_COMING_FINAL,	/* Ready to be changed to read only. */
> +	MODULE_STATE_GOING,		/* Going away. */
> +	MODULE_STATE_UNFORMED,		/* Still setting it up. */
>   };
>   
>   /**
> diff --git a/kernel/module.c b/kernel/module.c
> index d24fcf2..0905bed 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1805,7 +1805,8 @@ void set_all_modules_text_ro(void)
>   
>   	mutex_lock(&module_mutex);
>   	list_for_each_entry_rcu(mod, &modules, list) {
> -		if (mod->state == MODULE_STATE_UNFORMED)
> +		if (mod->state == MODULE_STATE_UNFORMED ||
> +		    mod->state == MODULE_STATE_COMING)
>   			continue;
>   		if ((mod->module_core) && (mod->core_text_size)) {
>   			set_page_attributes(mod->module_core,
> @@ -3020,6 +3021,13 @@ static int do_init_module(struct module *mod)
>   	blocking_notifier_call_chain(&module_notify_list,
>   			MODULE_STATE_COMING, mod);
>   
> +	/*
> +	 * This module must not be changed by set_all_modules_text_ro()
> +	 * until we get here. Otherwise notifiers that change text
> +	 * (like ftrace does) will break.
> +	 */
> +	mod->state = MODULE_STATE_COMING_FINAL;
> +
>   	/* Set RO and NX regions for core */
>   	set_section_ro_nx(mod->module_core,
>   				mod->core_text_size,
> 
> 
> 


-- 
印藤隆夫(INDOH Takao)
 E-Mail : indou.takao@jp.fujitsu.com
 TEL    : 7551-4832(055-924-7241)
富士通(株) PFソ事本)Linux開発統括部 開発部

