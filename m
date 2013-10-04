Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3JDKal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:30:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47354 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JDKaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:30:39 -0400
Subject: [RFC] [PATCH 00/19] Non disruptive application core dump
 infrastructure using task_work_add()
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:00:12 +0530
Message-ID: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-6102-0000-0000-00000447AA60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following series implements an infrastructure for capturing the core of an 
application without disrupting its process.

So ideally what we are trying to do is to export the infrastructure using
/proc/pid/core. Reading the file would give an ELF Format core-dump at that
instant non-disruptively, without sending signals.

This would involve basically three operations:

1) Holding the threads of a process without sending a signal (SIGSTOP). At this
point we can collect the register set snapshot and collect other information
required to  create the ELF header. The above operation could be initiated with
the open() call.

2) Once the ELF header is created, read() can return the CORE DUMP data
including, the process memory page-by-page, based on the fpos (file position).

3) The threads could be released upon a close().

We discussed various approaches for the implemenation in the post given below.
-https://lkml.org/lkml/2013/9/3/122

This series is based on the Task work add approach. We didn't adopt the CRIU
approch because of the following reasons:

* It is not upstream yet.

* There are concerns about the security of the dump.

* It involves a lot of changes and this approach provides a UNIX style 
  interface.

Task work add

task_work_add() is an interface and an API. The task work add will run any
queued work before returning to user space from the kernel. So that work is
guaranteed to be done before user space can run again. So basically it queues a 
work for a task which is guaranteed to be executed when the task returns from 
kernel space to user space.

* Exploit this function to hold the threads when they are returning to the
  user space.

* Wait until all the threads of the process to be dumped, reach task_work_add.

* Once all the threads have reached, the dump is taken and they are released.

TODO:

* A mechanism to know when all the threads have reached the task added.

* A way to handle a case when one of the threads of the task to be dumped
  is blocked in the kernel.

* We could also add the infrastructure under a config option,
  say:CONFIG_ELF_GENCORE

* The current implementation doesn't wait for the threads to reach 
  wait_for_completion(). Hence there is no guarantee of collecting the
  'register set' reliably. We will address this issue in the next version.
  This is a prototype implementation to get reviews and comments.

Patches 1 to 8 deals with re-arranging the ELF code to be reusable by the
infrastructure.

Patches 9 to 19 implements the infrastructure.

Please let me know your reviews and comments.

Janani Venkataraman (19):
      Create elfcore-common.c for ELF class independent core generation helpers
      Make vma_dump_size() generic
      Make fill_psinfo generic
      Rename compat versions of the reusable core generation routines
      Export the reusable ELF core generation routines
      Define API for reading arch specif Program Headers for Core
      ia64 impelementation for elf_core_copy_extra_phdrs()
      elf_core_copy_extra_phdrs() for UML
      Create /proc/pid/core entry
      Track the core generation requests
      Check if the process is an ELF executable
      Hold the threads using task_work_add
      Create ELF Header
      Create ELF Core notes Data
      Calculate the size of the core file
      Generate the data sections for ELF Core
      Identify the ELF class of the process
      Adding support for compat ELF class data structures
      Compat ELF class core generation support


 arch/ia64/kernel/elfcore.c       |   34 +++
 arch/x86/um/elfcore.c            |   32 +++
 fs/Makefile                      |    1 
 fs/binfmt_elf.c                  |  190 ++--------------
 fs/compat_binfmt_elf.c           |    7 +
 fs/elfcore-common.c              |  169 ++++++++++++++
 fs/proc/Makefile                 |    2 
 fs/proc/base.c                   |    2 
 fs/proc/gencore-compat-elf.c     |   62 +++++
 fs/proc/gencore-elf.c            |  458 ++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.c                |  262 ++++++++++++++++++++++
 fs/proc/gencore.h                |   74 ++++++
 fs/proc/internal.h               |    1 
 include/linux/elfcore-internal.h |   72 ++++++
 include/linux/elfcore.h          |    3 
 kernel/elfcore.c                 |    6 
 16 files changed, 1209 insertions(+), 166 deletions(-)
 create mode 100644 fs/elfcore-common.c
 create mode 100644 fs/proc/gencore-compat-elf.c
 create mode 100644 fs/proc/gencore-elf.c
 create mode 100644 fs/proc/gencore.c
 create mode 100644 fs/proc/gencore.h
 create mode 100644 include/linux/elfcore-internal.h

-- 
Janani 

