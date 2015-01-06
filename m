Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbbAFXOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:14:43 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:32857 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbAFXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:14:42 -0500
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 15:14:41 -0800
Message-ID: <CAOvWMLZkisXOcxwo6AvKnwG_pEybmB27ZHUiUppcHNGM=c_cDg@mail.gmail.com>
Subject: MAP_POPULATE does not work with XIP on ramdisk
From: Andiry Xu <andiry@gmail.com>
To: linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>
Cc: Andiry Xu <andiry.xu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm testing mmap() performance on a ramdisk. The kernel is 3.19-rc3.

The device driver is brd, and the file system is ext2. Normal mmap()
does not make sense on a ramdisk because it adds additional memory
copy, so XIP is enabled to map the pages directly into application's
address space.

With XIP, MAP_POPULATE flag does not work. i.e. prefault fails.
Basically it fails in vm_normal_page(), where it's supposed to find
the struct page from pfn, but the vma has flag VM_MIXEDMAP and the
method returns NULL.

As I understand, VM_MIXEDMAP means the memory may not contain a struct
page backing, so the code logic is reasonable. However brd driver does
provide struct page for each memory page. If I modify the
__get_user_pages() and let the prefault runs for all the pages,
MAP_POPULATE works as expected.

My question is, is there any elegant way to workaround this? I do want
to make MAP_POPULATE works with XIP. This is because as the device is
memory and access latency is pretty low, page fault as well as the
mode switch play an important part in the software overhead. In my
experiment, MAP_POPULATE provides a 3x improvement on latency when
access a big file for the first time.

Thanks,
Andiry
