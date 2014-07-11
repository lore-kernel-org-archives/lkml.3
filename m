Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaGKO2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:28:10 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:52421
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaGKO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:28:09 -0400
Date: Fri, 11 Jul 2014 16:28:06 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Serge Hallyn (serge.hallyn@ubuntu.com)" <serge.hallyn@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Could not mount sysfs when enable userns but disable netns
Message-ID: <20140711142806.GA26441@mail.hallyn.com>
References: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
> Hello,
> 
> How to reproduce:
> 1. Prepare a container, enable userns and disable netns
> 2. use libvirt-lxc to start a container
> 3. libvirt could not mount sysfs then failed to start.
> 
> Then I found that
> commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e says:
> "Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
> over the net namespace."
> 
> But why should we check sysfs mouont permission over net namespace?
> We've already checked CAP_SYS_ADMIN though.
> 
> What the relationship between sysfs and net namespace,
> or this check is a little redundant?

It is not redundant.  The whole point is that after clone(CLONE_NEWUSER)
you get a newly filled set of capabilities.  But you should not have
privileges over the host's network namesapce.  After you unshare a new
network namespace, you *should* have privilege over it.  So the fact
that we've already check CAP_SYS_ADMIN means nothing, because the
capabilities need to be targeted.

> Any insights on this?
> 
> Thanks,
> - Chen
> 
> PS: codes below could be a workaround
> 
> @@ -34,7 +35,8 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
>                 if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
>                         return ERR_PTR(-EPERM);
>  
> -               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
> +               if (current->nsproxy->net_ns != &init_net &&
> +                    !kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
>                         return ERR_PTR(-EPERM);
>         }
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
