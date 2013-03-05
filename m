Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3CETlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:41:23 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65203 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CETlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:41:22 -0500
Date: Tue, 5 Mar 2013 11:40:39 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Will Huck <will.huckk@gmail.com>
cc: Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tmpfs: fix mempolicy object leaks
In-Reply-To: <5133E178.90405@gmail.com>
Message-ID: <alpine.LNX.2.00.1303051101350.27525@eggly.anvils>
References: <1361344302-26565-1-git-send-email-gthelen@google.com> <1361344302-26565-2-git-send-email-gthelen@google.com> <alpine.LNX.2.00.1302201221270.1152@eggly.anvils> <5133E178.90405@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Will Huck wrote:
> 
> Could you explain me why shmem has more relationship with mempolicy? It seems
> that there are many codes in shmem handle mempolicy, but other components in
> mm subsystem just have little.

NUMA mempolicy is mostly handled in mm/mempolicy.c, which services the
mbind, migrate_pages, set_mempolicy, get_mempolicy system calls: which
govern how process memory is distributed across NUMA nodes.

mm/shmem.c is affected because it was also found useful to specify
mempolicy on the shared memory objects which may back process memory:
that includes SysV SHM and POSIX shared memory and tmpfs.  mm/hugetlb.c
contains some mempolicy handling for hugetlbfs; fs/ramfs is kept minimal,
so nothing in there.

Those are the memory-based filesystems, where NUMA mempolicy is most
natural.  The regular filesystems could support shared mempolicy too,
but that would raise more awkward design questions.

Hugh
