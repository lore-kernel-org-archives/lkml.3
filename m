Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBEOjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:39:52 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:33636 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaBEOjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:39:51 -0500
From: Glyn Normington <gnormington@gopivotal.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: Attaching a cgroup subsystem to multiple hierarchies
Message-Id: <050BD595-BE55-401D-9B61-E877FB9F06A8@gopivotal.com>
Date: Wed, 5 Feb 2014 14:39:52 +0000
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading cgroups.txt and casting around the net leads me to believe that it is possible to attach a cgroup subsystem (e.g. memory) to multiple hierarchies, but this seems to result in “mirrored” hierarchies which are automatically kept in step with each other - essentially it looks like the same hierarchy at multiple file system paths.

Take the following interaction for example:

\begin{verbatim}
$ pwd   
/home/vagrant
$ mkdir mem1
$ mkdir mem2
$ sudo su
# mount -t cgroup -o memory none /home/vagrant/mem1
# mount -t cgroup -o memory none /home/vagrant/mem2
# cd mem1
# mkdir inst1  
# ls inst1 
cgroup.clone_children  memory.failcnt ...
# ls ../mem2
cgroup.clone_children  inst1 memory.limit_in_bytes ...
# cd inst1
# echo 1000000 > memory.limit_in_bytes 
# cat memory.limit_in_bytes 
1003520
# cat ../../mem2/inst1/memory.limit_in_bytes 
1003520
# echo $$ > tasks
# cat tasks
1365
1409
# cat ../../mem2/inst1/tasks
1365
1411

Is this working as intended? Is there some other way to attach a subsystem to *distinct* hierarchies? Distinct hierarchies would allow distinct cgroups, distinct settings (e.g. memory.limit_in_bytes) and distinct partitions of the tasks in the system.

Note: I don’t have a good use for this function - I’m simply trying to reverse engineer the semantics of cgroups to get a precise understanding.

Glyn