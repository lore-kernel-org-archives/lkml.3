Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaAXM2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:28:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40758 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaAXM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:28:38 -0500
Date: Fri, 24 Jan 2014 12:28:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out on failures to store terminating NUL
Message-ID: <20140124122837.GU10323@ZenIV.linux.org.uk>
References: <1390565866-30868-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390565866-30868-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:17:46PM +0100, Denys Vlasenko wrote:
> A number of routines wasn't checking that the initial call
> to prepend "\0" to result buffer doesn't fail.
> 
> Coredump code was seeing d_path() with zero-sized buffer
> to erroneously return bogus data (non-error pointer
> pointing before buffer start).
> 
> Users report that this change fixes it.

NAK.  Again, this is not dealing with overflows - it's basic sanity
check on arguments.  Choose which level should that be done at and
just do it there.  As in "if (!buflen) return -ENAMETOOLONG;".
>  		char *cwd = page + PATH_MAX;
>  		int buflen = PATH_MAX;
>  
> -		prepend(&cwd, &buflen, "\0", 1);
> -		error = prepend_path(&pwd, &root, &cwd, &buflen);
> +		error = prepend(&cwd, &buflen, "\0", 1);
> +		if (!error)
> +			error = prepend_path(&pwd, &root, &cwd, &buflen);

Ah, yes - the dreadful case of zero PATH_MAX...
