Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3KFLsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:23 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62478 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3KFLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:16 -0500
Message-Id: <20131106114742.988532945@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/7] Rework file::show_fdinfo method to use seq-files engine, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, in criu we intensively use additional information provided by
/proc/<pid>/fdinfo/<fd> particular to the object opened file
represents. The output is printed out by calling the
file_operations::show_fdinfo method.

The implementation implies that data is getting printed in one
pass and returns error in case if seq buffer is overflowed, which
works fine while data fit one memory page. For epoll it's about
73 epoll targets can be printed, for notify system -- significantly
less depending on notify type and file handler. This limitation
didn't cause any problems in applications we're checkpointing
and restoring at moment, but might become a problem in future.

So to resolve the problem I considered two ways

1) Don't return error if seq-buffer overflowed thus, one
   show() method is called the kernel will notice that buffer is
   overflowed and double its size returning -EAGAIN. But I fear such
   interface might be misused (say process creates epoll with a number
   of target descriptors, then application opens a big number of fdinfo
   reader causing kernel to allocate big seq-buffer for each reader).

2) Instead of printing fdinfo in one pass rather provide seq-operations
   pointer in file_operations, and subsystems which need it simply hook
   own seq-operations here. The main code in fs/proc/fd.c will call for
   underlied seq-operation methods.

The second way looks more preferrable from my POV, here is the series.
Please take a look, thanks. Any comments are highly appreciated!
