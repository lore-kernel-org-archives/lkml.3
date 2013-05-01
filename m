Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639Ab3EAP5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:57:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39852 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3EAP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:57:40 -0400
Date: Wed, 1 May 2013 08:57:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
cc: xfs@oss.sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: deadlock on vmap_area_lock
In-Reply-To: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
Message-ID: <alpine.DEB.2.02.1305010855440.4547@chino.kir.corp.google.com>
References: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Shawn Bohrer wrote:

> I've got two compute clusters with around 350 machines each which are
> running kernels based off of 3.1.9 (Yes I realize this is ancient by
> todays standards).  All of the machines run a 'find' command once an
> hour on one of the mounted XFS filesystems.  Occasionally these find
> commands get stuck requiring a reboot of the system.  I took a peek
> today and see this with perf:
> 
>     72.22%          find  [kernel.kallsyms]          [k] _raw_spin_lock
>                     |
>                     --- _raw_spin_lock
>                        |          
>                        |--98.84%-- vm_map_ram
>                        |          _xfs_buf_map_pages
>                        |          xfs_buf_get
>                        |          xfs_buf_read
>                        |          xfs_trans_read_buf
>                        |          xfs_da_do_buf
>                        |          xfs_da_read_buf
>                        |          xfs_dir2_block_getdents
>                        |          xfs_readdir
>                        |          xfs_file_readdir
>                        |          vfs_readdir
>                        |          sys_getdents
>                        |          system_call_fastpath
>                        |          __getdents64
>                        |          
>                        |--1.12%-- _xfs_buf_map_pages
>                        |          xfs_buf_get
>                        |          xfs_buf_read
>                        |          xfs_trans_read_buf
>                        |          xfs_da_do_buf
>                        |          xfs_da_read_buf
>                        |          xfs_dir2_block_getdents
>                        |          xfs_readdir
>                        |          xfs_file_readdir
>                        |          vfs_readdir
>                        |          sys_getdents
>                        |          system_call_fastpath
>                        |          __getdents64
>                         --0.04%-- [...]
> 
> Looking at the code my best guess is that we are spinning on
> vmap_area_lock, but I could be wrong.  This is the only process
> spinning on the machine so I'm assuming either another process has
> blocked while holding the lock, or perhaps this find process has tried
> to acquire the vmap_area_lock twice?
> 

Significant spinlock contention doesn't necessarily mean that there's a 
deadlock, but it also doesn't mean the opposite.  Depending on your 
definition of "occassionally", would it be possible to run with 
CONFIG_PROVE_LOCKING and CONFIG_LOCKDEP to see if it uncovers any real 
deadlock potential?
