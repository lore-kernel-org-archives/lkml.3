Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaHAObm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:31:42 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58434 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaHAObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140801125045.GA21624@htj.dyndns.org>
References: <1406891892-10992-1-git-send-email-nasa4836@gmail.com> <20140801125045.GA21624@htj.dyndns.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Fri, 1 Aug 2014 22:31:00 +0800
Message-ID: <CAHz2CGXpG2RYNkWHdoj947HUD6ns-CwkOH82n2DJ8cegEogHQw@mail.gmail.com>
Subject: Re: [PATCH RFC] sysfs: fix the race of "parent deleted before child added"
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <Jianyu.Zhan@emc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, tj,

On Fri, Aug 1, 2014 at 8:50 PM, Tejun Heo <tj@kernel.org> wrote:
> The *only* reason we have the warning at all is because the driver
> model wants to enforce that destruction is performed in the proper
> order and what you're doing is just circumventing the detection logic.
> We might as well just remove it.  Please track down why the specific
> warning that you saw happened.  We wanna learn about them and fix
> them.

The problem I met is in an old kernel, in sysfs_create_dir(),  at thie line:

   sysfs_create_dir()
       if (kobj->parent)
            parent = kobj->parent->sd;

I found kobj->parent is valid, so parent == kobj->parent->sd,
then it is passed into create_dir() function, in which it is dereferenced,
however  the parent passed in is NULL, so a panic.

Apprently, there is a race, as my case is a test of fast removal and plugging
of a block device.

The race is that the kerfs_node(was sysfs_dirent) is disassociated with
parent kobject, but parent kobject is still alive, so we saw it.

And the commit 3a198886 ("sysfs: handle 'parent deleted before child added'")
add a parent NULLness check before calling into create_dir(),  but I think this
isn't the real fix, it just narrow down the racy window.


Thanks,
Jianyu Zhan
