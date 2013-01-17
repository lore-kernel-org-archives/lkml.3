Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab3AQKXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:23:14 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39861 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493Ab3AQKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:23:12 -0500
MIME-Version: 1.0
Date: Thu, 17 Jan 2013 15:53:11 +0530
Message-ID: <CAJsYZ5m5hJ8vUEz-H1NeO4dNGLLfuSU8EwnA3z9RmCNqJv-ebA@mail.gmail.com>
Subject: PROBLEM: __list_del_entry in lib/list_debug.c does not delete the
 node if the list is corrupted
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: linux-kernel@vger.kernel.org, Shankar Brahadeeswaran <shankoo77@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The following is the Bug Report on list_debug.c implementation.

[1.] The __list_del_entry implemented in lib/list_debug.c does not
delete the node if the list is corrupted

[2.] Full description of the problem/report:
The function __list_del_entry implemented in include/linux/list.h
always removes the node from the list it belongs to.
But the same function implemented in lib/list_debug.c does not remove
the node if the list it belongs to is corrupted.
So based on whether CONFIG_DEBUG_LIST  is defined or not the behavior
of the function __list_del_entry changes

<Snap shot of the code from list_debug.c below>
if (WARN(next == LIST_POISON1,
                "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
                entry, LIST_POISON1) ||
            WARN(prev == LIST_POISON2,
                "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
                entry, LIST_POISON2) ||
            WARN(prev->next != entry,
                "list_del corruption. prev->next should be %p, "
                "but was %p\n", entry, prev->next) ||
            WARN(next->prev != entry,
                "list_del corruption. next->prev should be %p, "
                "but was %p\n", entry, next->prev))
                return;    <------- If  list is corrupted as caught by
the conditions above, this simply returns.

Please note that since this function does not return anything, the
caller always assumes that the node is removed from the list.

[2.1] Use Case in which the problem is seen (Assume that
CONFIG_DEBUG_LIST is defined so implementation used is from
list_debug.c)
In the AOSP kernel version the file dpm_prepare in file
drivers/base/power/main.c moves the "device" from dpm_list to
dpm_prepare list.
The following line of code does it.

list_move_tail(&dev->power.entry, &dpm_prepared_list);

Now the implementation of list_move_tail (include/linux/list.h) is as follows
        __list_del_entry(list);
        list_add_tail(list, head);

If the list in which &dev->power.entry lives (dpm_list) is corrupted
then the first call will not delete the node (Warning is thrown and
returns)
But the second call i.e list_add_tail would anyway add the node to
another list pointed by head (dpm_prepared_list).
So if dpm_list is corrupted when moving one node from dpm_list to
dpm_prepared_list, we'll wrongly merge both the lists.
Now that since these two lists are merged, the sub-system breaks down.
Here there is no way for the caller of __list_del_entry to know
whether the node is actually deleted or not.
Basically the behavior of the function __list_del_entry changes based
on whether CONFIG_DEBUG_LIST is defined or not.

Note that the example I mentioned is from AOSP, but the same scenario
can be encountered in mainline kernel as well.

[3.] Keywords: list_debug, dpm_prepare, CONFIG_DEBUG_LIST

[4.] Kernel information
Version 3.0.15 (AOSP version from google)
ARM Architecture port.

[X.] Other notes, patches, fixes, workarounds:
In my humble opinion, the function __list_del_entry can be modified to
remove the "if" condition and "return" statement.
So that it helps the user in catching the corruption, but also does
not alter the system behavior
void __list_del_entry(struct list_head *entry)
{
....
          WARN(next == LIST_POISON1,
                "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
                entry, LIST_POISON1) ||
            WARN(prev == LIST_POISON2,
                "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
                entry, LIST_POISON2) ||
            WARN(prev->next != entry,
                "list_del corruption. prev->next should be %p, "
                "but was %p\n", entry, prev->next) ||
            WARN(next->prev != entry,
                "list_del corruption. next->prev should be %p, "
                "but was %p\n", entry, next->prev))
    __list_del(prev, next);
}

Please provide your feedback on the suggestion.
If the suggestion is OK, am I allowed to send the patch for the same?

PS: Please mark a copy of the reply to my email id since I'm not
subscribed to linux-kernel@vger.kernel.org

Warm Regards,
Shankar  Brahadeeswaran
