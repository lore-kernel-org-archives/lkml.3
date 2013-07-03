Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab3GCVCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:02:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054Ab3GCVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:02:48 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=ybDC0pOYkY2W5h7lZHsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372885365.22688.126.camel@gandalf.local.home>
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Jul 2013 17:02:45 -0400
In-Reply-To: <20130703191748.GA2884@redhat.com>
References: <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
	 <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>
	 <20130703175420.GA25668@redhat.com>
	 <1372874547.22688.111.camel@gandalf.local.home>
	 <20130703191748.GA2884@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 21:17 +0200, Oleg Nesterov wrote:

> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 4888cb3..c23d41e 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -475,6 +475,7 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
>  				kfree(dentry->d_inode->i_private);
>  				/* fall through */
>  			default:
> +				dentry->d_inode->i_private = NULL;
>  				simple_unlink(parent->d_inode, dentry);
>  				break;
>  			}

Ah, I see what you are saying. If the file is being opened just as it is
being deleted, it can up the dentry refcount and prevent it from
actually being deleted at that point. :-p

There's a slight race that we can get to the open call when the dentry
was deleted. But can it? Seems that there would be other places that
have issues as I would think it would be common to do something like:

	data = kmalloc(size, GFP_KERNEL);
	dentry = debugfs_create_file("file", 0644, parent, data, &ops);

[...]

	debugfs_remove(dentry);
	kfree(data);

Any thing like this would have issues if the open referenced the data.

-- Steve


