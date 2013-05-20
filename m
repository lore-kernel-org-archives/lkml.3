Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3ETVYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:24:21 -0400
Received: from fieldses.org ([174.143.236.118]:59531 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab3ETVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:24:20 -0400
Date: Mon, 20 May 2013 17:24:13 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        akpm@linux-foundation.org, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        bharrosh@panasas.com, devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130520212412.GI14677@fieldses.org>
References: <20130520070017.7957.9224.stgit@localhost.localdomain>
 <20130520135716.GA10084@redhat.com>
 <519A3693.8020006@parallels.com>
 <20130520151001.GA13173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520151001.GA13173@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 05:10:01PM +0200, Oleg Nesterov wrote:
> On 05/20, Stanislav Kinsbursky wrote:
> >
> > Moreover, set_fs_root() is not exported.
> 
> Then it should be exported, I think ;)

Maybe--there are objections, see below.

> Or you can export the new helper.
> 
> > And adding an ability of a root swap to usermode helper looks quite logical. At least from the
> > "containers" point of view, which usually have it's own root.
> 
> But it is not logical to uglify the code, imho.
> 
> OK, why nfs can't simply use this code
> 
> 	static int umh_set_fs_root(struct subprocess_info *info, struct cred *new)
> 	{
> 		set_fs_root(current->fs, sub_info->data);
> 		return 0;
> 	}
> 
> 	int call_usermodehelper_root(char *path, char **argv, char **envp, int wait,
> 				     struct path *root)
> 	{
> 
> 		struct subprocess_info *info;
> 
> 		info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
> 							umh_set_fs_root, NULL, root);
> 		if (info == NULL)
> 			return -ENOMEM;
> 		return call_usermodehelper_exec(info, wait);
> 	}

Right, that's more or less what Stanislav proposed before:

	https://patchwork.kernel.org/patch/2449081/

(though with an open-coded set_fs_root).  Jeff and I asked him to try
this approach instead.

> ? Why do you want to add the new member, the new arguments, the new helpers?

	- It's simpler for callers to be able to say "run this help in
	  that namespace" in a single line.  We expect there will be
	  more such callers, so the mild complication of the API seems
	  worth it for the convenience.

	- set_fs_root looks like something that shouldn't really be used
	  outside of a small number of well-known callers in core code.
	  This has come up a few times before; one I could find on a quick
	  search:

		http://thread.gmane.org/gmane.linux.kernel/267932/focus=267998

	  Consensus there seems to be that users of the previously
	  exported set_fs_root were mostly buggy.  And specifically that
	  adding the parameter to the usermode_helper api would be safer
	  than exporting set_fs_root.

--b.
