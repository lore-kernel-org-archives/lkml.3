Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbbAZVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:44:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:44:23 -0500
Date: Mon, 26 Jan 2015 21:44:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126214421.GP29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126154259.5e650d32@gandalf.local.home>
 <20150126154419.409e7138@gandalf.local.home>
 <20150126155822.301523e3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126155822.301523e3@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 03:58:22PM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 15:44:19 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Now what I could also do is to only allow this to be called once. And
> > in that case, we can hard code what mkdir and rmdir are. This could
> > work as currently there only exists a single instance of the instances
> > directory.
> > 
> > I might just do that too.
> 
> And just did:
> 
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index c7eb4c58579e..13e17bf677f4 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -50,6 +50,11 @@ static const struct file_operations tracefs_file_operations = {
>  	.llseek =	noop_llseek,
>  };
>  
> +struct tracefs_dir_ops {
> +	int (*mkdir)(const char *name);
> +	int (*rmdir)(const char *name);
> +};

Why go through that indirection at all...

> +struct dentry *tracefs_create_instance_dir(const char *name, struct dentry *parent,
> +					   int (*mkdir)(const char *name),
> +					   int (*rmdir)(const char *name));

... when there's exactly one caller of that thing, and the values of
mkdir and rmdir callbacks are the same on each call?
