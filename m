Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824Ab3COE0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:26:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51375 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3COE0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:26:34 -0400
Date: Fri, 15 Mar 2013 04:26:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: lockdep splat with prepare_bprm_creds
Message-ID: <20130315042628.GV21522@ZenIV.linux.org.uk>
References: <51429E72.7090405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51429E72.7090405@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:07:14AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> I've stumbled on the following.
> 
> Dave Jones reported something similar, but that seemed to involve cgroup's mutex
> and didn't seem like it was the same issue as this one.

Lovely...  It's an execve() attempt on a "binary" that is, in fact, a procfs
file (/proc/<pid>/stack), with its ->read() trying to grab ->cred_guard_mutex.
The fact that it's seq_file-based is irrelevant here - all that matters is
that we have ->read() for some file trying to grab ->cred_guard_mutex.

It's not *quite* a deadlock, though - all these guys are using
mutex_lock_killable()...
