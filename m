Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaKEQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:58:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaKEQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:58:38 -0500
Date: Wed, 5 Nov 2014 11:58:33 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Subject: Re: [PATCH] audit_tree: keep inode pinned
Message-ID: <20141105165833.GE5902@madcap2.tricolour.ca>
References: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/04, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>

Hi Miklos,

> Audit rules disappear when an inode they watch is evicted from the cache.
> This is likely not what we want.
> 
> The guilty commit is "fsnotify: allow marks to not pin inodes in core",
> which didn't take into account that audit_tree adds watches with a zero
> mask.
> 
> Adding any mask should fix this.

Nice find!  Do you have a quick reproducer to detect this?

> Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: stable@vger.kernel.org # 2.6.36+
> ---
>  kernel/audit_tree.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(i
>  		chunk->owners[i].index = i;
>  	}
>  	fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
> +	chunk->mark.mask = FS_IN_IGNORED;
>  	return chunk;
>  }
>  

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
