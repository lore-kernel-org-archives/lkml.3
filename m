Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab3JOSkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:40:45 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44430 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3JOSko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:40:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Guillaume Gaudonville" <gaudonville@6wind.com>
Cc: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com,
        Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
References: <1381858522-21341-1-git-send-email-guillaume.gaudonville@6wind.com>
Date: Tue, 15 Oct 2013 11:40:25 -0700
In-Reply-To: <1381858522-21341-1-git-send-email-guillaume.gaudonville@6wind.com>
	(Guillaume Gaudonville's message of "Tue, 15 Oct 2013 19:35:22 +0200")
Message-ID: <87y55u1ip2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19phXYFXUm2H0X7UsC1nn6iy6mLAYQG7Fc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0208]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Guillaume Gaudonville" <gaudonville@6wind.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH linux-next] ns: do not allocate a new nsproxy at each call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Guillaume Gaudonville" <gaudonville@6wind.com> writes:

> Currently, at each call of setns system call a new nsproxy is allocated,
> the old nsproxy namespaces are copied into the new one and the old nsproxy
> is freed if the task was the only one to use it.
>
> It can creates large delays on hardware with large number of cpus since
> to free a nsproxy a synchronize_rcu() call is done.
>
> When a task is the only one to use a nsproxy, only the task can do an action
> that will make this nsproxy to be shared by another task or thread (fork,...).
> So when the refcount of the nsproxy is equal to 1, we can simply update the
> current nsproxy field without allocating a new one and freeing the old one.
>
> The install operations of each kind of namespace cannot fails, so there's no
> need to check for an error and calling ops->install().
>
> Tested on TileGX (36 cores) and Intel (32 cores).

This may be worth doing (I am a little scared of a design that has setns
on a fast path) but right now this isn't safe.

Currently pidns_install ends with:

	put_pid_ns(nsproxy->pid_ns_for_children);
	nsproxy->pid_ns_for_children = get_pid_ns(new);
	return 0;


And netns_install ends with:

	put_net(nsproxy->net_ns);
	nsproxy->net_ns = get_net(net);
	return 0;

The put before the set is not atomic and is not safe unless
the nsproxy is private.  I think this is fixable but it requires a more
indepth look at the code than you have done.

Mind if I ask where this comes up?


> Reported-by: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
> ---
>  kernel/nsproxy.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index afc0456..afc04ac 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -255,6 +255,18 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
>  	if (nstype && (ops->type != nstype))
>  		goto out;
>  
> +	/*
> +	 * If count == 1, only the current task can increment it,
> +	 * by doing a fork for example so we can safely update the
> +	 * current nsproxy pointers without allocate a new one,
> +	 * update it and destroy the old one
> +	 */
> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
> +		err = ops->install(tsk->nsproxy, ei->ns);
> +		fput(file);
> +		return err;
> +	}

As a minor nit, but to match the rest of the code in this function that
should read:

> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
> +		err = ops->install(tsk->nsproxy, ei->ns);
> +		goto out;
> +	}

There is no need to add an additional exit point to reason about.

> +
>  	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
>  	if (IS_ERR(new_nsproxy)) {
>  		err = PTR_ERR(new_nsproxy);
