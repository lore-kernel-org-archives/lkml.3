Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3J2J4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:56:10 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39604 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3J2J4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:56:08 -0400
Message-ID: <526F862E.9060203@linux.vnet.ibm.com>
Date: Tue, 29 Oct 2013 15:25:58 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>
CC: David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com> <526E24EA.2040701@iki.fi> <526E9808.4030607@gmail.com> <526EB0C3.2080304@iki.fi>
In-Reply-To: <526EB0C3.2080304@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102909-5564-0000-0000-00000A698AC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:15 AM, Pekka Enberg wrote:
[...]
> If you build a cache of DSOs and executables that have SDT makers (with a
> SHA1 hash), the cache size bound by SDT marker annotated files. You
> probably can then unconditionally scan the cached filenames for SDT
> markers for 'perf list'. And once you see a SHA1 mismatch, you either
> rescan automatically or explain to the user that:
>
>   SDT marker cache needs to be updated. Please run 'perf list --scan'.
>
> Transparently supporting SDT markers as events for 'perf trace -e' and
> others is slightly more tricky because you probably don't want to scan
> the files for every 'perf trace' invocation.  However, you can probably
> get really far with a 1024-entry SDT marker cache that's separate from
> the 'executables and DSOs with SDT markers' cache. So whenever the user
> does something like
>
>   perf trace -e libc:setjmp sleep 1
>
> The 'libc:setjmp' ends up in the 1024-entry cache (or whatever makes
> most sense) that points directly to SDT marker so we can hook into it
> quickly.  Using simple LRU eviction policy, you end up pushing out the
> uninteresting SDT markers and keeping the ones that are used all the
> time.


So, what I understand is that we need to implement it this way (Please do
correct me if I am wrong !!) :

Upon invoking "perf list" / "perf list --sdt" for the first time by the 
user, the
executables and dsos (in PATH and /usr/lib*) should be searched for SDT
markers. All these markers along with their one-to-one mapping with the
files can be stored in a "cache" where each entry can be like -
[ sdt_marker : provider : FQN : buildid : location ],
where, "sdt_marker" and "provider" shall be the marker name and provider
names present in the SDT notes' description, FQN shall be the absolute path
of the binary and "location" will be the location of the SDT marker 
inside the binary.

Subsequent invocations of "perf list" / "perf list --sdt" shall read 
this cache and
display the info. If we need to update the list we can use 'perf list 
--scan".

So, now if we use "perf record -e prov:mark -aR sleep 10", it should go
through the list and find out the matched markers and if they have multiple
matches, we probe markers in all of the matched entries. Whenever a match
is found, the FQN can be used to find the binary, match the buildid (we need
to confirm that the binary didn't change since last "perf list" / "perf 
list --scan")
and then confirm the presence of marker and the location. And then go on
with the probing and recording.

There shouldn't be any "perf probe " in between.
That surely makes the task of a user a lot easier!

However, there are some issues which are likely to come up while 
implementing in
the above way:
1. Where this cache should be? Keeping it in tracing directory inside 
the debugfs
directory should seem more feasible. And, shall this cache be shareable?
2. perf record is a performance intensive process, can we allow the 
delay due to
this searching process here?
etc.

-- 
Thanks
Hemant Kumar

