Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbbANVz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:55:27 -0500
Received: from fieldses.org ([174.143.236.118]:39132 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbANVz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:55:26 -0500
Date: Wed, 14 Jan 2015 16:55:25 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH 0/5] Second attempt at contained helper execution
Message-ID: <20150114215525.GB7071@fieldses.org>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 05:32:22PM +0800, Ian Kent wrote:
> This series is a further attempt to find how (or even an acceptable
> way) to execute a usermode helper in a contained environment.
> 
> Being an attempt to find how to do this no testing has been done and
> won't be until a suitable approach can be agreed on, if at all.
> 
> >From previous discussion seperation between the caller and the
> execution environment is required for security reasons.
> 
> It was suggested that a thread be created for each mount and be used
> as the basis for the execution environment. There are a number of
> problems with this, not the least of which is scaling to a large
> numbers of mounts, and there may not be a mount corresponding the the
> needed callback

Remind me what example you're thinking of here?

--b.

> which amounts to creating the process from the context
> of the caller which we don't want to do.
> 
> But now, when a usermode helper is executed the root init namespace is
> used and has proven to be adequate. So perhaps it will also be adequate
> to use the same approach for contained execution by using the container
> init namespace as the basis for the execution.
> 
> That's essentially all this series attempts to do.
> 
> There are other difficulties to tackle as well, such as how to decide
> if contained helper execution is needed. For example, if a mount has
> been propagated to a container or bound into the container tree (such
> as with the --volume option of "docker run") the root init namespace
> may need to be used and not the container namespace.
> 
> There's also the rather resource heavy method that is used here to
> enter the target namespace which probably needs work but is out of
> scope for this series if in fact this approach is even acceptable.
> 
> Comments please?
> 
> ---
> 
> Ian Kent (5):
>       nsproxy - refactor setns()
>       kmod - rename call_usermodehelper() flags parameter
>       kmod - teach call_usermodehelper() to use a namespace
>       KEYS - rename call_usermodehelper_keys() flags parameter
>       KEYS: exec request-key within the requesting task's init namespace
> 
> 
>  include/linux/kmod.h        |   21 ++++++-
>  include/linux/nsproxy.h     |    1 
>  kernel/kmod.c               |  135 +++++++++++++++++++++++++++++++++++++++----
>  kernel/nsproxy.c            |   21 ++++---
>  security/keys/request_key.c |   51 ++++++++++++++--
>  5 files changed, 201 insertions(+), 28 deletions(-)
> 
> --
> Ian
