Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaKSKoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:44:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaKSKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:44:52 -0500
Date: Wed, 19 Nov 2014 11:44:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
In-Reply-To: <20141119104114.GA5684@pd.tnic>
Message-ID: <alpine.LNX.2.00.1411191143520.4454@pobox.suse.cz>
References: <20141119043917.578498291@goodmis.org> <20141119045556.084787418@goodmis.org> <20141119104114.GA5684@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Borislav Petkov wrote:

> I'm wondering if this could be used in a generic manner throughout code 
> where we could say "ok, I'm in an NMI context, so lemme switch printk's 
> and do some printing" so that NMI and NMI-like atomic contexts could use 
> printk. Lemme do an mce example:
> 
> do_machine_check(..)
> {
> 	printk_func_t printk_func_save = this_cpu_read(printk_func);
> 
> 	...
> 
> 	/* in #MC handler, switch printks */
> 	this_cpu_write(printk_func, nmi_vprintk);
> 
> 	printk("This is a hw error, details: ...\n");
> 
> 	/* more bla */
> 
> 	this_cpu_write(printk_func, printk_func_save);
> }
> 
> or should we change that in entry.S, before we call the handler?

If we are going down this path, do_nmi() should be early enough to do it, 
no need to pollute NMI assembly code with this.

-- 
Jiri Kosina
SUSE Labs
