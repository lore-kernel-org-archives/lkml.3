Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbaGCV64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:58:56 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37522 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaGCV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <21429.45664.255694.85431@quad.stoffel.home>
References: <1404392547-11648-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<CA+55aFxOTqUAqEF7+83s890Q18qCHSQqDOxWqWHNjG_25hVhXg@mail.gmail.com>
	<53B59CB5.9060004@linux.vnet.ibm.com>
	<CA+55aFyRgYW6Y8paYKGfqE205enhiPsZ1C8wrKpFavVXq7ZAtA@mail.gmail.com>
	<CA+55aFwwSCrH5QDvrzzyHhRU5R849Mo8A3NdRMwm9OTeWH9diQ@mail.gmail.com>
	<21429.45664.255694.85431@quad.stoffel.home>
Date: Thu, 3 Jul 2014 14:58:54 -0700
X-Google-Sender-Auth: opYK36emBXMJBC8I6WVvCRoYlTE
Message-ID: <CA+55aFwhpaTPm+mok0VmypU2T2yvYX=E4hnQwPC4NVdxEzfh0Q@mail.gmail.com>
Subject: Re: [PATCH] mm readahead: Fix sys_readahead breakage by reverting 2MB
 limit (bug 79111)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stoffel <john@stoffel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 12:43 PM, John Stoffel <john@stoffel.org> wrote:
>
> This is one of those perenial questions of how to tune this.  I agree
> we should increase the number, but shouldn't it be based on both the
> amount of memory in the machine, number of devices (or is it all just
> one big pool?) and the speed of the actual device doing readahead?

Sure. But I don't trust the throughput data for the backing device at
all, especially early at boot. We're supposed to work it out for
writeback over time (based on device contention etc), but I never saw
that working, and for reading I don't think we have even any code to
do so.

And trying to be clever and basing the read-ahead size on the node
memory size was what caused problems to begin with (with memory-less
nodes) that then made us just hardcode the maximum.

So there are certainly better options - in theory. In practice, I
think we don't really care enough, and the better options are
questionably implementable.

I _suspect_ the right number is in that 2-8MB range, and I would
prefer to keep it at the low end at least until somebody really has
numbers (and preferably from different real-life situations).

I also suspect that read-ahead is less of an issue with non-rotational
storage in general, since the only real reason for it tends to be
latency reduction (particularly the "readahead()" kind of big-hammer
thing that is really just useful for priming caches). So there's some
argument to say that it's getting less and less important.

            Linus
