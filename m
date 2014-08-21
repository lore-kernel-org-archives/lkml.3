Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaHUQXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaHUQXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:23:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140820150619.GA12706@redhat.com>
References: <20140820150619.GA12706@redhat.com> <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3199.1408638173.1@warthog.procyon.org.uk>
Date: Thu, 21 Aug 2014 17:22:53 +0100
Message-ID: <3200.1408638173@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> David, any other reason why ->real_cred can be NULL ? (assuming that I
> interpret this asm correctly).

It should only be possible to see ->real_cred as being NULL after exit_creds()
has been called from __put_task_struct() for a task that has finished
construction.

It shouldn't be possible to introduce a NULL pointer through commit_creds() or
override_creds() since both of those should crash immediately if given one,
but it's possible revert_creds() could be so used.

Is there a race between kill() and exit() brought on by the kill path only
using the RCU read lock?  This doesn't prevent ->real_cred from being
modified, but it looks like this should, in combination with
delayed_put_task_struct(), prevent it from being cleared.

David
