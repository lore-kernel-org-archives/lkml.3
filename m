Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3CEDvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:51:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab3CEDvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:51:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355068800"; 
   d="scan'208";a="6812824"
Message-ID: <51356BD8.4040408@cn.fujitsu.com>
Date: Tue, 05 Mar 2013 11:51:52 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <raphael.scarv@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid_namespace.c: Fixing a lack of cleanup
 (Probable resources leak).
References: <1362454007-353-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1362454007-353-1-git-send-email-ebiederm@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:50:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/05 11:50:04,
	Serialize complete at 2013/03/05 11:50:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/03/05 11:26, Eric W. Biederman wrote:
> From: Raphael S.Carvalho <raphael.scarv@gmail.com>
> 
> Starting point: create_pid_namespace()
> 
> Suppose create_pid_cachep() was executed sucessfully, thus:
> pcache was allocated by kmalloc().
> cachep received a cache created by kmem_cache_create().
> and pcache->list was added to the list pid_caches_lh.
> 
> So what would happen if proc_alloc_inum() returns an error?
> The resources allocated by create_pid_namespace() would be deallocated!
> How about those resources allocated by create_pid_cachep()?
> By knowing that, I created this patch in order to fix that!
> 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> ---

Actually I noticed this problem and I think it is not a BUG.
Since the pid_cache is created for all pid namespace which have the same level.
Even this pid namespace is failed to create, the pid_cache will not be leaked, Other
pid namespace which has the same level will use the pid_cache and no need to
allocate it again. In other words, the pid_cache for every level pid namespace will
only be created once.

I also think this patch add a bug,because there may be other pid namespace's pid_cachep
points to the same pid_cache which will be free at the by label out_free_cachep.

