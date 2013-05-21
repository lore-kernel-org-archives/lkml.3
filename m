Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3EUPfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:35:38 -0400
Received: from fieldses.org ([174.143.236.118]:59524 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab3EUPfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:35:37 -0400
Date: Tue, 21 May 2013 11:35:31 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        akpm@linux-foundation.org, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        bharrosh@panasas.com, devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130521153531.GO14677@fieldses.org>
References: <20130520070017.7957.9224.stgit@localhost.localdomain>
 <20130520135716.GA10084@redhat.com>
 <519A3693.8020006@parallels.com>
 <20130520151001.GA13173@redhat.com>
 <20130520212412.GI14677@fieldses.org>
 <20130521152836.GA13461@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521152836.GA13461@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 05:28:36PM +0200, Oleg Nesterov wrote:
> You know, I am puzzled. Everything looks so clear that I can't
> understand what I could miss.
> 
> On 05/20, J. Bruce Fields wrote:
> >
> > On Mon, May 20, 2013 at 05:10:01PM +0200, Oleg Nesterov wrote:
> > > On 05/20, Stanislav Kinsbursky wrote:
> > > >
> > > OK, why nfs can't simply use this code
> > >
> > > 	static int umh_set_fs_root(struct subprocess_info *info, struct cred *new)
> > > 	{
> > > 		set_fs_root(current->fs, sub_info->data);
> > > 		return 0;
> > > 	}
> > >
> > > 	int call_usermodehelper_root(char *path, char **argv, char **envp, int wait,
> > > 				     struct path *root)
> > > 	{
> > >
> > > 		struct subprocess_info *info;
> > >
> > > 		info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
> > > 							umh_set_fs_root, NULL, root);
> > > 		if (info == NULL)
> > > 			return -ENOMEM;
> > > 		return call_usermodehelper_exec(info, wait);
> > > 	}
> >
> > Right, that's more or less what Stanislav proposed before:
> >
> > 	https://patchwork.kernel.org/patch/2449081/
> >
> > (though with an open-coded set_fs_root).  Jeff and I asked him to try
> > this approach instead.
> 
> And I still can't understand why you do not like this.
> 
> > > ? Why do you want to add the new member, the new arguments, the new helpers?
> >
> > 	- It's simpler for callers to be able to say "run this help in
> > 	  that namespace" in a single line.  We expect there will be
> > 	  more such callers, so the mild complication of the API seems
> > 	  worth it for the convenience.
> 
> So call_usermodehelper_root() above doesn't look as a simple API for you?
> 
> Add it into kmod.c (or another place) and use it everywhere, why do
> insist we should complicate the generic code?
> 
> What if someone wants to, say, change "nice" before running the helper?
> Do you think that we need yet another change which turns
> call_usermodehelper_setup_root() added by this patch into
> call_usermodehelper_setup_root_nice()? And another member in sub_info?
> And the "if (sub_info->nice)" check into ____call_usermodehelper() ?
> 
> > 	- set_fs_root looks like something that shouldn't really be used
> > 	  outside of a small number of well-known callers in core code.
> 
> OK, so do not do this. Export the new helper.

You mean, export umh_set_fs_root() in the above?

That might be OK.

---b.
