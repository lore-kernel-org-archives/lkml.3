Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaKYVxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:53:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaKYVxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:53:01 -0500
Date: Tue, 25 Nov 2014 22:52:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
Message-ID: <20141125215248.GA7958@redhat.com>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box> <20141125010734.4974.85347.stgit@pluto.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125010734.4974.85347.stgit@pluto.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me first apologize, I didn't actually read this series yet.

But I have to admit that so far I do not like this approach...
probably I am biased.

On 11/25, Ian Kent wrote:
>
> The call_usermodehelper() function executes all binaries in the
> global "init" root context. This doesn't allow a binary to be run
> within the callers namespace (aka. a container).

Please see below.

> Both containerized NFS client and NFS server need the ability to
> execute a binary within their container. To do this create a new
> nsproxy within the callers' context so it can be used for setup
> prior to calling do_execve() from the user mode helper thread
> runner.

and probably we also need this for coredump helpers, we want them
to be per-namespace.

> +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
> +{
> +	struct nsproxy *ns = info->data;
> +
> +	mntns_setfs(ns->mnt_ns);

Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
Let me remind about the coredump. The dumping task can cloned with
CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
this enough.


> +	switch_task_namespaces(current, ns);

This doesn't look sane because this won't switch task_active_pid_ns().

And this reminds me another discussion, please look at
http://marc.info/?l=linux-kernel&m=138479570926192

Once again, this is just an idea to provoke more discussion. I am starting
to think that perhaps we need pid_ns->umh_helper (init by default). And
PR_SET_NS_UMH_HELPER.

Not sure.

Oleg.

