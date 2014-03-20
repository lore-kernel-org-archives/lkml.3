Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbaCTOpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbaCTOps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:45:48 -0400
Message-ID: <532AC1EA.3050509@draigBrady.com>
Date: Thu, 20 Mar 2014 10:24:42 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Janani Venkataraman <jananive@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, amwang@redhat.com, procps@freelists.org,
        rdunlap@xenotime.net, james.hogan@imgtec.com,
        aravinda@linux.vnet.ibm.com, hch@lst.de,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 00/33] [RFC] Non disruptive application core dump infrastructure
References: <20140320093040.14878.903.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:39 AM, Janani Venkataraman wrote:
> Hi all,
> 
> The following series implements an infrastructure for capturing the core of an
> application without disrupting its process.
> 
> Kernel Space Approach:
> 
> 1) Posted an RFD to LKML explaining the various kernel-methods being analysed.
> 
> https://lkml.org/lkml/2013/9/3/122
> 
> 2) Went ahead to implement the same using the task_work_add approach and posted an
> RFC to LKML.
> 
> http://lwn.net/Articles/569534/
> 
> Based on the responses, the present approach implements the same in User-Space.
> 
> User Space Approach:
> 
> We didn't adopt the CRIU approach because our method would give us a head
> start, as all that the distro would need is the PTRACE_functionality and nothing
> more which is available from kernel versions 3.4 and above.
> 
> Basic Idea of User Space:
> 
> 1) The threads are held using PTRACE_SEIZE and PTRACE_INTERRUPT.
> 
> 2) The dump is then taken using the following:
>     1) The register sets namely general purpose, floating point and the arch
>     specific register sets are collected through PTRACE_GETREGSET calls by
>     passing the appropriate register type as parameter.
>     2) The virtual memory maps are collected from /proc/pid/maps.
>     3) The auxiliary vector is collected from /proc/pid/auxv.
>     4) Process state information for filling the notes such as PRSTATUS and
>     PRPSINFO are collected from /proc/pid/stat and /proc/pid/status.
>     5) The actual memory is read through process_vm_readv syscall as suggested
>     by Andi Kleen.
>     6) Command line arguments are collected from /proc/pid/cmdline
> 
> 3) The threads are then released using PTRACE_DETACH.
> 
> Self Dump:
> 
> A self dump is implemented with the following approach which was adapted
> from CRIU:
> 
> Gencore Daemon
> 
> The programs can request a dump using gencore() API, provided through
> libgencore. This is implemented through a daemon which listens on a UNIX File
> socket. The daemon is started immediately post installation.
> 
> We have provided service scripts for integration with systemd.
> 
> NOTE:
> 
> On systems with systemd, we could make use of socket option, which will avoid
> the need for running the gencore daemon always. The systemd can wait on the
> socket for requests and trigger the daemon as and when required. However, since
> the systemd socket APIs are not exported yet, we have disabled the supporting
> code for this feature.
> 
> libgencore:
> 
> 1) The client interface is a standard library call. All that the dump requester
> does is open the library and call the gencore() API and the dump will be
> generated in the path specified(relative/absolute).
> 
> To Do:
> 
> 1) Presently we wait indefinitely for the all the threads to seize. We can add
> a time-out to decide how much time we need to wait for the threads to be
> seized. This can be passed as command line argument in the case of a third
> party dump and in the case of the self-dump through the library call. We need
> to work on how much time to wait.
> 
> 2) Like mentioned before, the systemd socket APIs are not exported yet and
> hence this option is disabled now. Once these API's are available we can enable
> the socket option.
> 
> We would like to push this to one of the following packages:
> a) util-linux
> b) coreutils
> c) procps-ng
> 
> We are not sure which one would suit this application the best.
> Please let us know your views on the same.

Well from coreutils persepective, they're generally
non Linux specific _commands_, and so wouldn't be
a natural home for this (despite the _core_ in the name :)).

thanks,
Pádraig.
