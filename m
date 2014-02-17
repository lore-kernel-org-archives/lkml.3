Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaBQW5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:57:25 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:54479 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBQW5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:57:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140214074305.GF5160@quack.suse.cz>
References: <52F88C16.70204@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
	<52F8C556.6090006@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
	<52FC6F2A.30905@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
	<52FC98A6.1000701@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
	<20140214001438.GB1651@linux.vnet.ibm.com>
	<CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
	<20140214074305.GF5160@quack.suse.cz>
Date: Mon, 17 Feb 2014 14:57:23 -0800
X-Google-Sender-Auth: MvKY-qQIFJJHsnDHuUkV2xvRYU8
Message-ID: <CA+55aFxeCM_GTzVBQMbk0eKY7+eeA1ngF6RFZ0O=PbuNs_FMxg@mail.gmail.com>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:43 PM, Jan Kara <jack@suse.cz> wrote:
>
>   max_sane_readahead() is also used for limiting amount of readahead for
> [fm]advice(2) WILLNEED and that is used e.g. by a dynamic linker to preload
> shared libraries into memory. So I'm convinced this usecase *will* notice
> the change - effectively we limit preloading of shared libraries to the
> first 512KB in the file but libraries get accessed in a rather random manner.
>
> Maybe limits for WILLNEED and for standard readahead should be different.
> It makes sence to me and people seem to keep forgetting that
> max_sane_readahead() limits also WILLNEED preloading.

Good point. But it's probably overly complex to have two different
limits. The "512kB" thing was entirely random - the only real issue is
that it should be small enough that it won't be a problem on any
reasonable current machines, and big enough to get perfectly fine IO
patterns unless your IO subsystem sucks so bad that it's not even
worth worrying about.

If we just add a third requirement that it be "big enough that
reasonable uses of [fm]advice() will work well enough", then your
shared library example might well be grounds for saying "let's just do
2MB instead". That's still small enough that it won't really hurt any
modern machines.

And if it means that WILLNEED won't necessarily always read the whole
file for big files - well, we never guaranteed that to begin with.

                                Linus
