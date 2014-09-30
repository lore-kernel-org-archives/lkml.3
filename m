Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaI3UAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaI3UAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:00:34 -0400
Date: Tue, 30 Sep 2014 21:57:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wessel <jason.wessel@windriver.com>,
        Roland McGrath <roland@hack.frob.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] modules, split MODULE_STATE_UNFORMED into separate
	states
Message-ID: <20140930195733.GA26492@redhat.com>
References: <1412104110-18441-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412104110-18441-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Prarit Bhargava wrote:
>
> MODULE_STATE_UNFORMED needs to be separated into two states; one for the
> module load (MODULE_STATE_LOAD), and one for the module delete
> (MODULE_STATE_DELETE).

And personally I think this makes sense in any case, but I can't really
comment the changes in this area.

> @@ -3647,18 +3646,29 @@ static int m_show(struct seq_file *m, void *p)
>  	struct module *mod = list_entry(p, struct module, list);
>  	char buf[8];
>  
> -	/* We always ignore unformed modules. */
> -	if (mod->state == MODULE_STATE_UNFORMED)
> +	/*
> +	 * If the state is MODULE_STATE_LOAD then the module is in
> +	 * the early stages of loading.  No information should be printed
> +	 * for this module as the data could be in an uninitialized state.
> +	 */
> +	if (mod->state == MODULE_STATE_LOAD)
>  		return 0;

So this assumes that _UNFORMED state is fine...

Not sure, but I can be easily wrong. For example, print_unload_info() ->
module_refcount() plays with mod->refptr, while free_module() does
module_unload_free() -> free_percpu(mod->refptr). No?

Perhaps it makes sense to start with the simple patch for stable,

	+	// sync with m_show()
	+	mutex_lock(module_mutex);
		mod->state = MODULE_STATE_UNFORMED;
	+	mutex_unlock(module_mutex);

then do a more sophisticated fix?

Oleg.

