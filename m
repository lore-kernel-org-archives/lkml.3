Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaGaLNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:13:47 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37072 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaGaLNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:13:41 -0400
Content-Type: multipart/mixed; boundary="Apple-Mail=_B52FF222-F8D3-4E8E-9365-30917EB69824"
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Soft lockups during reading /proc/PID/smaps
From: Aleksei Besogonov <alex.besogonov@gmail.com>
In-Reply-To: <alpine.DEB.2.02.1407310041500.20816@chino.kir.corp.google.com>
Date: Thu, 31 Jul 2014 04:13:34 -0700
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Message-Id: <117A54C0-F3AC-4DD0-B2F6-886C5D4419E3@gmail.com>
References: <loom.20140731T091947-310@post.gmane.org> <alpine.DEB.2.02.1407310041500.20816@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_B52FF222-F8D3-4E8E-9365-30917EB69824
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On 31 Jul 2014, at 00:43, David Rientjes <rientjes@google.com> wrote:
> On Thu, 31 Jul 2014, Aleksei Besogonov wrote:
>> I'm getting weird soft lockups while reading smaps on loaded systems =
with
>> some background cgroups usage. This issue can be reproduced with the =
most
>> recent kernel.
>>=20
>> Here's the stack trace:
>> [ 1748.312052] BUG: soft lockup - CPU#6 stuck for 23s! =
[python2.7:1857]
>> [ 1748.312052] Modules linked in: xfs xt_addrtype xt_conntrack
>> iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 =
nf_defrag_ipv4
>> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc
>> dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c nfsd
>> auth_rpcgss nfs_acl nfs lockd sunrpc fscache dm_crypt psmouse =
serio_raw
>> ppdev parport_pc i2c_piix4 parport xen_fbfront fb_sys_fops =
syscopyarea
>> sysfillrect sysimgblt mac_hid isofs raid10 raid456 async_memcpy
>> async_raid6_recov async_pq async_xor async_tx xor raid6_pq raid1 =
raid0
>> multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
>> aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd =
floppy
>> [ 1748.312052] CPU: 6 PID: 1857 Comm: python2.7 Not tainted
>> 3.15.5-031505-generic #201407091543
> This isn't the most recent kernel, we're at 3.16-rc7 now, but I don't=20=

> think there are any changes that would prevent this.
Yes, I tested it with the rc7, the error report is from a previous run =
with an Ubuntu 14.04 kernel.

> The while_each_thread() in vm_is_stack() looks suspicious since the =
task=20
> isn't current and rcu won't protect the iteration, and we also don't =
hold=20
> sighand lock or a readlock on tasklist_lock.
> I think Oleg will know how to proceed, cc'd.
I=92m attaching a minimal test case that can reproduce the issue. Works =
in 100% cases on any system I=92ve tried.


--Apple-Mail=_B52FF222-F8D3-4E8E-9365-30917EB69824
Content-Disposition: attachment;
	filename=bug.py
Content-Type: text/x-python-script;
	name="bug.py"
Content-Transfer-Encoding: 7bit

#!/usr/bin/env python2.7
from os import mkdir
from threading import Thread
from time import sleep
import os

__author__ = 'cyberax'

count = 0


def threadproc():
    global count
    count += 1
    sleep(0.01)
    count -= 1


def do_threads():
    sleep(2)
    while True:
        while count > 200:
            sleep(0.01)

        th = Thread(target=threadproc)
        th.start()


def do_reader(pid):
    while True:
        with open("/sys/fs/cgroup/memory/ck/1001/tasks", "r") as fl:
            fl.readlines()
        with open("/sys/fs/cgroup/memory/ck/1001/delegate/tasks", "r") as fl:
            lines = fl.readlines()
        for l in lines:
            try:
                with open("/proc/%s/smaps" % l.strip(), "r") as fl:
                    fl.readlines()
            except:
                pass

pid = os.fork()
if pid == 0:
    do_threads()
    exit(0)

try:
     mkdir('/sys/fs/cgroup/memory/ck')
     mkdir('/sys/fs/cgroup/memory/ck/1001')
     mkdir('/sys/fs/cgroup/memory/ck/1001/delegate')
except:
    pass

with open('/sys/fs/cgroup/memory/ck/1001/delegate/tasks', 'w') as fl:
    fl.write('%d\n' % pid)

do_reader(pid)

--Apple-Mail=_B52FF222-F8D3-4E8E-9365-30917EB69824--
