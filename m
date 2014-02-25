Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBYLo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:44:58 -0500
Received: from [133.145.228.42] ([133.145.228.42]:50282 "EHLO
	mail7.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:44:56 -0500
Message-ID: <530C821D.7000704@hitachi.com>
Date: Tue, 25 Feb 2014 20:44:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [RFC PATCH v1 0/2] perf: Support for SDT markers
References: <20140224090833.7998.5416.stgit@hemant-fedora>
In-Reply-To: <20140224090833.7998.5416.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/24 18:14), Hemant Kumar wrote:
> This patchset helps in listing dtrace style markers(SDT) present in user space
> applications through perf.
> Notes/markers are placed at important places by the
> developers. They have a negligible overhead when not enabled.
> We can enable them and probe at these places and find some important information
> like the arguments' values, etc.
> 
> We have lots of applications which use SDT markers today, like:
> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
> 
> To add SDT markers into user applications:
> We need to have this header sys/sdt.h present.
> sys/sdt.h used is version 3.
> If not present, install systemtap-sdt-devel package (for fedora-18).
> 
> Please refer to the Documentation patch to see how the SDT markers are added into
> a program.
> 
> With this patchset,
> - Use perf to list the markers in the app:
> # perf list sdt ./user_app
> 
> ./user_app :
> %user_app:foo_start
> %user_app:fun_start
> 
> - Also, we can see the SDT markers present in our system in the usual binaries.
> These usual binaries are libraries (dsos) listed by ldconfig --print-cache and some
> binaries present in PATH environment variable.
> 
> First, scan the binaries using :
> # perf list sdt --scan
> 
> Creating a cache of SDT markers...
> perf sdt cache created!
>  Use : "perf list sdt"
>  to see the SDT markers

Hmm, in that case, I think you'd better introduce perf-sdt for scanning.
e.g.

 # perf sdt --scan app

 then you can add app to sdt cache, without app,

 # perf sdt --scan

 will just scans all binaries on the PATH and the libraries which listed
by `ldconfig --print-caceh`

And perf-list shows only the SDTs in the cache.

If there is no SDTs in the cache, `perf-list sdt` will warn you to
run the `perf sdt --scan`.


> 
> After the sdt cache file is created, use perf list to view the markers :
> # perf list sdt
> 
> %rtld : init_start
> %rtld : init_complete
> %rtld : map_failed
> %rtld : map_start
> %rtld : lll_futex_wake
> ...
> ...
> %libgcc : unwind
> %libvirt : rpc_server_client_auth_allow
> %libvirt : rpc_server_client_auth_fail
> %libvirt : rpc_server_client_auth_deny
> 
> Alternatively, one can view the /var/cache/perf/perf-sdt.cache directly.
> 
> This link shows an example of marker probing with Systemtap:
> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
> 
> Also, this link provides important info regarding SDT notes:
> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
> 
> - Markers in binaries :
> These SDT markers are present in the ELF in the section named
> ".note.stapsdt".
> Here, the name of the marker, its provider, type, location, base
> address, semaphore address.
> We can retrieve these values using the members name_off and desc_off in
> Nhdr structure. If these are not enabled, they are present in the ELF as nop.
> 
> Changes since last series :
> - Made the SDT markers present in a system more visible through perf list 
>   as suggested by Pekka Enberg.
> - Less complex command line interface to access the SDT markers.
> - Added a cache file to store most of the SDT markers of a system.
> 
> TODO:
> - Add support to probe these SDT markers and integrate with a previous patch
>   (support to perf to probe SDT markers) posted in lkml.
>   https://lkml.org/lkml/2013/10/23/10

Yeah, but I think we'd better choose another way to integrate it.
Since SDT is like markers(static events), setting each of them via perf-probe is
not intuitive. :)  I'd like to use it as an event, e.g.

 # perf top -e "%libgcc:unwind"

And perf top internally calls perf-probe to add new uprobe event, and
clean the new event at exit.


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


