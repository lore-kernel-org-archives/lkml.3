Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3CIU11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:27:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab3CIU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:27:26 -0500
Date: Sat, 9 Mar 2013 21:25:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KEYS: split call to call_usermodehelper_fns()
Message-ID: <20130309202537.GD16399@redhat.com>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi> <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Lucas De Marchi wrote:
>
>  static int call_usermodehelper_keys(char *path, char **argv, char **envp,
>  					struct key *session_keyring, int wait)
>  {
> -	return call_usermodehelper_fns(path, argv, envp, wait,
> -				       umh_keys_init, umh_keys_cleanup,
> -				       key_get(session_keyring));
> +	struct subprocess_info *info;
> +
> +	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
> +					  umh_keys_init, umh_keys_cleanup,
> +					  key_get(session_keyring));
> +	if (!info) {
> +		key_put(session_keyring);
> +		return -ENOMEM;
> +	}
> +
> +	return call_usermodehelper_exec(info, wait);

Looks correct, but can't we simpluify it a bit?

	info = call_usermodehelper_setup(session_keyring);
	if (!info)
		return ENOMEM;

	key_get(session_keyring));
	return call_usermodehelper_exec(info);

Oleg.

