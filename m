Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab3GZNjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:39:04 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:46722 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3GZNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:39:01 -0400
Date: Fri, 26 Jul 2013 09:38:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Dennis Chen <xschen@tnsoft.com.cn>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] race condition fixing in sysfs_create_dir
Message-ID: <20130726133856.GD3013@htj.dyndns.org>
References: <51F24612.6030509@tnsoft.com.cn>
 <51F24864.7070306@tnsoft.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F24864.7070306@tnsoft.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 26, 2013 at 05:59:00PM +0800, Dennis Chen wrote:
> On 07/26/2013 05:49 PM, Dennis Chen wrote:
> 
> >The patch is trying its best to avoid creating a dir under a parent dir which is removing from
> >the system:
> >     PATH0 (create a dir under 'PARENT/...')         PATH1 (remove the 'PARENT/...')
> >          sysfs_create_dir() {                         sysfs_remove_dir() {
> >          ...                                          ...
> >          if (kobj->parent)                            spin_lock(&sysfs_assoc_lock);
> >         parent_sd = kobj->parent->sd;  <----- kobj->sd = NULL;
> >      else                                         spin_unlock(&sysfs_assoc_lock);
> >         parent_sd = &sysfs_root;
> >Suppose PATH1 enter the critical section first, then PATH0 begin to execute before kobj->sd
> >has been reset to NULL, possibly PATH0 will get a non-NULL parent_sd since lack of the
> >sysfs_assoc_lock protection in PATH0. In this case, PATH0 think it has a valid parent_sd which
> >can be freed by PATH1 in the followed, refer to the comments in the patch. Maybe we need
> >to figure out a perfect solution to solve the race condition, although the codes in question are
> >in slow path...

I don't think sysfs is supposed to handle multiple actors trying to
populate and destroy the directory at the same time at all, so this
seems kinda moot.  Do you have a case where this actually matters?

Thanks.

-- 
tejun
