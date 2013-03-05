Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3CEGcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:32:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45670 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CEGcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:32:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
References: <1362454103-391-1-git-send-email-raphael.scarv@gmail.com>
Date: Mon, 04 Mar 2013 22:32:14 -0800
In-Reply-To: <1362454103-391-1-git-send-email-raphael.scarv@gmail.com>
	(Raphael S. Carvalho's message of "Tue, 5 Mar 2013 00:28:23 -0300")
Message-ID: <874ngqe4r5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+xQHjrJKz57g+3ipZKCfCc86EcFJG/BUI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4423]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Raphael S.Carvalho" <raphael.scarv@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] kernel/pid_namespace.c: Fixing a lack of cleanup (Probable resources leak).
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Raphael S.Carvalho" <raphael.scarv@gmail.com> writes:

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

pid caches are not per namespace.  There are per pid namespace depth
and shared among many pid namespaces so in general a leak is fine.

We definitely can't do what you are doing.  There are no checks that
another pid namespace doesn't have pids allocated from the pid cache
you are freeing nor any checks to see that the pid cache was allocated
uniquely per pid namespace.

Under the right circumstances you might be able to free pid caches
but it is hard to figure out what those circumstances are and I don't
expect it is worth the trouble.

Eric


> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> ---
>  kernel/pid_namespace.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index c1c3dc1..d94e4b6 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -37,7 +37,7 @@ static struct kmem_cache *pid_ns_cachep;
>   * @nr_ids: the number of numerical ids this pid will have to carry
>   */
>  
> -static struct kmem_cache *create_pid_cachep(int nr_ids)
> +static struct pid_cache *create_pid_cachep(int nr_ids)
>  {
>  	struct pid_cache *pcache;
>  	struct kmem_cache *cachep;
> @@ -63,7 +63,7 @@ static struct kmem_cache *create_pid_cachep(int nr_ids)
>  	list_add(&pcache->list, &pid_caches_lh);
>  out:
>  	mutex_unlock(&pid_caches_mutex);
> -	return pcache->cachep;
> +	return pcache;
>  
>  err_cachep:
>  	kfree(pcache);
> @@ -85,6 +85,7 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
>  	struct pid_namespace *parent_pid_ns)
>  {
>  	struct pid_namespace *ns;
> +	struct pid_cache *pcache;
>  	unsigned int level = parent_pid_ns->level + 1;
>  	int i;
>  	int err;
> @@ -103,15 +104,16 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
>  	if (!ns->pidmap[0].page)
>  		goto out_free;
>  
> -	ns->pid_cachep = create_pid_cachep(level + 1);
> -	if (ns->pid_cachep == NULL)
> +	pcache = create_pid_cachep(level + 1);
> +	if (pcache == NULL)
>  		goto out_free_map;
>  
>  	err = proc_alloc_inum(&ns->proc_inum);
>  	if (err)
> -		goto out_free_map;
> +		goto out_free_cachep;
>  
>  	kref_init(&ns->kref);
> +	ns->pid_cachep = pcache->cachep;
>  	ns->level = level;
>  	ns->parent = get_pid_ns(parent_pid_ns);
>  	ns->user_ns = get_user_ns(user_ns);
> @@ -126,6 +128,10 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
>  
>  	return ns;
>  
> +out_free_cachep:
> +	kmem_cache_destroy(pcache->cachep);
> +	list_del(&pcache->list);
> +	kfree(pcache);
>  out_free_map:
>  	kfree(ns->pidmap[0].page);
>  out_free:
