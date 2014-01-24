Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaAXQTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:19:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaAXQTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:19:04 -0500
Date: Fri, 24 Jan 2014 17:19:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140124161922.GA14195@redhat.com>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24, Denys Vlasenko wrote:
>
> This change makes __dentry_path() and d_path()
> immediately return ENAMETOOLONG if buflen < 2.

I am not sure about d_path, but as for __dentry_path:

> @@ -3122,13 +3125,14 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
>  	int len, seq = 0;
>  	int error = 0;
>  
> +	if (buflen < 2)
> +		goto Elong;
> +
>  	rcu_read_lock();
>  restart:
>  	end = buf + buflen;
>  	len = buflen;
>  	prepend(&end, &len, "\0", 1);
> -	if (buflen < 1)
> -		goto Elong;

you forgot to mention that this change fixes a bug, this "goto Elong"
leaks rcu_read_lock().

And probably you are right, the fix should be as simple as possible.
But can't we also simplify __dentry_path? Unless I missed something
we can move prepend() up, before rcu_read_lock(), "move Get '/' right"
into that prepend, and even kill retval... OK, most probably I missed
something, but at first glance we can do something like

	static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
	{
		int len, seq = 0;
		int error = 0;
		char *end;

		buf += buflen;
		/* Get '/' right, write "/\0" at the end */
		if (prepend(&buf, &buflen, "/", 2))
			goto Elong;

		rcu_read_lock();
	restart:
		end = buf;
		len = buflen;
		read_seqbegin_or_lock(&rename_lock, &seq);
		while (!IS_ROOT(dentry)) {
			struct dentry *parent = dentry->d_parent;
			int error;

			prefetch(parent);
			error = prepend_name(&end, &len, &dentry->d_name);
			if (error)
				break;

			dentry = parent;
		}
		if (!(seq & 1))
			rcu_read_unlock();
		if (need_seqretry(&rename_lock, seq)) {
			seq = 1;
			goto restart;
		}
		done_seqretry(&rename_lock, seq);
		if (!error)
			return end;
	Elong:
		return ERR_PTR(-ENAMETOOLONG);
	}

Oleg.

