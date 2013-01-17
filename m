Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3AQOwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:52:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3AQOwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:52:12 -0500
Date: Thu, 17 Jan 2013 09:52:08 -0500
From: Dave Jones <davej@redhat.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: __list_del_entry in lib/list_debug.c does not delete
 the node if the list is corrupted
Message-ID: <20130117145208.GA32586@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Shankar Brahadeeswaran <shankoo77@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAJsYZ5m5hJ8vUEz-H1NeO4dNGLLfuSU8EwnA3z9RmCNqJv-ebA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsYZ5m5hJ8vUEz-H1NeO4dNGLLfuSU8EwnA3z9RmCNqJv-ebA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 03:53:11PM +0530, Shankar Brahadeeswaran wrote:
 > Hi,
 > The following is the Bug Report on list_debug.c implementation.
 > 
 > [1.] The __list_del_entry implemented in lib/list_debug.c does not
 > delete the node if the list is corrupted
 > 
 > [2.] Full description of the problem/report:
 > The function __list_del_entry implemented in include/linux/list.h
 > always removes the node from the list it belongs to.
 > But the same function implemented in lib/list_debug.c does not remove
 > the node if the list it belongs to is corrupted.
 > So based on whether CONFIG_DEBUG_LIST  is defined or not the behavior
 > of the function __list_del_entry changes
 
If the list is corrupt, we don't know if it's safe to do further
manipulation. Those nodes could be pointing anywhere, and dereferencing them
could lead to oopses, GPFs or even lockups depending on config options,
and what the corrupt pointers are.

 > [2.1] Use Case in which the problem is seen (Assume that
 > CONFIG_DEBUG_LIST is defined so implementation used is from
 > list_debug.c)
 > In the AOSP kernel version the file dpm_prepare in file
 > drivers/base/power/main.c moves the "device" from dpm_list to
 > dpm_prepare list.
 > The following line of code does it.
 > 
 > list_move_tail(&dev->power.entry, &dpm_prepared_list);
 > 
 > Now the implementation of list_move_tail (include/linux/list.h) is as follows
 >         __list_del_entry(list);
 >         list_add_tail(list, head);
 > 
 > If the list in which &dev->power.entry lives (dpm_list) is corrupted
 > then the first call will not delete the node (Warning is thrown and
 > returns)

Find out why that list is corrupt, and fix that.

	Dave

