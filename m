Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3ENWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:15:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50507 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab3ENWPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:15:20 -0400
Date: Tue, 14 May 2013 15:15:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130514221513.GA2882@mtj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514215945.GA2334@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514215945.GA2334@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again, continuing the brain diarrehea,

On Tue, May 14, 2013 at 02:59:45PM -0700, Tejun Heo wrote:
> So, while I do like the simplicity of put() returning %true on the
> final put, I suspect it's more likely to slowing down fast paths due
> to its interface compared to having separate ->release function
> combined with void put().  Any ideas?

Maybe we can structure put in a way that's difficult to get wrong for
the compiler?

	bool put()
	{
		preempt_disable();
		if (likely(not killed yet)) {
			this_cpu_dec();
			preempt_enable();
			return false;
		}
		return put_slowpath();
	}

This doesn't solve the caller not inlining hot path but well I suppose
we can consider that the caller's problem.  The above at least
wouldn't introduce an unnecessary branch on its own.

Thanks.

-- 
tejun
