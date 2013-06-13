Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab3FNBuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:50:21 -0400
Received: from ozlabs.org ([203.10.76.45]:49420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933Ab3FNBuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:50:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: don't modify argument of module_kallsyms_lookup_name()
In-Reply-To: <1371058181-23788-1-git-send-email-minipli@googlemail.com>
References: <1371058181-23788-1-git-send-email-minipli@googlemail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 13 Jun 2013 21:20:40 +0930
Message-ID: <87sj0mqlf3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause <minipli@googlemail.com> writes:
> If we pass a pointer to a const string of the form "module:symbol"
> module_kallsyms_lookup_name() will try to split the string at the colon,
> i.e., will try to modify r/o data. That will, in fact, fail on a kernel
> with enabled CONFIG_DEBUG_RODATA.
>
> Avoid modifying the string passed as argument and operate on a copy
> instead in case we need to split the string.

Wow, this has been there forever.

If we've oopsed because we're OOM, this will fail, so I'd rather not do
that.  

How about we add a len arg to find_module_all, like so:

/* Search for module by name: must hold module_mutex. */
static struct module *find_module_all(const char *name,
                                      size_t len,
				      bool even_unformed)
{
	struct module *mod;

	list_for_each_entry(mod, &modules, list) {
		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
			continue;
		if (strlen(mod->name) == len && !memcmp(mod->name, name, len))
			return mod;
	}
	return NULL;
}

Cheers,
Rusty.
