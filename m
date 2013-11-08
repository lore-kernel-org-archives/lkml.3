Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3KHOt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:49:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31764 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751254Ab3KHOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:49:55 -0500
Date: Fri, 8 Nov 2013 09:49:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v2 1/8] x86: speed up int3-based patching using less
 paranoid write
Message-ID: <20131108094951.5b26ea65@gandalf.local.home>
In-Reply-To: <527CD34A.30406@hitachi.com>
References: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
	<1383901932-1945-3-git-send-email-pmladek@suse.cz>
	<527CD34A.30406@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Nov 2013 21:04:26 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> >  static void do_sync_core(void *info)
> >  {
> >  	sync_core();
> > @@ -648,15 +687,15 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> >  	 */
> >  	smp_wmb();
> >  
> > -	text_poke(addr, &int3, sizeof(int3));
> > +	text_poke_part(addr, &int3, sizeof(int3));
> 
> Anyway, text_poke itself will cause a BUG if it hits an error, but text_poke_part() seems
> silently failing. It should handle the error correctly (or call BUG()).
> 

text_poke_part() shouldn't do a bug on error, but this code probably
should.

	if (text_poke_part(addr, &int3, sizeof(int3)))
		BUG();

Note, I would avoid doing:

	BUG_ON(text_poke_part(...));

as we don't want "side effects" in the BUG() macros. You may do:

	ret = text_poke_part(...);
	BUG_ON(ret);

Which has the added benefit of the implicit "unlikely" in the BUG_ON()
macro.

Or we can have do_sync_core() be able to handle errors and have their
callers handle them too.

-- Steve
