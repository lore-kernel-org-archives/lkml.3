Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3KAUsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:48:14 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44901 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3KAUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:48:11 -0400
MIME-Version: 1.0
Date: Fri, 1 Nov 2013 13:48:10 -0700
Message-ID: <CAOMFOmWzERR7MDe65YHo--GdbO+QfnxZK=uWd7d3vCZ6ca97fw@mail.gmail.com>
Subject: Solving M produces N consumers scalability problem
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking at fuse scalabily issue that I hit recently on my
multi-socket server machines
http://permalink.gmane.org/gmane.comp.file-systems.fuse.devel/13490

The short description is that we have several thousands threads that
make filesystem access to a fuse fs. Fuse spawns several threads
(usually 4-8) that read the requests from kernel process it and write
response back to the kernel.

The problem is that fuse kernel module uses a global list where it
keeps all active requests. But both consumers and producers are at
different CPU's and getting lock to access the list is very expensive
operation. I have a test case that shows ~35% of the system time is
spent in _raw_spin_lock when accessing to this global list. I want to
solve this scalability problem.

One idea is not to use the spin_lock. It is the 'fair spin_lock' that
has scalability problems
http://pdos.csail.mit.edu/papers/linux:lock.pdf Maybe lockless
datastructures can help here?

Another idea is avoid global datasctructures but I have a few
questions here. Let's say we want to use per-CPU lists. But the
problem is that producers/consumers are not distributed across all
CPUs. Some CPU might have too many producers, some other might not
have consumers at all. So we need some kind of migration from hot CPU
to the cold one. What is the best way to achieve it? Are there any
examples how to do this? Any other ideas?
