Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3KLKoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:44:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab3KLKoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:44:34 -0500
Subject: Re: [PATCH v2 1/8] x86: speed up int3-based patching using less
 paranoid write
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <20131108074336.29dfbc15@gandalf.local.home>
References: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
	 <1383901932-1945-3-git-send-email-pmladek@suse.cz>
	 <527CD34A.30406@hitachi.com>  <20131108074336.29dfbc15@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Nov 2013 11:44:32 +0100
Message-ID: <1384253072.1296.21.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt píše v Pá 08. 11. 2013 v 07:43 -0500:
> On Fri, 08 Nov 2013 21:04:26 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > (2013/11/08 18:12), Petr Mladek wrote:
> > > This change is inspired by the int3-based patching code used in
> > > ftrace. See the commit fd4363fff3d9 (x86: Introduce int3
> > > (breakpoint)-based instruction patching).
> > > 
> > > When trying to use text_poke_bp in ftrace, the result was slower than
> > > the original implementation.
> > > 
> > > It turned out that one difference was in text_poke vs. ftrace_write.
> > > text_poke did many extra operations to make sure that the change
> > > was atomic.
> > 
> > AFAIK, the main reason why text_poke is used is avoiding
> > RODATA protection (by alias mapping).
> 
> That is correct, and the reason ftrace didn't do that is because it
> would be quite expensive to map 22,000 addresses for each change.

I see. I am going to prepare v3 with the following changes:

	+ use text_poke in text_poke_bp back again because it is not
          effective to make the pages rw only for a single address;
          the alias mapping is faster here

	+ use the faster text_poke_part only in text_poke_bp_iter;
          the caller of this function will be responsible for
          making the code rw

	+ I will rework the error handling as suggested in the other
          mails; I will try to add some also for text_poke.

Thanks a lot for hints.

Best Regards,
Petr

