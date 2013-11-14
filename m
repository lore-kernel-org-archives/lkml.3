Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3KNMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:46:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab3KNMql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:46:41 -0500
Subject: Re: [PATCH v3 4/8] x86: speed up int3-based patching using direct
 write
From: Petr Mladek <pmladek@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <5284B5D2.70206@hitachi.com>
References: <1384425686-21018-1-git-send-email-pmladek@suse.cz>
	 <1384425686-21018-5-git-send-email-pmladek@suse.cz>
	 <5284B5D2.70206@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Nov 2013 13:46:39 +0100
Message-ID: <1384433199.17374.19.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu píše v Čt 14. 11. 2013 v 20:36 +0900:
> (2013/11/14 19:41), Petr Mladek wrote:
> > @@ -837,7 +882,7 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
> >  	}
> >  
> >  	/* Finally, put back the first byte from the old code */
> > -	err = text_poke(addr, old_opcode, sizeof(bp_int3));
> > +	err = text_poke_part(addr, old_opcode, sizeof(bp_int3));
> >  	/* we can not continue if the interrupt is still there */
> >  	BUG_ON(err);
> >  }
> > @@ -865,7 +910,9 @@ static void recover_iter(struct text_poke_bp_iter *iterator,
> >   * It is a bit more paranoid than text_poke_bp because it checks the actual
> >   * code before patching. This is a good practice proposed by the ftrace code.
> >   *
> > - * Note: This function must be called under text_mutex.
> > + * Note: This function must be called under text_mutex. Also the caller is
> > + * responsible for making the patched code read-write, for example using
> > + * set_kernel_text_rw() and set_all_modules_text_rw()
> 
> OK, I got the reason why we can do it.
> But if so, we should change all existing caller of text_poke_bp() to
> call it in this patch, or they must fail at this point.

Ah, I used "text_poke_part" only in "text_poke_bp_iter" in the end. This
function is currently used only in ftrace that sets the code read-write
in "ftrace_arch_code_modify_prepare", see arch/x86/kernel/ftrace.c.

Note that "text_poke_bp" still uses "text_poke". It seems that the
remapping is faster if you patch only one address.

So, we should be on the safe side.

Thanks a lot for review.

Best Regards,
Petr

