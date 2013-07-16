Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3GPCj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab3GPCjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:39:24 -0400
Date: Mon, 15 Jul 2013 22:38:48 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716023847.GA31481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 07:32:51PM -0700, Linus Torvalds wrote:

 > So the problematic op *seems* to be the splice into /proc/<pid>/attr/
 > files, which causes that "pipe -> cred_guard_mutex" locking.
 > 
 > While the *normal* ordering would be the other way around, coming from
 > execve(), which has the cred_guard_mutex -> VFS locks ordering for
 > reading the executable headers.
 > 
 > Al, can we break either of those? Do we need to hold on to the cred
 > mutex that long? We get it fairly early (prepare_bprm_creds) and we
 > drop it very late (install_exec_creds), which means that it covers a
 > lot. But that seems pretty basic. The splice into /proc/<pid>/attr/*
 > seems to be the more annoying one, and maybe we just shouldn't allow
 > splicing into or from /proc?
 > 
 > Dave, is this new (it doesn't *smell* new to me), or is it just that
 > trinity is doing new splice things?
 
I think I've seen this a long time ago from another fuzzer (iknowthis).
I thought that had gotten fixed though.  But I may be mixing up a
similar callchain.  The recent trinity changes shouldn't have really made
any notable difference here.  Interestingly, the 'soft lockups' I was
seeing all the time on that box seem to have gone into hiding.

 > Or is the XFS i_iolock required for this thing to happen at all?
 > Adding Ben Myers to the cc just for luck/completeness.

It is only happening (so far) on the XFS test box, but I don't have
enough data to say that's definite yet.
 
	Dave
 
