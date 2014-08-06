Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaHFTny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbaHFTnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:43:52 -0400
Date: Wed, 6 Aug 2014 21:41:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
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
Subject: Re: [PATCH v2 1/7] fs/proc/task_mmu.c: don't use task->mm in
	m_start() and show_*map()
Message-ID: <20140806194129.GA943@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140805194644.GA30711@redhat.com> <20140806095214.GA30508@node.dhcp.inet.fi> <20140806141005.GA1487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806141005.GA1487@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Oleg Nesterov wrote:
>
> On 08/06, Kirill A. Shutemov wrote:
> >
> > On Tue, Aug 05, 2014 at 09:46:44PM +0200, Oleg Nesterov wrote:
> > >
> > >  	if (m->count < m->size)  /* vma is copied successfully */
> > > -		m->version = (vma != get_gate_vma(task->mm))
> > > +		m->version = (vma != priv->tail_vma)
> > >  			? vma->vm_start : 0;
> >
> > Drop excessive parenthesis while you're there? And in the next hunk.
>
> I agree. But lets do this in another patch? I forgot to mention this in
> the yesterday's TODO, but we should factor out this code. Perhaps move
> this into vma_stop(). Or at least add a trivial helper, this pattern
> repeats 3 times, plus another one in m_start(). This problem is that I
> do not really understand this logic right now, but I'll do something
> today in any case.

Damn, this needs even more cleanups than I thought. Even "version == -1"
logic is absolutely wrong/dead. And "last_addr rather than next_addr" is
wrong too afaics, this just means we need the extra ->vm_next step plus
vma-or-tail_vma recheck.

Hopefully I'll finish this tomorrow.

Oleg.

