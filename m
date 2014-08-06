Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaHFKFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:05:47 -0400
Received: from mta-out1.inet.fi ([62.71.2.231]:58904 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHFKFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:05:45 -0400
Date: Wed, 6 Aug 2014 13:05:06 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] fs/proc/task_mmu.c: shift mm_access() from
 m_start() to proc_maps_open()
Message-ID: <20140806100506.GD30508@node.dhcp.inet.fi>
References: <20140805194627.GA30693@redhat.com>
 <20140805194655.GA30728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194655.GA30728@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:46:55PM +0200, Oleg Nesterov wrote:
> A simple test-case from Kirill Shutemov
> 
> 	cat /proc/self/maps >/dev/null
> 	chmod +x /proc/self/net/packet
> 	exec /proc/self/net/packet
> 
> makes lockdep unhappy, cat/exec take seq_file->lock + cred_guard_mutex in
> the opposite order.
> 
> It's a false positive and probably we should not allow "chmod +x" on proc
> files. Still I think that we should avoid mm_access() and cred_guard_mutex
> in sys_read() paths, security checking should happen at open time. Besides,
> this doesn't even look right if the task changes its ->mm between m_stop()
> and m_start().
> 
> Add the new "mm_struct *mm" member into struct proc_maps_private and change
> proc_maps_open() to initialize it using proc_mem_open(). Change m_start() to
> use priv->mm if atomic_inc_not_zero(mm_users) succeeds or return NULL (eof)
> otherwise.
> 
> The only complication is that proc_maps_open() users should additionally do
> mmdrop() in fop->release(), add the new proc_map_release() helper for that.
> 
> Note: this is the user-visible change, if the task execs after open("maps")
> the new ->mm won't be visible via this file. I hope this is fine, and this
> matches /proc/pid/mem bahaviour.
> 
> Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
-- 
 Kirill A. Shutemov
