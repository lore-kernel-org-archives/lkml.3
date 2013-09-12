Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3ILTqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:46:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37339 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3ILTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:46:30 -0400
Date: Thu, 12 Sep 2013 15:46:22 -0400 (EDT)
Message-Id: <20130912.154622.1374963493079488096.davem@davemloft.net>
To: tj@kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        ebiederm@xmission.com, netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 2/7] sysfs: make attr namespace interface less
 convoluted
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378952949-7900-3-git-send-email-tj@kernel.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
	<1378952949-7900-3-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Sep 2013 12:46:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 11 Sep 2013 22:29:04 -0400

> sysfs ns (namespace) implementation became more convoluted than
> necessary while trying to hide ns information from visible interface.
> The relatively recent attr ns support is a good example.
> 
> * attr ns tag is determined by sysfs_ops->namespace() callback while
>   dir tag is determined by kobj_type->namespace().  The placement is
>   arbitrary.
> 
> * Instead of performing operations with explicit ns tag, the namespace
>   callback is routed through sysfs_attr_ns(), sysfs_ops->namespace(),
>   class_attr_namespace(), class_attr->namespace().  It's not simpler
>   in any sense.  The only thing this convolution does is traversing
>   the whole stack backwards.
> 
> The namespace callbacks are unncessary because the operations involved
> are inherently synchronous.  The information can be provided in in
> straight-forward top-down direction and reversing that direction is
> unnecessary and against basic design principles.
> 
> This backward interface is unnecessarily convoluted and hinders
> properly separating out sysfs from driver model / kobject for proper
> layering.  This patch updates attr ns support such that
> 
> * sysfs_ops->namespace() and class_attr->namespace() are dropped.
> 
> * sysfs_{create|remove}_file_ns(), which take explicit @ns param, are
>   added and sysfs_{create|remove}_file() are now simple wrappers
>   around the ns aware functions.
> 
> * ns handling is dropped from sysfs_chmod_file().  Nobody uses it at
>   this point.  sysfs_chmod_file_ns() can be added later if necessary.
> 
> * Explicit @ns is propagated through class_{create|remove}_file_ns()
>   and netdev_class_{create|remove}_file_ns().
> 
> * driver/net/bonding which is currently the only user of attr
>   namespace is updated to use netdev_class_{create|remove}_file_ns()
>   with @bh->net as the ns tag instead of using the namespace callback.
> 
> This patch should be an equivalent conversion without any functional
> difference.  It makes the code easier to follow, reduces lines of code
> a bit and helps proper separation and layering.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
