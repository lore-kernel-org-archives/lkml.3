Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3ICNXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:23:25 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60950 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3ICNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:23:24 -0400
Message-ID: <5225E2C5.3080001@linux.vnet.ibm.com>
Date: Tue, 03 Sep 2013 18:53:17 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com>
In-Reply-To: <5225A937.2050507@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090313-5564-0000-0000-0000098B0A70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 02:47 PM, Masami Hiramatsu wrote:
> (2013/09/03 17:25), Ingo Molnar wrote:
>> * Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> wrote:
>>
>>> This series adds support to perf to list and probe into the SDT markers.
>>> The first patch implements listing of all the SDT markers present in
>>> the ELFs (executables or libraries). The SDT markers are present in the
>>> .note.stapsdt section of the elf. That section can be traversed to list
>>> all the markers. Recognition of markers follows the SystemTap approach.
>>>
>>> The second patch will allow perf to probe into these markers. This is
>>> done by writing the marker name and its offset into the
>>> uprobe_events file in the tracing directory.
>>> Then, perf tools can be used to analyze perf.data file.
>> Please provide a better high level description that explains the history
>> and scope of SDT markers, how SDT markers get into binaries, how they can
>> be used for probing, a real-life usage example that shows something
>> interesting not possible via other ways, etc.
> Indeed, and also I'd like to know what versions of SDT this support,
> and where we can see the technical document of that. As far as I know,
> the previous(?) SDT implementation also involves ugly semaphores.
> Have that already gone?
>
> Thank you,
>
>

Here is an overview and a high-level-description:
Goal:
Probe dtrace style markers(SDT) present in user space applications.

Scope:
Put probe points at SDT markers in user space and also probe them using 
perf.

Why supprt SDT markers? :
We have lots of applications which use SDT markers today like:
Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib

These markers are placed at important places by the developers. Now, 
these markers
have a negligible overhead when not enabled. We can enable them and probe at
these places and find some important information like the arguments' 
values, etc.

How to add SDT markers into user applications:
We need to have this header sys/sdt.h present.
sys/sdt.h used is version 3.
If not present, install systemtap-sdt-devel package.

I will show this through a simple example.
- Create a file with .d extension and mention the probe names in it with
provider name and marker name.

$ cat probes.d
provider user_app {
          probe foo_start();
          probe fun_start();
};

- Now create the probes.h and probes.o file :
$ dtrace -C -h -s probes.d -o probes.h
$ dtrace -C -G -s probes.d -o probes.o

- A program using the markers:

$ cat user_app.c

#include <stdio.h>
#include "probes.h"

void foo(void)
{
         USER_APP_FOO_START();
         printf("This is foo\n");
}

void fun(void)
{
         USER_APP_FUN_START();
         printf("Inside fun\n");
}
int main(void)
{
         printf("In main\n");
         foo();
         fun();
         return 0;
}

- Compile it and also provide probes.o file to linker:
$ gcc user_app.c probes.o -o user_app

- Now use perf to list the markers in the app:
# perf probe --list -S -x ./user_app

user_app:foo_start
user_app:fun_start

Total markers = 2

- And  then use perf probe to add a probe point :

# perf probe -S -x ./user_app foo_start

Added new event :
event = foo_start      (on 0x530)

You can now use it on all perf tools such as :

      perf record -e probe_user:foo_start -aR sleep 1

# perf record -e probe_user:foo_start -aR ./user_app
In main
This is foo
Inside fun
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.235 MB perf.data (~10279 samples) ]

- Then use perf tools to analyze it.
# perf report --stdio

# ========
# captured on: Tue Sep  3 16:19:55 2013
# hostname : hemant-fedora
# os release : 3.11.0-rc3+
# perf version : 3.9.4-200.fc18.x86_64
# arch : x86_64
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : QEMU Virtual CPU version 1.2.2
# cpuid : GenuineIntel,6,2,3
# total memory : 2051912 kBIf these are not enabled, they are present in 
the ELF as nop.

# cmdline : /usr/bin/perf record -e probe_user:foo_start -aR ./user_app
# event : name = probe_user:foo_start, type = 2, config = 0x38e, config1
= 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: software = 1, tracepoint = 2, breakpoint = 5
# ========
#
# Samples: 1  of event 'probe_user:foo_start'
# Event count (approx.): 1
#
# Overhead   Command  Shared Object   Symbol
# ........  ........  .............  .......
#
    100.00%  user_app  user_app       [.] foo


#
# (For a higher level overview, try: perf report --sort comm,dso)
#


We can see the markers in libvirt (if it is compiled with --with-dtrace 
option) :
# perf probe -l -S -x /lib64/libvirt.so.0.10.2

libvirt:event_poll_purge_timeout
libvirt:event_poll_purge_handle
libvirt:event_poll_remove_handle
libvirt:event_poll_add_timeout
libvirt:event_poll_update_timeout
libvirt:event_poll_remove_timeout
libvirt:event_poll_update_handle
libvirt:event_poll_add_handle
libvirt:event_poll_run
libvirt:event_poll_dispatch_timeout
libvirt:event_poll_dispatch_handle
libvirt:object_new
libvirt:object_unref
libvirt:object_dispose
libvirt:object_ref
libvirt:rpc_client_msg_tx_queue
libvirt:rpc_client_msg_rx
libvirt:rpc_client_dispose
libvirt:rpc_client_new
libvirt:rpc_client_msg_tx_queue
libvirt:rpc_server_client_new
libvirt:rpc_server_client_dispose
libvirt:rpc_server_client_msg_tx_queue
libvirt:rpc_server_client_msg_rx
libvirt:rpc_keepalive_dispose
libvirt:rpc_keepalive_send
libvirt:rpc_keepalive_timeout
libvirt:rpc_keepalive_new
libvirt:rpc_keepalive_start
libvirt:rpc_keepalive_stop
libvirt:rpc_keepalive_received
libvirt:rpc_socket_new
libvirt:rpc_socket_dispose
libvirt:rpc_socket_send_fd
libvirt:rpc_socket_recv_fd

- And then use perf to probe into any marker:

# perf probe -S -x /lib64/libvirt.so.0.10.2 rpc_client_msg_tx_queue

Added new event :
event = rpc_client_msg_tx_queue      (on 0x1462d9)

You can now use it on all perf tools such as :

      perf record -e probe_libvirt:rpc_client_msg_tx_queue -aR sleep 1

This link shows an example of marker probing with Systemtap:
https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps

- Markers in binaries :
These SDT markers are present in the ELF in the section named
".note.stapsdt".
Here, the name of the marker, its provider, type, location, base
address, semaphore address, arguments are present.
We can retrieve these values using the members name_off and desc_off in
Nhdr structure. If these are not enabled, they are present in the ELF as 
nop.

Thanks
Hemant Kumar Shaw

