Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3GKQm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:42:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3GKQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:42:26 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=s37gdL-KhCUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P1PPt9p6O00A:10 a=K5Sxo7UcNOoPadickKMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373560944.17876.41.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 0/2] x86: make jump labels use int3-based
 breakpoint instead of stop_machine()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jason Baron <jbaron@akamai.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mathieu.desnoyers@efficios.com
Date: Thu, 11 Jul 2013 12:42:24 -0400
In-Reply-To: <alpine.LNX.2.00.1307110159490.25858@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <51DDDFB3.3020004@akamai.com>
	 <alpine.LNX.2.00.1307110159490.25858@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 02:04 +0200, Jiri Kosina wrote:

> I even have preliminary (completely untested) patch, but would like to 
> have this merged/acked in the first round before proceeding with porting 
> ftrace to the new interface.
> 
> > Also, I wonder if its worth batching up updates. For example, right now 
> > we simply update each call-site one at a time even if its associated 
> > with the same control variable.
> 
> That does seem to make sense indeed, but it's not really closely tied to 
> this patchset, is it?

If you want to have ftrace use this interface, then we need to support
batch processing. And you will need to do it with an iterator as well.
We can not allocate 30,000 locations to run this on. Ftrace has its own
table, and uses the ftrace iterator to traverse it.

Thus you would need to do something like:

int text_poke_iterator(struct text_poke_iter *iterator)
{
	struct text_poke_iter_instance *iter;

	for (iter = text_poke_iterator_start(iterator);
	     iter;
	     iter = text_poke_iterator_next(iterator)) {
		ret = add_breakpoints(iter->addr, iter->old);
		if (!ret)
			goto failed;
	}

	on_each_cpu(do_sync_core, NULL, 1);
	/* and this doesn't even handle the issue with ftrace
	  start up code */

	for (iter = text_poke_iterator_start(iterator);
	     iter;
	     iter = text_poke_iterator_next(iterator)) {
		ret = add_update(iter->addr, iter->old, iter->new);
		if (!ret)
			goto failed;
	}

	on_each_cpu(do_sync_core, NULL, 1);

	for (iter = text_poke_iterator_start(iterator);
	     iter;
	     iter = text_poke_iterator_next(iterator)) {
		ret = remove_breakpoints(iter->addr, iter->new);
		if (!ret)
			goto failed;
	}

	on_each_cpu(do_sync_core, NULL, 1);

	return 0;
failed:
	for (iter = text_poke_iterator_start(iterator);
	     iter;
	     iter = text_poke_iterator_next(iterator)) {
		ret = remove_breakpoints_fail(iter->addr, iter->old, iter->new);
	}
}

-- Steve


