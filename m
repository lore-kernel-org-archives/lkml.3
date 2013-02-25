Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab3BYPFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab3BYPFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:05:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Date: Mon, 25 Feb 2013 15:05:14 +0000
Message-ID: <10238.1361804714@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> Callers of call_usermodehelper_fns() should check the return value and
> free themselves the data passed if the return is -ENOMEM. This is
> because the subprocess_info is allocated in this function, and if the
> allocation fail, the cleanup function cannot be called.
> 
> However call_usermodehelper_exec() may also return -ENOMEM, in which
> case the cleanup function is called. This means that if the caller
> checked the return code, it was risking running the cleanup twice (like
> kernel/sys.c:orderly_poweroff()) and if not, a leak could happen.
> 
> This patch fixes both call_usermodehelper_fns() to never call the
> cleanup function in case retval == -ENOMEM and also the callers to
> actually check the return value of this function.

I suspect it's probably better to always call the cleanup function from
call_usermodehelper_fns() rather than have the cleanup done by the caller in
some circumstances and not others - would it make sense to change the cleanup
function to take the pointer to the caller data rather than to take the
subprocess_info struct?

David
