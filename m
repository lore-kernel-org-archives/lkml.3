Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaEEXwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:52:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaEEXww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:52:52 -0400
Date: Tue, 6 May 2014 01:52:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Lang <david@lang.hm>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
Message-ID: <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz> <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, David Lang wrote:

> how would you know that all instances of the datastructure in memory 
> have= been touched? just because all tasks have run and are outside the 
> function in question doesn't tell you data structures have been 
> converted. You have n= o way of knowing when (or if) the next call to 
> the modified function will take place on any potential in-memory 
> structure.

The problem you are trying to avoid here is functions expecting to read 
"v2" format of the data from memory, while there are still tasks that are 
unpredictably writing "v1" format of the data to the memory.

There are several ways to attack this problem:

- stop the whole system, convert all the existing data structures to new 
  format (which might potentially be non-trivial, mostly because you 
  have to *know* where all the data structures have been allocated), apply 
  patch, resume operation [ksplice, probably kpatch in future]
- restrict the data format to be backwards compatible [to be done 
  manually during patch creation, currently what kGraft needs to do in 
  such case]
- have a proxy code which can read both "v1" and "v2" formats, and writes 
  back in the same format it has seen the data structure on input
- once all the *code* has been converted, it still has to understand "v1" 
  and "v2", but it can now start writing out "v2" format only [possible 
  with kGraft, not implemented in automated fashion]

Ideas are of course more than welcome.

Thanks,

-- 
Jiri Kosina
SUSE Labs
