Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3EMSZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:25:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:52134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3EMSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:25:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Maluka <D.Maluka@adbglobal.com>
Subject: Yet another page fault deadlock
Date: Mon, 13 May 2013 21:13:36 +0300
Message-ID: <kmrak0$ip1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 193.105.30.100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sometimes we run into an interesting deadlock on mm->mmap_sem. I see it
is similar to these deadlocks:

https://lkml.org/lkml/2005/2/22/123
https://lkml.org/lkml/2001/9/17/105

in the sense that it is too triggered by page faults and is explained by
"fair" rwsem semantics (pending write lock blocks further read locks).

First, let me describe the prerequisites. It is an embedded MIPS
platform. We have 2 custom kernel drivers (call them A and B):

- Driver A implements hardware encryption/decryption. It acts both as a
char device driver and as an in-kernel library with an API allowing
other kernel modules to encrypt/decrypt data. Important point: driver A
uses a single mutex (call it A_mutex) to protect all its operations,
regardless of whether they are requested by user space or by another
kernel module.

- Driver B is a block device driver implementing a transparent encrypted
storage. It uses driver A's in-kernel API for encryption during write
and decryption during read.

We have squashfs mounted on a block device provided by driver B. And we
have a user-space process with a plenty of threads in it (call them
thread 1, 2, 3, ...).

Now, the sequence leading to the deadlock:

1. Thread 1 needs to encrypt or decrypt some data. It uses char device
interface provided by driver A. Upon driver entry, it first locks A_mutex.

2. Thread 2 reads from a mmap'ed file on squashfs. Page fault is
generated. do_page_fault() read-locks mm->mmap_sem. Then squashfs
filemap fault handler is called, then read request is sent to driver B,
then driver B calls an API function from driver A. This function first
tries to lock A_mutex, and hangs on it.

3. Thread 3 does a syscall which requires mm->mmap_sem write-locked
(sometimes it is mmap, sometimes mprotect). It hangs on mm->mmap_sem.

4. Thread 1 proceeds with handling the request from user space from step
1. During copy_to_user() or copy_from_user() page fault is generated.
do_page_fault() tries to read-lock mm->mmap_sem and hangs on it.

This deadlock does not happen if we memset() the entire user space
buffer in thread 1 before doing the syscall. I.e. we make sure that the
buffer is fully mapped before the request to driver A, preventing demand
paging during copy_to/from_user(). We are currently using it as a
workaround.

So... I realize that in our case the deadlock is caused by our
proprietary component (driver A) whose authors were smart guys but not
farsighted enough to anticipate this scenario. Now we are considering
reworking driver A to make all copy_to/from_user() calls without A_mutex
locked. This should remove the deadlock source, AFAICS.

However, it looks like a general internal kernel architecture problem.
The whole page fault handling procedure is done with mm->mmap_sem
read-held, and due to rwsem semantics, down_read/down_write/down_read
deadlock may happen if two threads are getting page fault and a third
thread is trying to write-lock mm->mmap_sem. So all the code performing
page fault handling procedure should be especially careful about
avoiding such deadlock. But this is a complex procedure involving
different subsystems, particularly, arbitrary block device driver. So
any block device driver should be implemented with this in mind. While
this is probably not documented anywhere.

Perhaps the rule to avoid deadlocks should be "do not write a block
device driver which protects its I/O with the same lock which is used to
protect copy_to_user or copy_from_user operations elsewhere". From the
wording it might seem that any sane driver should follow this anyway.
But as you can see, in more complex cases (like our driver B using
driver A) it is not so obvious.

So I'm reporting this because it seems worth at least discussing, even
if there is nothing to fix in vanilla kernel.

