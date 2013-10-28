Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3J1Sp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:45:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37900 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323Ab3J1Sp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:45:26 -0400
X-Sasl-enc: +xy6vezV1EwMaNicNE1Cxq0/n6lcshOUAIzYBV4x2YZN 1382985925
Message-ID: <526EB0C3.2080304@iki.fi>
Date: Mon, 28 Oct 2013 20:45:23 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com> <526E24EA.2040701@iki.fi> <526E9808.4030607@gmail.com>
In-Reply-To: <526E9808.4030607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 6:59 PM, David Ahern wrote:
 > I often use perf-list to lookup an exact event name, and I do not want
 > to see it taking many seconds to minutes to run (not everyone is
 > running on an SSD). I also run perf on many different OS versions with
 > an NFS home directory, and do not want to see a cache explosion (I
 > have buildid disabled for this reason).

I am talking about reasonable defaults - the 'default' part implies that
people can change the behavior.  So we absolutely should also have
something like this for power users such as yourself:

   perf config sdt.scan false

That said, the 'reasonable' part suggests that 'perf list' must not take
seconds or minutes (!) for every run.  I'd start with implementing a
naive scan and seeing where it takes us.  It's not like it's rocket
science to ignore network mounts or revert to a whitelist of paths if
necessary.

As for cache explosion, I don't see what the problem is.

If you build a cache of DSOs and executables that have SDT makers (with a
SHA1 hash), the cache size bound by SDT marker annotated files.  You
probably can then unconditionally scan the cached filenames for SDT
markers for 'perf list'. And once you see a SHA1 mismatch, you either
rescan automatically or explain to the user that:

   SDT marker cache needs to be updated. Please run 'perf list --scan'.

Transparently supporting SDT markers as events for 'perf trace -e' and
others is slightly more tricky because you probably don't want to scan
the files for every 'perf trace' invocation.  However, you can probably
get really far with a 1024-entry SDT marker cache that's separate from
the 'executables and DSOs with SDT markers' cache. So whenever the user
does something like

   perf trace -e libc:setjmp sleep 1

The 'libc:setjmp' ends up in the 1024-entry cache (or whatever makes
most sense) that points directly to SDT marker so we can hook into it
quickly.  Using simple LRU eviction policy, you end up pushing out the
uninteresting SDT markers and keeping the ones that are used all the
time.

                         Pekka

