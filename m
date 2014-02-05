Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaBERmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaBERmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:42:44 -0500
Date: Wed, 5 Feb 2014 18:42:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] fs: fix d_path() with zero-length input buffer
Message-ID: <20140205174245.GA26039@redhat.com>
References: <1391621647-7905-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391621647-7905-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Denys Vlasenko wrote:
>
> In prepend_name(), *buflen < dlen + 1 comparison is buggy
> because dlen has unsigned data type, and we can reach this location
> with *buflen == -1.

because, say, path_with_deleted() doesn't check the result of
prepend(), and prepend() updates *buflen unconditionally. I am
wondering if it should be changed too just for consistency.

> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2833,7 +2833,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
>  	u32 dlen = ACCESS_ONCE(name->len);
>  	char *p;
>
> -	if (*buflen < dlen + 1)
> +	if (*buflen < (int)dlen + 1)

perhaps it would be better to simply make dlen "int" ?

Oleg.

