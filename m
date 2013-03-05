Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922Ab3CEFEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:04:48 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:53734 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3CEFEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <51356BD8.4040408@cn.fujitsu.com>
References: <1362454007-353-1-git-send-email-ebiederm@xmission.com>
	<51356BD8.4040408@cn.fujitsu.com>
Date: Tue, 5 Mar 2013 02:04:45 -0300
Message-ID: <CACz=WeetSxr5hb3BAKn7ks-yrMyCtgZ5HZjE+V14trmnoH+61g@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/pid_namespace.c: Fixing a lack of cleanup
 (Probable resources leak).
From: Raphael S Carvalho <raphael.scarv@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 12:51 AM, Gao feng <gaofeng@cn.fujitsu.com> wrote:
> On 2013/03/05 11:26, Eric W. Biederman wrote:
>> From: Raphael S.Carvalho <raphael.scarv@gmail.com>
>>
>> Starting point: create_pid_namespace()
>>
>> Suppose create_pid_cachep() was executed sucessfully, thus:
>> pcache was allocated by kmalloc().
>> cachep received a cache created by kmem_cache_create().
>> and pcache->list was added to the list pid_caches_lh.
>>
>> So what would happen if proc_alloc_inum() returns an error?
>> The resources allocated by create_pid_namespace() would be deallocated!
>> How about those resources allocated by create_pid_cachep()?
>> By knowing that, I created this patch in order to fix that!
>>
>> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
>> ---
>
> Actually I noticed this problem and I think it is not a BUG.
> Since the pid_cache is created for all pid namespace which have the same level.
> Even this pid namespace is failed to create, the pid_cache will not be leaked, Other
> pid namespace which has the same level will use the pid_cache and no need to
> allocate it again. In other words, the pid_cache for every level pid namespace will
> only be created once.
>
> I also think this patch add a bug,because there may be other pid namespace's pid_cachep
> points to the same pid_cache which will be free at the by label out_free_cachep.
>

Yeah, I found the snippet of code which searches for the pcache with
the same level.
 46        list_for_each_entry(pcache, &pid_caches_lh, list)
 47                if (pcache->nr_ids == nr_ids)
 48                        goto out;

Regards,
Raphael S.Carvalho
